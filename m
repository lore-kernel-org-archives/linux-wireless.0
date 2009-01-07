Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:56787 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759658AbZAGRfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 12:35:43 -0500
Message-ID: <4964E79B.8070609@openwrt.org> (sfid-20090107_183603_787579_5E6092E7)
Date: Wed, 07 Jan 2009 18:34:19 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH 04/11] ath9k: introduce bus specific cleanup routine
References: <1231322972-24094-1-git-send-email-juhosg@openwrt.org>	 <1231322972-24094-5-git-send-email-juhosg@openwrt.org>	 (sfid-20090107_111132_955895_E4ACE8AD) <1231323852.3545.22.camel@johannes>
In-Reply-To: <1231323852.3545.22.camel@johannes>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg =EDrta:
> On Wed, 2009-01-07 at 11:09 +0100, Gabor Juhos wrote:
>=20
>>  			/* Deinitialize the device */
>> -			ath_detach(sc);
>> -			if (to_pci_dev(sc->dev)->irq)
>> -				free_irq(to_pci_dev(sc->dev)->irq, sc);
>> -			pci_iounmap(to_pci_dev(sc->dev), sc->mem);
>> -			pci_release_region(to_pci_dev(sc->dev), 0);
>> -			pci_disable_device(to_pci_dev(sc->dev));
>> -			ieee80211_free_hw(sc->hw);
>> +			ath_bus_cleanup(sc);
>=20
> And how is ath_detach() or ieee80211_free_hw() bus specific? That sho=
uld
> not be in the bus specific function.
>=20
> johannes

You are right. I guess this looks better:

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/a=
th9k/core.h
index 8e93d11..f9fa5c6 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -695,6 +695,7 @@ enum PROT_MODE {
=20
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
+	void		(*cleanup)(struct ath_softc *sc);
 };
=20
 struct ath_softc {
@@ -704,6 +705,7 @@ struct ath_softc {
 	struct tasklet_struct bcon_tasklet;
 	struct ath_hal *sc_ah;
 	void __iomem *mem;
+	int irq;
 	spinlock_t sc_resetlock;
 	struct mutex mutex;
=20
@@ -760,4 +762,9 @@ static inline void ath_read_cachesize(struct ath_so=
ftc *sc, int *csz)
 	sc->bus_ops->read_cachesize(sc, csz);
 }
=20
+static inline void ath_bus_cleanup(struct ath_softc *sc)
+{
+	sc->bus_ops->cleanup(sc);
+}
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/a=
th9k/main.c
index 15824c1..349ac17 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -39,6 +39,7 @@ static struct pci_device_id ath_pci_id_table[] __devi=
nitdata =3D {
 };
=20
 static void ath_detach(struct ath_softc *sc);
+static void ath_cleanup(struct ath_softc *sc);
=20
 /* return bus cachesize in 4B word units */
=20
@@ -1267,13 +1268,7 @@ static int ath_start_rfkill_poll(struct ath_soft=
c *sc)
 			rfkill_free(sc->rf_kill.rfkill);
=20
 			/* Deinitialize the device */
-			ath_detach(sc);
-			if (to_pci_dev(sc->dev)->irq)
-				free_irq(to_pci_dev(sc->dev)->irq, sc);
-			pci_iounmap(to_pci_dev(sc->dev), sc->mem);
-			pci_release_region(to_pci_dev(sc->dev), 0);
-			pci_disable_device(to_pci_dev(sc->dev));
-			ieee80211_free_hw(sc->hw);
+			ath_cleanup(sc);
 			return -EIO;
 		} else {
 			sc->sc_flags |=3D SC_OP_RFKILL_REGISTERED;
@@ -1284,6 +1279,16 @@ static int ath_start_rfkill_poll(struct ath_soft=
c *sc)
 }
 #endif /* CONFIG_RFKILL */
=20
+static void ath_cleanup(struct ath_softc *sc)
+{
+	struct pci_dev *pdev =3D to_pci_dev(sc->dev);
+
+	ath_detach(sc);
+	free_irq(sc->irq, sc);
+	ath_bus_cleanup(sc);
+	ieee80211_free_hw(sc->hw);
+}
+
 static void ath_detach(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw =3D sc->hw;
@@ -2529,8 +2534,18 @@ ath_rf_name(u16 rf_version)
 	return "????";
 }
=20
+static void ath_pci_cleanup(struct ath_softc *sc)
+{
+	struct pci_dev *pdev =3D to_pci_dev(sc->dev);
+
+	pci_iounmap(pdev, sc->mem);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
+}
+
 static struct ath_bus_ops ath_pci_bus_ops =3D {
 	.read_cachesize =3D ath_pci_read_cachesize,
+	.cleanup =3D ath_pci_cleanup,
 };
=20
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device=
_id *id)
@@ -2637,6 +2652,8 @@ static int ath_pci_probe(struct pci_dev *pdev, co=
nst struct pci_device_id *id)
 		goto bad4;
 	}
=20
+	sc->irq =3D pdev->irq;
+
 	ah =3D sc->sc_ah;
 	printk(KERN_INFO
 	       "%s: Atheros AR%s MAC/BB Rev:%x "
@@ -2667,13 +2684,7 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	struct ieee80211_hw *hw =3D pci_get_drvdata(pdev);
 	struct ath_softc *sc =3D hw->priv;
=20
-	ath_detach(sc);
-	if (pdev->irq)
-		free_irq(pdev->irq, sc);
-	pci_iounmap(pdev, sc->mem);
-	pci_release_region(pdev, 0);
-	pci_disable_device(pdev);
-	ieee80211_free_hw(hw);
+	ath_cleanup(sc);
 }
=20
 #ifdef CONFIG_PM
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
