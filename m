Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34784 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbYJAVfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 17:35:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Kl9La-0007cx-8M
	for linux-wireless@vger.kernel.org; Wed, 01 Oct 2008 21:35:02 +0000
Received: from pd9e87db2.dip.t-dialin.net ([217.232.125.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 21:35:02 +0000
Received: from eo by pd9e87db2.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 21:35:02 +0000
To: linux-wireless@vger.kernel.org
From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: Oops with current kernel and ath5k
Date: Wed, 01 Oct 2008 23:10:37 +0200
Message-ID: <87ej30m376.fsf@denkblock.local> (sfid-20081001_233512_736508_E3A89AFD)
References: <200808101401.03339.toralf.foerster@gmx.de>
	<b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com>
	<200810012055.58085.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: ath5k-devel@lists.ath5k.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toralf F=F6rster <toralf.foerster@gmx.de> wrote:
> Hello,
>
> the issue (initially reported in August 2008) still remains in the cu=
rrent=20
> kernel at my ThinkPad T41, a screen shot is attached. The steps to re=
produce=20
> are :
>
> 1. modprobe it
> 2. suspend the system to ram
> 3. wake it up
> 4. rmmod the driver

Yes, I have run into this problem too. The patch below (applies to
2.6.27-rc8) fixes the problem, but since I'm not a wireless hacker,
developers might prefer a different approach. Please let me know if I
should change anything. Perhaps I should split this into two separate
patches?

Regards,

Elias

---
=46rom: Elias Oltmanns <eo@nebensachen.de>
Subject: ath5k: Do not start the hw unconditionally on resume from s2ra=
m

Currently, ath5k_pci_resume() calls ath5k_init() unconditionally.
Therefore, the following sequence of events leads to a kernel panic:
# modprobe ath5k
suspend to ram
resume
# modprobe -r ath5k
The calibration timer is not stopped even though the structs go away
underneath.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/net/wireless/ath5k/base.c |    8 +++++---
 include/net/mac80211.h            |   11 +++++++++++
 net/mac80211/main.c               |    6 ++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/a=
th5k/base.c
index 0676c6d..df602ee 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -621,9 +621,11 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		goto err_no_irq;
 	}
=20
-	err =3D ath5k_init(sc);
-	if (err)
-		goto err_irq;
+	if (ieee80211_opened(hw)) {
+		err =3D ath5k_init(sc);
+		if (err)
+			goto err_irq;
+	}
 	ath5k_led_enable(sc);
=20
 	/*
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ff137fd..d15a6ba 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1671,6 +1671,17 @@ void ieee80211_iterate_active_interfaces_atomic(=
struct ieee80211_hw *hw,
 						void *data);
=20
 /**
+ * ieee80211_opened - Determine whether device has been opened.
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @return: how many times interface has been opened
+ *
+ * Allows low level drivers to find out whether the ieee80211 layer
+ * considers the device opened. In fact, the number of opened virtual
+ * interfaces associated with the hw is returned.
+ */
+int ieee80211_opened(struct ieee80211_hw *hw);
+
+/**
  * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @ra: receiver address of the BA session recipient
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index aa5a191..4f77496 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -557,6 +557,12 @@ static int ieee80211_stop(struct net_device *dev)
 	return 0;
 }
=20
+int ieee80211_opened(struct ieee80211_hw *hw)
+{
+	return hw_to_local(hw)->open_count;
+}
+EXPORT_SYMBOL(ieee80211_opened);
+
 int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16=
 tid)
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
