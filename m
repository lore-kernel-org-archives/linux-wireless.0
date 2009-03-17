Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41022 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbZCQNPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 09:15:35 -0400
Date: Tue, 17 Mar 2009 09:12:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net, linux-wireless@vger.kernel.org
Subject: [linville@tuxdriver.com: pull request: wireless-2.6 2009-03-16]
Message-ID: <20090317131248.GB3549@tuxdriver.com> (sfid-20090317_141542_754936_3AF2AD74)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I didn't see this actually show-up on linux-wireless, so I'm forwarding
it along.  Stephen replied to it, but he might have got the original
(since he was CC'ed).  Also MARC had it in their linux-kernel archive,
but I didn't see it in their linux-wireless archive -- wierd.

Anyway, FYI...

John

----- Forwarded message from "John W. Linville" <linville@tuxdriver.com=
> -----

> Date: Mon, 16 Mar 2009 19:14:23 -0400
> From: "John W. Linville" <linville@tuxdriver.com>
> To: davem@davemloft.net
> Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
> 	linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
> Subject: pull request: wireless-2.6 2009-03-16
> User-Agent: Mutt/1.5.18 (2008-05-17)
>=20
> Dave,
>=20
> Here is a group of patches intended for 2.6.29.  The one from me is
> minor, but it cuts-down on log SPAM for ipw2100, ipw2200, and hostap
> users.  The two from Jouni fix some panics he observed himself.
>=20
> The first one from Luis fixes bug 12110 at bugzilla.kernel.org.  I kn=
ow
> he has worked on it for a long time and I've had several desperate us=
ers
> asking for it, so it must be good. :-)  Unfortunately, it causes some
> nasty merge errors with what is in net-next-2.6 and wireless-next-2.6=
=2E
> I created a merge-test branch in wireless-next-2.6, and the merge com=
mit
> log goes into more detail about resolving the issue.  In short, you
> probably want to diff drivers/net/ath9k against the merge-test branch=
=2E..
>=20
> Please let me know if there are problems!
>=20
> Thanks,
>=20
> John
>=20
> ---
>=20
> Individual patches are available here:
>=20
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/
>=20
> ---
>=20
> The following changes since commit ea8dbdd17099a9a5864ebd4c87e01e657b=
19c7ab:
>   fran=E7ois romieu (1):
>         r8169: revert "r8169: read MAC address from EEPROM on init (2=
nd attempt)"
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6=
=2Egit master
>=20
> John W. Linville (1):
>       lib80211: silence excessive crypto debugging messages
>=20
> Jouni Malinen (2):
>       mac80211: Fix panic on fragmentation with power saving
>       zd1211rw: Do not panic on device eject when associated
>=20
> Luis R. Rodriguez (2):
>       ath9k: implement IO serialization
>       ath9k: AR9280 PCI devices must serialize IO as well
>=20
>  drivers/net/wireless/ath9k/ath9k.h     |    4 +-
>  drivers/net/wireless/ath9k/core.h      |   33 ++++++++++++++++++++++=
++++++++++
>  drivers/net/wireless/ath9k/hw.c        |   22 ++++++++++++++++++++-
>  drivers/net/wireless/ath9k/main.c      |    1 +
>  drivers/net/wireless/zd1211rw/zd_mac.c |    8 +++++-
>  net/mac80211/tx.c                      |    2 +
>  net/wireless/Kconfig                   |   10 +++++++++
>  net/wireless/lib80211_crypt_ccmp.c     |    2 +
>  net/wireless/lib80211_crypt_tkip.c     |    4 +++
>  9 files changed, 81 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireles=
s/ath9k/ath9k.h
> index d278135..6650f60 100644
> --- a/drivers/net/wireless/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath9k/ath9k.h
> @@ -587,8 +587,8 @@ struct ath9k_country_entry {
>  	u8 iso[3];
>  };
> =20
> -#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg=
)
> -#define REG_READ(_ah, _reg) ioread32(_ah->ah_sh + _reg)
> +#define REG_WRITE(_ah, _reg, _val) ath9k_iowrite32((_ah), (_reg), (_=
val))
> +#define REG_READ(_ah, _reg) ath9k_ioread32((_ah), (_reg))
> =20
>  #define SM(_v, _f)  (((_v) << _f##_S) & _f)
>  #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
> diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless=
/ath9k/core.h
> index 4ca2aed..139566c 100644
> --- a/drivers/net/wireless/ath9k/core.h
> +++ b/drivers/net/wireless/ath9k/core.h
> @@ -701,6 +701,7 @@ struct ath_softc {
>  	struct ath_hal *sc_ah;
>  	void __iomem *mem;
>  	spinlock_t sc_resetlock;
> +	spinlock_t sc_serial_rw;
>  	struct mutex mutex;
> =20
>  	u8 sc_curbssid[ETH_ALEN];
> @@ -751,4 +752,36 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc=
 *sc);
>  int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
>  int ath_cabq_update(struct ath_softc *);
> =20
> +/*
> + * Read and write, they both share the same lock. We do this to seri=
alize
> + * reads and writes on Atheros 802.11n PCI devices only. This is req=
uired
> + * as the FIFO on these devices can only accept sanely 2 requests. A=
fter
> + * that the device goes bananas. Serializing the reads/writes preven=
ts this
> + * from happening.
> + */
> +
> +static inline void ath9k_iowrite32(struct ath_hal *ah, u32 reg_offse=
t, u32 val)
> +{
> +	if (ah->ah_config.serialize_regmode =3D=3D SER_REG_MODE_ON) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
> +		iowrite32(val, ah->ah_sc->mem + reg_offset);
> +		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
> +	} else
> +		iowrite32(val, ah->ah_sc->mem + reg_offset);
> +}
> +
> +static inline unsigned int ath9k_ioread32(struct ath_hal *ah, u32 re=
g_offset)
> +{
> +	u32 val;
> +	if (ah->ah_config.serialize_regmode =3D=3D SER_REG_MODE_ON) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
> +		val =3D ioread32(ah->ah_sc->mem + reg_offset);
> +		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
> +	} else
> +		val =3D ioread32(ah->ah_sc->mem + reg_offset);
> +	return val;
> +}
> +
>  #endif /* CORE_H */
> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/a=
th9k/hw.c
> index 34474ed..c38a00b 100644
> --- a/drivers/net/wireless/ath9k/hw.c
> +++ b/drivers/net/wireless/ath9k/hw.c
> @@ -437,6 +437,25 @@ static void ath9k_hw_set_defaults(struct ath_hal=
 *ah)
>  	}
> =20
>  	ah->ah_config.intr_mitigation =3D 1;
> +
> +	/*
> +	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
> +	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
> +	 * This means we use it for all AR5416 devices, and the few
> +	 * minor PCI AR9280 devices out there.
> +	 *
> +	 * Serialization is required because these devices do not handle
> +	 * well the case of two concurrent reads/writes due to the latency
> +	 * involved. During one read/write another read/write can be issued
> +	 * on another CPU while the previous read/write may still be workin=
g
> +	 * on our hardware, if we hit this case the hardware poops in a loo=
p.
> +	 * We prevent this by serializing reads and writes.
> +	 *
> +	 * This issue is not present on PCI-Express devices or pre-AR5416
> +	 * devices (legacy, 802.11abg).
> +	 */
> +	if (num_possible_cpus() > 1)
> +		ah->ah_config.serialize_regmode =3D SER_REG_MODE_AUTO;
>  }
> =20
>  static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
> @@ -668,7 +687,8 @@ static struct ath_hal *ath9k_hw_do_attach(u16 dev=
id, struct ath_softc *sc,
>  	}
> =20
>  	if (ah->ah_config.serialize_regmode =3D=3D SER_REG_MODE_AUTO) {
> -		if (ah->ah_macVersion =3D=3D AR_SREV_VERSION_5416_PCI) {
> +		if (ah->ah_macVersion =3D=3D AR_SREV_VERSION_5416_PCI ||
> +		    (AR_SREV_9280(ah) && !ah->ah_isPciExpress)) {
>  			ah->ah_config.serialize_regmode =3D
>  				SER_REG_MODE_ON;
>  		} else {
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless=
/ath9k/main.c
> index 0e80990..3c04044 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -1336,6 +1336,7 @@ static int ath_init(u16 devid, struct ath_softc=
 *sc)
>  		printk(KERN_ERR "Unable to create debugfs files\n");
> =20
>  	spin_lock_init(&sc->sc_resetlock);
> +	spin_lock_init(&sc->sc_serial_rw);
>  	mutex_init(&sc->mutex);
>  	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
>  	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wir=
eless/zd1211rw/zd_mac.c
> index a611ad8..847057d 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -575,13 +575,17 @@ static int zd_op_tx(struct ieee80211_hw *hw, st=
ruct sk_buff *skb)
> =20
>  	r =3D fill_ctrlset(mac, skb);
>  	if (r)
> -		return r;
> +		goto fail;
> =20
>  	info->rate_driver_data[0] =3D hw;
> =20
>  	r =3D zd_usb_tx(&mac->chip.usb, skb);
>  	if (r)
> -		return r;
> +		goto fail;
> +	return 0;
> +
> +fail:
> +	dev_kfree_skb(skb);
>  	return 0;
>  }
> =20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 94de503..37e3d5e 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -752,6 +752,8 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data =
*tx)
>  		skb_copy_queue_mapping(frag, first);
> =20
>  		frag->do_not_encrypt =3D first->do_not_encrypt;
> +		frag->dev =3D first->dev;
> +		frag->iif =3D first->iif;
> =20
>  		pos +=3D copylen;
>  		left -=3D copylen;
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index e28e2b8..092ae6f 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -102,3 +102,13 @@ config LIB80211_CRYPT_CCMP
> =20
>  config LIB80211_CRYPT_TKIP
>  	tristate
> +
> +config LIB80211_DEBUG
> +	bool "lib80211 debugging messages"
> +	depends on LIB80211
> +	default n
> +	---help---
> +	  You can enable this if you want verbose debugging messages
> +	  from lib80211.
> +
> +	  If unsure, say N.
> diff --git a/net/wireless/lib80211_crypt_ccmp.c b/net/wireless/lib802=
11_crypt_ccmp.c
> index db42819..2301dc1 100644
> --- a/net/wireless/lib80211_crypt_ccmp.c
> +++ b/net/wireless/lib80211_crypt_ccmp.c
> @@ -337,6 +337,7 @@ static int lib80211_ccmp_decrypt(struct sk_buff *=
skb, int hdr_len, void *priv)
>  	pos +=3D 8;
> =20
>  	if (ccmp_replay_check(pn, key->rx_pn)) {
> +#ifdef CONFIG_LIB80211_DEBUG
>  		if (net_ratelimit()) {
>  			printk(KERN_DEBUG "CCMP: replay detected: STA=3D%pM "
>  				 "previous PN %02x%02x%02x%02x%02x%02x "
> @@ -346,6 +347,7 @@ static int lib80211_ccmp_decrypt(struct sk_buff *=
skb, int hdr_len, void *priv)
>  				 key->rx_pn[3], key->rx_pn[4], key->rx_pn[5],
>  				 pn[0], pn[1], pn[2], pn[3], pn[4], pn[5]);
>  		}
> +#endif
>  		key->dot11RSNAStatsCCMPReplays++;
>  		return -4;
>  	}
> diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib802=
11_crypt_tkip.c
> index 7e8e22b..c362873 100644
> --- a/net/wireless/lib80211_crypt_tkip.c
> +++ b/net/wireless/lib80211_crypt_tkip.c
> @@ -465,12 +465,14 @@ static int lib80211_tkip_decrypt(struct sk_buff=
 *skb, int hdr_len, void *priv)
>  	pos +=3D 8;
> =20
>  	if (tkip_replay_check(iv32, iv16, tkey->rx_iv32, tkey->rx_iv16)) {
> +#ifdef CONFIG_LIB80211_DEBUG
>  		if (net_ratelimit()) {
>  			printk(KERN_DEBUG "TKIP: replay detected: STA=3D%pM"
>  			       " previous TSC %08x%04x received TSC "
>  			       "%08x%04x\n", hdr->addr2,
>  			       tkey->rx_iv32, tkey->rx_iv16, iv32, iv16);
>  		}
> +#endif
>  		tkey->dot11RSNAStatsTKIPReplays++;
>  		return -4;
>  	}
> @@ -505,10 +507,12 @@ static int lib80211_tkip_decrypt(struct sk_buff=
 *skb, int hdr_len, void *priv)
>  			 * it needs to be recalculated for the next packet. */
>  			tkey->rx_phase1_done =3D 0;
>  		}
> +#ifdef CONFIG_LIB80211_DEBUG
>  		if (net_ratelimit()) {
>  			printk(KERN_DEBUG "TKIP: ICV error detected: STA=3D"
>  			       "%pM\n", hdr->addr2);
>  		}
> +#endif
>  		tkey->dot11RSNAStatsTKIPICVErrors++;
>  		return -5;
>  	}
> --=20
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.

----- End forwarded message -----

--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
