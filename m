Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay01-haj2.antispameurope.com ([83.246.65.51]:36460 "EHLO
	relay01-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab0INJyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 05:54:36 -0400
MIME-Version: 1.0
Subject: AW: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support
Date: Tue, 14 Sep 2010 11:53:26 +0200
Content-Type: multipart/signed;
	boundary="----=_NextPart_000_004D_01CB5403.6DBCDCC0";
	protocol="application/x-pkcs7-signature";
	micalg=SHA1
Message-ID: <804B13F8F3D94A4AB18B9B01ACB68FA103AB036A@EXCHSRV.fokus.fraunhofer.de>
In-Reply-To: <AANLkTikcnHU+JFpt7o3UG0+=Py5HKVBMmpkvZNTpQ=uy@mail.gmail.com>
References: <804B13F8F3D94A4AB18B9B01ACB68FA1037B5158@EXCHSRV.fokus.fraunhofer.de> <20100727172020.GE8293@tux> <804B13F8F3D94A4AB18B9B01ACB68FA103AB02D1@EXCHSRV.fokus.fraunhofer.de> <AANLkTikcnHU+JFpt7o3UG0+=Py5HKVBMmpkvZNTpQ=uy@mail.gmail.com>
From: "Simsek, Burak" <burak.simsek@fokus.fraunhofer.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_004D_01CB5403.6DBCDCC0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_001_004E_01CB5403.6DBCDCC0"


------=_NextPart_001_004E_01CB5403.6DBCDCC0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Luis,

so far we could not find any device that worked. We ordered new ones... =
Will let you know in case we get something working.=20
Attached you can find two patch files. Since we could not get any device =
working yet, I am not sure whether the patch is prepared correctly. But =
all your previous changes (from the first patch file) should be in. And =
we did not get compilation errors.=20

Apple is interesting. We might give it a try as well. I ordered 2 =
mini-pci cards from sparklan =
(http://www.sparklan.com/product.php?func=3Dview&prod_id=3D63) and =
(http://www.oxfordtec.com/us/p127/SparkLAN-WMIA-199N-WLAN-802.11n-draft-w=
ifi-%202.4/5Ghz-dual-band-3T/3R-Module-%28Atheros-AR9001-AR9160-XSPAN%29-=
Wireless-miniP%20CI-card/product_info.html ) that I hope support wow.=20

Best regards

Burak Simsek

-----Urspr=C3=BCngliche Nachricht-----
Von: mcgrof@gmail.com [mailto:mcgrof@gmail.com] Im Auftrag von Luis R. =
Rodriguez
Gesendet: Montag, 13. September 2010 19:29
An: Simsek, Burak
Cc: Luis Rodriguez; linux-wireless@vger.kernel.org
Betreff: Re: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support

On Mon, Sep 13, 2010 at 10:11 AM, Simsek, Burak =
<burak.simsek@fokus.fraunhofer.de> wrote:
> Dear Luis,
>
> we are moving your patch to the latest version whenever we have the=20
> time to do so... You had sent us two patch files:
>
> http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07
> -21.pa
> tch
> http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/iw-add
> -wow.p
> atch
>
>
> The first one is successfully accomplished, but we have problems with=20
> the second one. I am giving a summary of the errors that we get below. =

> There are files and variables defined in that patch that we cannot=20
> find anywhere and do not know what they should do. Can you please=20
> provide us with some hints regarding those errors?

The first one is the biggest chunk of work, I can take care of the =
second one. Can you post the first patch so I can test?

BTW, I learned that we can test WoW in the community by using Apple =
boxen, Apple devices seems to always have WoW capable 802.11 Atheros =
chipsets. What are you using for your testing?

  Luis


------=_NextPart_001_004E_01CB5403.6DBCDCC0
Content-Type: application/octet-stream;
	name="0001-mac80211-add-WoW-support.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-mac80211-add-WoW-support.patch"

>From 91e3f7f301103d7f65d1d997fe10849d4093cdcb Mon Sep 17 00:00:00 2001=0A=
From: Luis R. Rodriguez <lrodriguez@atheros.com>=0A=
Date: Tue, 12 May 2009 17:31:32 -0700=0A=
Subject: [PATCH 1/2] mac80211: add WoW support=0A=
=0A=
If we're associated and have not already gone into PS mode=0A=
we ensure send a nullfunc frame before going to suspend. Upon=0A=
resume we ensure we restore PS mode if it was enabled and inform=0A=
the driver accordingly, also notify the AP we're awake.=0A=
=0A=
WoW requires the radio to be left on during suspend, to do this=0A=
we inform drivers of the requested wow triggers on the mac80211=0A=
stop callback.=0A=
=0A=
When using WoW we do not remove the interface for the device=0A=
we are using as a STA in mac80211.=0A=
=0A=
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>=0A=
Signed-off-by: burak <burak@burak-desktop.(none)>=0A=
---=0A=
 drivers/net/wireless/adm8211.c              |    2 +-=0A=
 drivers/net/wireless/at76c50x-usb.c         |    3 ++-=0A=
 drivers/net/wireless/ath/ar9170/main.c      |    2 +-=0A=
 drivers/net/wireless/ath/ath9k/main.c       |    2 +-=0A=
 drivers/net/wireless/b43/main.c             |    2 +-=0A=
 drivers/net/wireless/b43legacy/main.c       |    2 +-=0A=
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-=0A=
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-=0A=
 drivers/net/wireless/libertas_tf/main.c     |    2 +-=0A=
 drivers/net/wireless/mac80211_hwsim.c       |    2 +-=0A=
 drivers/net/wireless/p54/main.c             |    2 +-=0A=
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    2 +-=0A=
 drivers/net/wireless/wl12xx/wl1251_main.c   |    2 +-=0A=
 drivers/net/wireless/zd1211rw/zd_mac.c      |    2 +-=0A=
 net/mac80211/debugfs.c                      |    4 ++--=0A=
 net/mac80211/driver-trace.h                 |    6 ++++--=0A=
 net/mac80211/main.c                         |    2 +-=0A=
 17 files changed, 22 insertions(+), 19 deletions(-)=0A=
=0A=
diff --git a/drivers/net/wireless/adm8211.c =
b/drivers/net/wireless/adm8211.c=0A=
index f9aa1bc..fcaa286 100644=0A=
--- a/drivers/net/wireless/adm8211.c=0A=
+++ b/drivers/net/wireless/adm8211.c=0A=
@@ -1543,7 +1543,7 @@ fail:=0A=
 	return retval;=0A=
 }=0A=
 =0A=
-static void adm8211_stop(struct ieee80211_hw *dev)=0A=
+static void adm8211_stop(struct ieee80211_hw *dev, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct adm8211_priv *priv =3D dev->priv;=0A=
 =0A=
diff --git a/drivers/net/wireless/at76c50x-usb.c =
b/drivers/net/wireless/at76c50x-usb.c=0A=
index 91c5f73..cbd93b1 100644=0A=
--- a/drivers/net/wireless/at76c50x-usb.c=0A=
+++ b/drivers/net/wireless/at76c50x-usb.c=0A=
@@ -1826,7 +1826,8 @@ error:=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void at76_mac80211_stop(struct ieee80211_hw *hw)=0A=
+static void at76_mac80211_stop(struct ieee80211_hw *hw,=0A=
+			       struct cfg80211_wow *wow)=0A=
 {=0A=
 	struct at76_priv *priv =3D hw->priv;=0A=
 =0A=
diff --git a/drivers/net/wireless/ath/ar9170/main.c =
b/drivers/net/wireless/ath/ar9170/main.c=0A=
index 32bf79e..ce7cdb5 100644=0A=
--- a/drivers/net/wireless/ath/ar9170/main.c=0A=
+++ b/drivers/net/wireless/ath/ar9170/main.c=0A=
@@ -1136,7 +1136,7 @@ out:=0A=
 	return err;=0A=
 }=0A=
 =0A=
-static void ar9170_op_stop(struct ieee80211_hw *hw)=0A=
+static void ar9170_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct ar9170 *ar =3D hw->priv;=0A=
 	unsigned int i;=0A=
diff --git a/drivers/net/wireless/ath/ath9k/main.c =
b/drivers/net/wireless/ath/ath9k/main.c=0A=
index 1165f90..a57ead1 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/main.c=0A=
+++ b/drivers/net/wireless/ath/ath9k/main.c=0A=
@@ -1291,7 +1291,7 @@ exit:=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void ath9k_stop(struct ieee80211_hw *hw)=0A=
+static void ath9k_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct ath_wiphy *aphy =3D hw->priv;=0A=
 	struct ath_softc *sc =3D aphy->sc;=0A=
diff --git a/drivers/net/wireless/b43/main.c =
b/drivers/net/wireless/b43/main.c=0A=
index a118652..7557533 100644=0A=
--- a/drivers/net/wireless/b43/main.c=0A=
+++ b/drivers/net/wireless/b43/main.c=0A=
@@ -4512,7 +4512,7 @@ static int b43_op_start(struct ieee80211_hw *hw)=0A=
 	return err;=0A=
 }=0A=
 =0A=
-static void b43_op_stop(struct ieee80211_hw *hw)=0A=
+static void b43_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct b43_wl *wl =3D hw_to_b43_wl(hw);=0A=
 	struct b43_wldev *dev =3D wl->current_dev;=0A=
diff --git a/drivers/net/wireless/b43legacy/main.c =
b/drivers/net/wireless/b43legacy/main.c=0A=
index 67f18ec..e1422ae 100644=0A=
--- a/drivers/net/wireless/b43legacy/main.c=0A=
+++ b/drivers/net/wireless/b43legacy/main.c=0A=
@@ -3459,7 +3459,7 @@ out_mutex_unlock:=0A=
 	return err;=0A=
 }=0A=
 =0A=
-static void b43legacy_op_stop(struct ieee80211_hw *hw)=0A=
+static void b43legacy_op_stop(struct ieee80211_hw *hw, struct =
cfg80211_wow *wow)=0A=
 {=0A=
 	struct b43legacy_wl *wl =3D hw_to_b43legacy_wl(hw);=0A=
 	struct b43legacy_wldev *dev =3D wl->current_dev;=0A=
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c =
b/drivers/net/wireless/iwlwifi/iwl-agn.c=0A=
index ad0e67f..f962528 100644=0A=
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c=0A=
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c=0A=
@@ -3475,7 +3475,7 @@ out:=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void iwl_mac_stop(struct ieee80211_hw *hw)=0A=
+static void iwl_mac_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct iwl_priv *priv =3D hw->priv;=0A=
 =0A=
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c =
b/drivers/net/wireless/iwlwifi/iwl3945-base.c=0A=
index 68e624a..f9549ef 100644=0A=
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c=0A=
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c=0A=
@@ -3220,7 +3220,7 @@ out_release_irq:=0A=
 	return ret;=0A=
 }=0A=
 =0A=
-static void iwl3945_mac_stop(struct ieee80211_hw *hw)=0A=
+static void iwl3945_mac_stop(struct ieee80211_hw *hw, struct =
cfg80211_wow *wow)=0A=
 {=0A=
 	struct iwl_priv *priv =3D hw->priv;=0A=
 =0A=
diff --git a/drivers/net/wireless/libertas_tf/main.c =
b/drivers/net/wireless/libertas_tf/main.c=0A=
index 5550755..3c4bf68 100644=0A=
--- a/drivers/net/wireless/libertas_tf/main.c=0A=
+++ b/drivers/net/wireless/libertas_tf/main.c=0A=
@@ -332,7 +332,7 @@ err_prog_firmware:=0A=
 	return ret;=0A=
 }=0A=
 =0A=
-static void lbtf_op_stop(struct ieee80211_hw *hw)=0A=
+static void lbtf_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct lbtf_private *priv =3D hw->priv;=0A=
 	unsigned long flags;=0A=
diff --git a/drivers/net/wireless/mac80211_hwsim.c =
b/drivers/net/wireless/mac80211_hwsim.c=0A=
index 92b486d..071229d 100644=0A=
--- a/drivers/net/wireless/mac80211_hwsim.c=0A=
+++ b/drivers/net/wireless/mac80211_hwsim.c=0A=
@@ -582,7 +582,7 @@ static int mac80211_hwsim_start(struct ieee80211_hw =
*hw)=0A=
 }=0A=
 =0A=
 =0A=
-static void mac80211_hwsim_stop(struct ieee80211_hw *hw)=0A=
+static void mac80211_hwsim_stop(struct ieee80211_hw *hw, struct =
cfg80211_wow *wow)=0A=
 {=0A=
 	struct mac80211_hwsim_data *data =3D hw->priv;=0A=
 	data->started =3D 0;=0A=
diff --git a/drivers/net/wireless/p54/main.c =
b/drivers/net/wireless/p54/main.c=0A=
index 622d27b..360685f 100644=0A=
--- a/drivers/net/wireless/p54/main.c=0A=
+++ b/drivers/net/wireless/p54/main.c=0A=
@@ -199,7 +199,7 @@ out:=0A=
 	return err;=0A=
 }=0A=
 =0A=
-static void p54_stop(struct ieee80211_hw *dev)=0A=
+static void p54_stop(struct ieee80211_hw *dev, struct cfg80211_wow *wow)=0A=
 {=0A=
 	struct p54_common *priv =3D dev->priv;=0A=
 	int i;=0A=
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c =
b/drivers/net/wireless/rtl818x/rtl8180_dev.c=0A=
index 05c6bad..540abda 100644=0A=
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c=0A=
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c=0A=
@@ -650,7 +650,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)=0A=
 	return ret;=0A=
 }=0A=
 =0A=
-static void rtl8180_stop(struct ieee80211_hw *dev)=0A=
+static void rtl8180_stop(struct ieee80211_hw *dev, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct rtl8180_priv *priv =3D dev->priv;=0A=
 	u8 reg;=0A=
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c =
b/drivers/net/wireless/wl12xx/wl1251_main.c=0A=
index faf221c..1bde702 100644=0A=
--- a/drivers/net/wireless/wl12xx/wl1251_main.c=0A=
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c=0A=
@@ -452,7 +452,7 @@ out:=0A=
 	return ret;=0A=
 }=0A=
 =0A=
-static void wl1251_op_stop(struct ieee80211_hw *hw)=0A=
+static void wl1251_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct wl1251 *wl =3D hw->priv;=0A=
 =0A=
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c =
b/drivers/net/wireless/zd1211rw/zd_mac.c=0A=
index 43307bd..237c9ee 100644=0A=
--- a/drivers/net/wireless/zd1211rw/zd_mac.c=0A=
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c=0A=
@@ -286,7 +286,7 @@ out:=0A=
 	return r;=0A=
 }=0A=
 =0A=
-static void zd_op_stop(struct ieee80211_hw *hw)=0A=
+static void zd_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct zd_mac *mac =3D zd_hw_mac(hw);=0A=
 	struct zd_chip *chip =3D &mac->chip;=0A=
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c=0A=
index e81ef4e..ec9c403 100644=0A=
--- a/net/mac80211/debugfs.c=0A=
+++ b/net/mac80211/debugfs.c=0A=
@@ -112,8 +112,8 @@ static ssize_t reset_write(struct file *file, const =
char __user *user_buf,=0A=
 	struct ieee80211_local *local =3D file->private_data;=0A=
 =0A=
 	rtnl_lock();=0A=
-	__ieee80211_suspend(&local->hw);=0A=
-	__ieee80211_resume(&local->hw);=0A=
+	__ieee80211_suspend(&local->hw, NULL);=0A=
+	__ieee80211_resume(&local->hw, NULL);=0A=
 	rtnl_unlock();=0A=
 =0A=
 	return count;=0A=
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h=0A=
index f6f3d89..34c935a 100644=0A=
--- a/net/mac80211/driver-trace.h=0A=
+++ b/net/mac80211/driver-trace.h=0A=
@@ -95,16 +95,18 @@ TRACE_EVENT(drv_start,=0A=
 );=0A=
 =0A=
 TRACE_EVENT(drv_stop,=0A=
-	TP_PROTO(struct ieee80211_local *local),=0A=
+	TP_PROTO(struct ieee80211_local *local, struct cfg80211_wow *wow),=0A=
 =0A=
-	TP_ARGS(local),=0A=
+	TP_ARGS(local, wow),=0A=
 =0A=
 	TP_STRUCT__entry(=0A=
 		LOCAL_ENTRY=0A=
+		__field(u32, triggers_enabled)=0A=
 	),=0A=
 =0A=
 	TP_fast_assign(=0A=
 		LOCAL_ASSIGN;=0A=
+		__entry->triggers_enabled =3D wow->triggers_enabled;=0A=
 	),=0A=
 =0A=
 	TP_printk(=0A=
diff --git a/net/mac80211/main.c b/net/mac80211/main.c=0A=
index 4935b84..3333491 100644=0A=
--- a/net/mac80211/main.c=0A=
+++ b/net/mac80211/main.c=0A=
@@ -295,7 +295,7 @@ static void ieee80211_restart_work(struct =
work_struct *work)=0A=
 		container_of(work, struct ieee80211_local, restart_work);=0A=
 =0A=
 	rtnl_lock();=0A=
-	ieee80211_reconfig(local);=0A=
+	ieee80211_reconfig(local, NULL);=0A=
 	rtnl_unlock();=0A=
 }=0A=
 =0A=
-- =0A=
1.7.0.4=0A=
=0A=

------=_NextPart_001_004E_01CB5403.6DBCDCC0
Content-Type: application/octet-stream;
	name="0002-Add-the-WoW-patch-of-Luis.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-Add-the-WoW-patch-of-Luis.patch"

>From 0d2ecb4947f18143e152874853c0dcf36f79d597 Mon Sep 17 00:00:00 2001=0A=
From: Burak Simsek <burak.simsekfokus.fraunhofer.de>=0A=
Date: Tue, 14 Sep 2010 10:35:22 +0200=0A=
Subject: [PATCH 2/2] Add the WoW patch of Luis=0A=
 =
http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07-21=
.patch=0A=
=0A=
---=0A=
 drivers/net/wireless/ath/ath5k/base.c            |    4 +-=0A=
 drivers/net/wireless/ath/ath9k/Makefile          |    1 +=0A=
 drivers/net/wireless/ath/ath9k/ar9002_hw.c       |   13 ++=0A=
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |   32 ++++=0A=
 drivers/net/wireless/ath/ath9k/ath9k.h           |   20 +++=0A=
 drivers/net/wireless/ath/ath9k/eeprom.h          |    1 +=0A=
 drivers/net/wireless/ath/ath9k/eeprom_def.c      |    2 +=0A=
 drivers/net/wireless/ath/ath9k/hw.c              |   48 +++++++=0A=
 drivers/net/wireless/ath/ath9k/hw.h              |   62 ++++++++=0A=
 drivers/net/wireless/ath/ath9k/main.c            |   26 ++++-=0A=
 drivers/net/wireless/ath/ath9k/pci.c             |  148 =
+++++++++++++++++++=0A=
 drivers/net/wireless/ath/ath9k/reg.h             |  153 =
++++++++++++++++++++-=0A=
 drivers/net/wireless/mwl8k.c                     |    2 +-=0A=
 drivers/net/wireless/rt2x00/rt2x00.h             |    2 +-=0A=
 drivers/net/wireless/rt2x00/rt2x00mac.c          |    2 +-=0A=
 drivers/net/wireless/rtl818x/rtl8187_dev.c       |    2 +-=0A=
 include/linux/nl80211.h                          |   37 +++++=0A=
 include/net/cfg80211.h                           |   43 +++++-=0A=
 include/net/mac80211.h                           |   16 ++-=0A=
 net/mac80211/cfg.c                               |    8 +-=0A=
 net/mac80211/driver-ops.h                        |    7 +-=0A=
 net/mac80211/ieee80211_i.h                       |   23 ++-=0A=
 net/mac80211/iface.c                             |    6 +-=0A=
 net/mac80211/mlme.c                              |    3 +-=0A=
 net/mac80211/pm.c                                |   67 ++++++++-=0A=
 net/mac80211/util.c                              |   31 ++++-=0A=
 net/wireless/core.h                              |    3 +=0A=
 net/wireless/nl80211.c                           |  165 =
++++++++++++++++++++++=0A=
 net/wireless/sme.c                               |   14 ++=0A=
 net/wireless/sysfs.c                             |    4 +-=0A=
 30 files changed, 896 insertions(+), 49 deletions(-)=0A=
=0A=
diff --git a/drivers/net/wireless/ath/ath5k/base.c =
b/drivers/net/wireless/ath/ath5k/base.c=0A=
index 116ac66..5b3e5d3 100644=0A=
--- a/drivers/net/wireless/ath/ath5k/base.c=0A=
+++ b/drivers/net/wireless/ath/ath5k/base.c=0A=
@@ -224,7 +224,7 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, =
struct sk_buff *skb,=0A=
 		struct ath5k_txq *txq);=0A=
 static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel =
*chan);=0A=
 static int ath5k_start(struct ieee80211_hw *hw);=0A=
-static void ath5k_stop(struct ieee80211_hw *hw);=0A=
+static void ath5k_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow);=0A=
 static int ath5k_add_interface(struct ieee80211_hw *hw,=0A=
 		struct ieee80211_vif *vif);=0A=
 static void ath5k_remove_interface(struct ieee80211_hw *hw,=0A=
@@ -3024,7 +3024,7 @@ static int ath5k_start(struct ieee80211_hw *hw)=0A=
 	return ath5k_init(hw->priv);=0A=
 }=0A=
 =0A=
-static void ath5k_stop(struct ieee80211_hw *hw)=0A=
+static void ath5k_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	ath5k_stop_hw(hw->priv);=0A=
 }=0A=
diff --git a/drivers/net/wireless/ath/ath9k/Makefile =
b/drivers/net/wireless/ath/ath9k/Makefile=0A=
index 4555e99..0103ef5 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/Makefile=0A=
+++ b/drivers/net/wireless/ath/ath9k/Makefile=0A=
@@ -10,6 +10,7 @@ ath9k-y +=3D	beacon.o \=0A=
 ath9k-$(CONFIG_PCI) +=3D pci.o=0A=
 ath9k-$(CONFIG_ATHEROS_AR71XX) +=3D ahb.o=0A=
 ath9k-$(CONFIG_ATH9K_DEBUGFS) +=3D debug.o=0A=
+ath9k-$(CONFIG_PM) +=3D wow.o=0A=
 =0A=
 obj-$(CONFIG_ATH9K) +=3D ath9k.o=0A=
 =0A=
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c =
b/drivers/net/wireless/ath/ath9k/ar9002_hw.c=0A=
index 303c63d..3e808d7 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c=0A=
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c=0A=
@@ -103,6 +103,12 @@ static void ar9002_hw_init_mode_regs(struct ath_hw =
*ah)=0A=
 			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),=0A=
 				  2);=0A=
 		}=0A=
+#ifdef CONFIG_PM=0A=
+		/* SerDes values during WOW sleep */=0A=
+		INIT_INI_ARRAY(&ah->iniPcieSerdesWow,=0A=
+			       ar9285PciePhy_AWOW_9285_1_2,=0A=
+			       ARRAY_SIZE(ar9285PciePhy_AWOW_9285_1_2), 2);=0A=
+#endif=0A=
 	} else if (AR_SREV_9280_20_OR_LATER(ah)) {=0A=
 		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280_2,=0A=
 			       ARRAY_SIZE(ar9280Modes_9280_2), 6);=0A=
@@ -118,6 +124,13 @@ static void ar9002_hw_init_mode_regs(struct ath_hw =
*ah)=0A=
 			       ar9280PciePhy_clkreq_always_on_L1_9280,=0A=
 			       ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);=0A=
 		}=0A=
+=0A=
+	#ifdef CONFIG_PM=0A=
+		/* SerDes values during WOW sleep */=0A=
+		INIT_INI_ARRAY(&ah->iniPcieSerdesWow, ar9280PciePhy_AWOW_9280,=0A=
+			       ARRAY_SIZE(ar9280PciePhy_AWOW_9280), 2);=0A=
+	#endif=0A=
+=0A=
 		INIT_INI_ARRAY(&ah->iniModesAdditional,=0A=
 			       ar9280Modes_fast_clock_9280_2,=0A=
 			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);=0A=
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h =
b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h=0A=
index 6203eed..930de6d 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h=0A=
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h=0A=
@@ -919,6 +919,22 @@ static const u32 =
ar9280PciePhy_clkreq_always_on_L1_9280[][2] =3D {=0A=
 	{0x00004044, 0x00000000},=0A=
 };=0A=
 =0A=
+#ifdef CONFIG_PM=0A=
+/* Auto generated PCI-E PHY config for AR9280 with WOW */=0A=
+static const u_int32_t ar9280PciePhy_AWOW_9280[][2] =3D {=0A=
+    {0x00004040,  0x9248fd00 },=0A=
+    {0x00004040,  0x24924924 },=0A=
+    {0x00004040,  0xa8000019 },=0A=
+    {0x00004040,  0x13160820 },=0A=
+    {0x00004040,  0xe5980560 },=0A=
+    {0x00004040,  0xc01ddffd },=0A=
+    {0x00004040,  0x1aaabe41 },=0A=
+    {0x00004040,  0xbe105554 },=0A=
+    {0x00004040,  0x00043007 },=0A=
+    {0x00004044,  0x00000000 },=0A=
+};=0A=
+#endif=0A=
+=0A=
 static const u32 ar9285PciePhy_clkreq_always_on_L1_9285[][2] =3D {=0A=
 	/* Addr      allmodes  */=0A=
 	{0x00004040, 0x9248fd00},=0A=
@@ -1760,6 +1776,22 @@ static const u32 =
ar9285PciePhy_clkreq_off_L1_9285_1_2[][2] =3D {=0A=
 	{0x00004044, 0x00000000},=0A=
 };=0A=
 =0A=
+=0A=
+#ifdef CONFIG_PM=0A=
+static const u_int32_t ar9285PciePhy_AWOW_9285_1_2[][2] =3D {=0A=
+    {0x00004040,  0x9248fd00 },=0A=
+    {0x00004040,  0x24924924 },=0A=
+    {0x00004040,  0xa8000019 },=0A=
+    {0x00004040,  0x13160820 },=0A=
+    {0x00004040,  0xe5980560 },=0A=
+    {0x00004040,  0xc01ddffd },=0A=
+    {0x00004040,  0x1aaabe41 },=0A=
+    {0x00004040,  0xbe105554 },=0A=
+    {0x00004040,  0x00043007 },=0A=
+    {0x00004044,  0x00000000 },=0A=
+};=0A=
+#endif /* CONFIG_PM */=0A=
+=0A=
 static const u32 ar9287Modes_9287_1_1[][6] =3D {=0A=
 	{0x00001030, 0x00000000, 0x00000000, 0x000002c0, 0x00000160, =
0x000001e0},=0A=
 	{0x00001070, 0x00000000, 0x00000000, 0x00000318, 0x0000018c, =
0x000001e0},=0A=
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h =
b/drivers/net/wireless/ath/ath9k/ath9k.h=0A=
index f0197a6..d61ea8f 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/ath9k.h=0A=
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h=0A=
@@ -589,6 +589,13 @@ struct ath_softc {=0A=
 =0A=
 	int beacon_interval;=0A=
 =0A=
+#ifdef CONFIG_PM=0A=
+	bool wow_got_bmiss_intr;=0A=
+	bool wow_sleep_proc_intr;=0A=
+	u32 wow_intr_before_sleep;=0A=
+	u32 wow_triggers_enabled;=0A=
+#endif=0A=
+=0A=
 #ifdef CONFIG_ATH9K_DEBUGFS=0A=
 	struct ath9k_debug debug;=0A=
 #endif=0A=
@@ -599,6 +606,19 @@ struct ath_softc {=0A=
 	struct ath_descdma txsdma;=0A=
 };=0A=
 =0A=
+#ifdef CONFIG_PM=0A=
+/*=0A=
+ * WoW trigger types=0A=
+ */=0A=
+#define AH_WOW_USER_PATTERN_EN		0x1=0A=
+#define AH_WOW_MAGIC_PATTERN_EN		0x2=0A=
+#define AH_WOW_LINK_CHANGE		0x4=0A=
+#define AH_WOW_BEACON_MISS		0x8=0A=
+#define AH_WOW_MAX_EVENTS		4=0A=
+=0A=
+#endif=0A=
+=0A=
+=0A=
 struct ath_wiphy {=0A=
 	struct ath_softc *sc; /* shared for all virtual wiphys */=0A=
 	struct ieee80211_hw *hw;=0A=
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h =
b/drivers/net/wireless/ath/ath9k/eeprom.h=0A=
index 0b09db0..6a7317f 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/eeprom.h=0A=
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h=0A=
@@ -239,6 +239,7 @@ enum eeprom_param {=0A=
 	EEP_MAC_MSW,=0A=
 	EEP_MAC_MID,=0A=
 	EEP_MAC_LSW,=0A=
+	EEP_WOW,=0A=
 	EEP_REG_0,=0A=
 	EEP_REG_1,=0A=
 	EEP_OP_CAP,=0A=
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c =
b/drivers/net/wireless/ath/ath9k/eeprom_def.c=0A=
index afa2b73..921eee1 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c=0A=
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c=0A=
@@ -249,6 +249,8 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,=0A=
 		return pBase->macAddr[2] << 8 | pBase->macAddr[3];=0A=
 	case EEP_MAC_MSW:=0A=
 		return pBase->macAddr[4] << 8 | pBase->macAddr[5];=0A=
+	case EEP_WOW:=0A=
+		return pBase->eepMisc & BIT(1);=0A=
 	case EEP_REG_0:=0A=
 		return pBase->regDmn[0];=0A=
 	case EEP_REG_1:=0A=
diff --git a/drivers/net/wireless/ath/ath9k/hw.c =
b/drivers/net/wireless/ath/ath9k/hw.c=0A=
index 3384ca1..10bcdb2 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/hw.c=0A=
+++ b/drivers/net/wireless/ath/ath9k/hw.c=0A=
@@ -22,6 +22,8 @@=0A=
 #include "hw-ops.h"=0A=
 #include "rc.h"=0A=
 #include "ar9003_mac.h"=0A=
+#include "ar9002_initvals.h"=0A=
+=0A=
 =0A=
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);=0A=
 =0A=
@@ -545,6 +547,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)=0A=
 	ath_print(common, ATH_DBG_RESET, "serialize_regmode is %d\n",=0A=
 		ah->config.serialize_regmode);=0A=
 =0A=
+=0A=
 	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))=0A=
 		ah->config.max_txtrig_level =3D MAX_TX_FIFO_THRESHOLD >> 1;=0A=
 	else=0A=
@@ -605,6 +608,16 @@ static int __ath9k_hw_init(struct ath_hw *ah)=0A=
 		return r;=0A=
 	}=0A=
 =0A=
+	#ifdef CONFIG_PM=0A=
+	/* WOW */=0A=
+	ath9k_wow_set_gpio_reset_low(ah);=0A=
+	/* Clear the Wow Status */=0A=
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, REG_READ(ah, AR_PCIE_PM_CTRL) |=0A=
+		  AR_PMCTRL_WOW_PME_CLR);=0A=
+	REG_WRITE(ah, AR_WOW_PATTERN_REG,=0A=
+		  AR_WOW_CLEAR_EVENTS(REG_READ(ah, AR_WOW_PATTERN_REG)));=0A=
+	#endif=0A=
+=0A=
 	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))=0A=
 		ah->tx_trig_level =3D (AR_FTRIG_256B >> AR_FTRIG_S);=0A=
 	else=0A=
@@ -617,6 +630,18 @@ static int __ath9k_hw_init(struct ath_hw *ah)=0A=
 	return 0;=0A=
 }=0A=
 =0A=
+void ath9k_wow_set_gpio_reset_low(struct ath_hw *ah)=0A=
+{=0A=
+    u32 val;=0A=
+=0A=
+    val =3D REG_READ(ah, AR_GPIO_OE_OUT);=0A=
+    val |=3D (1 << (2 * 2));=0A=
+    REG_WRITE(ah, AR_GPIO_OE_OUT, val);=0A=
+    val =3D REG_READ(ah, AR_GPIO_OE_OUT);=0A=
+    val =3D REG_READ(ah,AR_GPIO_IN_OUT );=0A=
+}=0A=
+=0A=
+=0A=
 int ath9k_hw_init(struct ath_hw *ah)=0A=
 {=0A=
 	int ret;=0A=
@@ -2078,6 +2103,29 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)=0A=
 			  "regdomain mapped to 0x%x\n", regulatory->current_rd);=0A=
 	}=0A=
 =0A=
+	eeval =3D ah->eep_ops->get_eeprom(ah, EEP_WOW);=0A=
+	if (AR_SREV_9280_10_OR_LATER(ah)) {=0A=
+		/*=0A=
+		 * Devices >=3D AR9280 rev 10 are capable of WoW but require=0A=
+		 * a few hardware changes. The EEPROM tells us whether these=0A=
+		 * hardware changes are in place on the device. Just enabling=0A=
+		 * WoW on the EEPROM is not enough to enable WoW.=0A=
+		 */=0A=
+		pCap->wow |=3D ATH9K_WOW_DEVICE_CAPABLE;=0A=
+		if (eeval) {=0A=
+			pCap->wow |=3D ATH9K_WOW_HW_ENABLED;=0A=
+			pCap->wow |=3D ATH9K_WOW_PATTERN_MATCH_EXACT;=0A=
+			/*=0A=
+			 * First 4 bytes of all patterns must match,=0A=
+			 * requires some wide masks to ensure proper=0A=
+			 * functionality for the disassociation and=0A=
+			 * deauthentication frames.=0A=
+			 */=0A=
+			if (AR_SREV_9280(ah))=0A=
+				pCap->wow |=3D ATH9K_WOW_PATTERN_MATCH_DWORD;=0A=
+		}=0A=
+	}=0A=
+=0A=
 	eeval =3D ah->eep_ops->get_eeprom(ah, EEP_OP_MODE);=0A=
 	if ((eeval & (AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A)) =3D=3D 0) {=0A=
 		ath_print(common, ATH_DBG_FATAL,=0A=
diff --git a/drivers/net/wireless/ath/ath9k/hw.h =
b/drivers/net/wireless/ath/ath9k/hw.h=0A=
index 1601dd4..a89351c 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/hw.h=0A=
+++ b/drivers/net/wireless/ath/ath9k/hw.h=0A=
@@ -206,6 +206,42 @@ enum ath9k_hw_caps {=0A=
 	ATH9K_HW_CAP_PAPRD			=3D BIT(22),=0A=
 };=0A=
 =0A=
+/**=0A=
+ * enum ath9k_hw_wow_caps - WoW device capabilities=0A=
+ *=0A=
+ * @ATH9K_WOW_DEVICE_CAPABLE: device revision is capable of WoW=0A=
+ * @ATH9K_WOW_HW_ENABLED: EEPROM indicates hardware changes for WoW=0A=
+ *	*should be* are present. Devices need some the PCI Wake signal to go=0A=
+ *	through, this signal is typically capped with a resistor.=0A=
+ *	Devices with WoW physically enabled have this resistor=0A=
+ *	shorted to 0 ohm and also have the register that PCI core=0A=
+ *	picks up as PCI PME capable enabled.=0A=
+ * ATH9K_WOW_PATTERN_MATCH_EXACT: device is capable of matching=0A=
+ *	an exact pattern for de-authentication and disassocation.=0A=
+ * ATH9K_WOW_PATTERN_MATCH_DWORD: device requires the first four=0A=
+ *	bytes of the pattern for deauthentication and disassocation=0A=
+ * 	to match for all types of possible frames received of those=0A=
+ *	types.=0A=
+ */=0A=
+enum ath9k_hw_wow_caps {=0A=
+	ATH9K_WOW_DEVICE_CAPABLE		=3D BIT(0),=0A=
+	ATH9K_WOW_HW_ENABLED			=3D BIT(1),=0A=
+	ATH9K_WOW_PATTERN_MATCH_EXACT		=3D BIT(2),=0A=
+	ATH9K_WOW_PATTERN_MATCH_DWORD		=3D BIT(3),=0A=
+};=0A=
+=0A=
+=0A=
+/**=0A=
+ * struct ath9k_hw_capabilities - device capabilities=0A=
+ *=0A=
+ * This structure contains the device capabilities. The EEPROM will=0A=
+ * be read and specific device capabilities are mapped accordingly=0A=
+ * for easy access.=0A=
+ *=0A=
+ * wow: Wake-on-Wireless LAN capabilities, can be any of the=0A=
+ * 	%ATH9K_WOW_*.=0A=
+ */=0A=
+=0A=
 struct ath9k_hw_capabilities {=0A=
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */=0A=
 	DECLARE_BITMAP(wireless_modes, ATH9K_MODE_MAX); /* ATH9K_MODE_* */=0A=
@@ -221,6 +257,7 @@ struct ath9k_hw_capabilities {=0A=
 	u8 num_gpio_pins;=0A=
 	u8 num_antcfg_2ghz;=0A=
 	u8 num_antcfg_5ghz;=0A=
+	u32 wow;=0A=
 	u8 rx_hp_qdepth;=0A=
 	u8 rx_lp_qdepth;=0A=
 	u8 rx_status_len;=0A=
@@ -785,6 +822,13 @@ struct ath_hw {=0A=
 	int PDADCdelta;=0A=
 	u8 led_pin;=0A=
 =0A=
+=0A=
+#ifdef CONFIG_PM=0A=
+	/* WoW mask -- used to indicate which WoW we have enabled */=0A=
+	u32 ah_wowEventMask;=0A=
+#endif=0A=
+=0A=
+=0A=
 	struct ar5416IniArray iniModes;=0A=
 	struct ar5416IniArray iniCommon;=0A=
 	struct ar5416IniArray iniBank0;=0A=
@@ -815,6 +859,11 @@ struct ath_hw {=0A=
 	struct ar5416IniArray iniRadio[ATH_INI_NUM_SPLIT];=0A=
 	struct ar5416IniArray iniSOC[ATH_INI_NUM_SPLIT];=0A=
 =0A=
+#ifdef CONFIG_PM=0A=
+	/* SerDes values during WOW sleep */=0A=
+	struct ar5416IniArray iniPcieSerdesWow;=0A=
+#endif=0A=
+=0A=
 	u32 intr_gen_timer_trigger;=0A=
 	u32 intr_gen_timer_thresh;=0A=
 	struct ath_gen_timer_table hw_gen_timers;=0A=
@@ -1005,4 +1054,17 @@ void ath9k_hw_attach_ani_ops_new(struct ath_hw =
*ah);=0A=
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44=0A=
 #define ATH9K_CLOCK_FAST_RATE_5GHZ_OFDM 44=0A=
 =0A=
+#ifdef CONFIG_PM=0A=
+=0A=
+/* WOW - Wake on Wireless */=0A=
+void ath9k_wow_set_gpio_reset_low(struct ath_hw *ah);=0A=
+/* Called when going to suspend/hibernate */=0A=
+void ath9k_hw_wow_enable(struct ath_hw *ah, u32 patternEnable);=0A=
+/* Called when coming back up from suspend/hibernation */=0A=
+u32 ath9k_hw_wow_wake_up(struct ath_hw *ah);=0A=
+const char *ath9k_hw_wow_event_to_string(u32 wow_event);=0A=
+=0A=
+#endif /* CONFIG_PM */=0A=
+=0A=
+=0A=
 #endif=0A=
diff --git a/drivers/net/wireless/ath/ath9k/main.c =
b/drivers/net/wireless/ath/ath9k/main.c=0A=
index a57ead1..4344a87 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/main.c=0A=
+++ b/drivers/net/wireless/ath/ath9k/main.c=0A=
@@ -645,7 +645,7 @@ irqreturn_t ath_isr(int irq, void *dev)=0A=
 	struct ath_hw *ah =3D sc->sc_ah;=0A=
 	enum ath9k_int status;=0A=
 	bool sched =3D false;=0A=
-=0A=
+	struct ath_common *common =3D ath9k_hw_common(ah);=0A=
 	/*=0A=
 	 * The hardware is not ready/present, don't=0A=
 	 * touch anything. Note this can happen early=0A=
@@ -725,6 +725,21 @@ irqreturn_t ath_isr(int irq, void *dev)=0A=
 		ath9k_hw_set_interrupts(ah, ah->imask);=0A=
 	}=0A=
 =0A=
+	if (status & ATH9K_INT_BMISS) {=0A=
+	#ifdef CONFIG_PM=0A=
+		if (sc->wow_sleep_proc_intr) {=0A=
+			ath_print(common, (ATH_DBG_ANY | ATH_DBG_INTERRUPT),=0A=
+				"during WoW we got a BMISS\n");=0A=
+			sc->wow_got_bmiss_intr =3D true;=0A=
+			sc->wow_sleep_proc_intr =3D false;=0A=
+		}=0A=
+	#else=0A=
+		/* BMISS not enabled on ath9k unless WoW is enabled */=0A=
+		ath_print(sc, ATH_DBG_INTERRUPT,=0A=
+			"spurious unattended beacon miss interrupt\n");=0A=
+	#endif=0A=
+	}=0A=
+=0A=
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))=0A=
 		if (status & ATH9K_INT_TIM_TIMER) {=0A=
 			/* Clear RxAbort bit so that we can=0A=
@@ -1320,6 +1335,15 @@ static void ath9k_stop(struct ieee80211_hw *hw, =
struct cfg80211_wow *wow)=0A=
 		cancel_work_sync(&sc->chan_work);=0A=
 	}=0A=
 =0A=
+#ifdef CONFIG_PM=0A=
+	if (wow && wow->triggers_enabled) {=0A=
+		sc->wow_triggers_enabled =3D wow->triggers_enabled;=0A=
+		ath_print(common, ATH_DBG_ANY, "Leaving radio on during "=0A=
+			"suspend for WoW\n");=0A=
+		return;=0A=
+	}=0A=
+#endif=0A=
+=0A=
 	if (sc->sc_flags & SC_OP_INVALID) {=0A=
 		ath_print(common, ATH_DBG_ANY, "Device not present\n");=0A=
 		mutex_unlock(&sc->mutex);=0A=
diff --git a/drivers/net/wireless/ath/ath9k/pci.c =
b/drivers/net/wireless/ath/ath9k/pci.c=0A=
index b5b6514..8311a0a 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/pci.c=0A=
+++ b/drivers/net/wireless/ath/ath9k/pci.c=0A=
@@ -156,6 +156,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)=0A=
 	if ((val & 0x0000ff00) !=3D 0)=0A=
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);=0A=
 =0A=
+	device_init_wakeup(&pdev->dev, 1);=0A=
+	device_set_wakeup_enable(&pdev->dev, 0);=0A=
+=0A=
 	ret =3D pci_request_region(pdev, 0, "ath9k");=0A=
 	if (ret) {=0A=
 		dev_err(&pdev->dev, "PCI memory region reserve error\n");=0A=
@@ -212,6 +215,34 @@ static int ath_pci_probe(struct pci_dev *pdev, =
const struct pci_device_id *id)=0A=
 	wiphy_info(hw->wiphy, "%s mem=3D0x%lx, irq=3D%d\n",=0A=
 		   hw_name, (unsigned long)mem, pdev->irq);=0A=
 =0A=
+	struct ath_hw *ah =3D sc->sc_ah;=0A=
+	struct ath_common *common =3D ath9k_hw_common(ah);=0A=
+	/* WoW is for PCI for ath9k */=0A=
+=0A=
+	/*=0A=
+	 * Bmiss and link change triggers not yet fully tested, add them=0A=
+	 * after properly testing and confirming behaviour. I believe=0A=
+	 * we need pattern matching support to enable them as well=0A=
+	 * (detect deauth and disassoc).=0A=
+	 */=0A=
+	if (ah->caps.wow & ATH9K_WOW_DEVICE_CAPABLE &&=0A=
+	    ah->caps.wow & ATH9K_WOW_HW_ENABLED)=0A=
+		hw->wiphy->wow_triggers_supported =3D=0A=
+				NL80211_WOW_TRIGGER_MAGIC_PACKET;=0A=
+=0A=
+	ath_print(common, ATH_DBG_CONFIG,=0A=
+		"WoW capabler device: %s\n",=0A=
+		(ah->caps.wow & ATH9K_WOW_DEVICE_CAPABLE) ? "yes" : "no");=0A=
+	ath_print(common, ATH_DBG_CONFIG,=0A=
+		"EEPROM indicates WoW hw changes in place: %s\n",=0A=
+		(ah->caps.wow & ATH9K_WOW_HW_ENABLED) ? "yes" : "no");=0A=
+	ath_print(common, ATH_DBG_CONFIG,=0A=
+		"WoW exact match pattern support: %s\n",=0A=
+		(ah->caps.wow & ATH9K_WOW_PATTERN_MATCH_EXACT) ? "yes" : "no");=0A=
+	ath_print(common, ATH_DBG_CONFIG,=0A=
+		"WoW match pattern first dword requirement: %s\n",=0A=
+		(ah->caps.wow & ATH9K_WOW_PATTERN_MATCH_DWORD) ? "yes" : "no");=0A=
+=0A=
 	return 0;=0A=
 =0A=
 err_init:=0A=
@@ -247,21 +278,134 @@ static void ath_pci_remove(struct pci_dev *pdev)=0A=
 =0A=
 #ifdef CONFIG_PM=0A=
 =0A=
+static u32 ath9k_wow_event_map(u32 cfg_wow_events)=0A=
+{=0A=
+	u32 wow_events =3D 0;=0A=
+=0A=
+	if (cfg_wow_events & NL80211_WOW_TRIGGER_MAGIC_PACKET)=0A=
+		wow_events |=3D AH_WOW_MAGIC_PATTERN_EN;=0A=
+#if 0=0A=
+	if (cfg_wow_events & NL80211_WOW_TRIGGER_BMISS)=0A=
+		wow_events |=3D AH_WOW_BEACON_MISS;=0A=
+	if (cfg_wow_events & NL80211_WOW_TRIGGER_LINK_CHANGE)=0A=
+		wow_events |=3D AH_WOW_LINK_CHANGE;=0A=
+#endif=0A=
+=0A=
+	return wow_events;=0A=
+}=0A=
+=0A=
+static void ath9k_pci_wow_enable(struct ath_softc *sc)=0A=
+{=0A=
+	struct ath_hw *ah =3D sc->sc_ah;=0A=
+	u32 wake_up_events;=0A=
+	struct ath_common *common =3D ath9k_hw_common(ah);=0A=
+	wake_up_events =3D ath9k_wow_event_map(sc->wow_triggers_enabled);=0A=
+=0A=
+	/* eventually we'll add this...=0A=
+	 * if (wake_up_events & AH_WOW_USER_PATTERN_EN)=0A=
+	 *	ath9k_wow_create_pattern(sc);=0A=
+	 */=0A=
+=0A=
+	/*=0A=
+	 * To avoid false wake, we enable beacon miss interrupt only when=0A=
+	 * we go to sleep. We save the current interrupt mask so that=0A=
+	 * we can restore it after the system wakes up.=0A=
+	 */=0A=
+	//burak> resmen uctum burada=0A=
+	sc->wow_intr_before_sleep =3D ah->imask;=0A=
+	ath9k_hw_set_interrupts(ah, ATH9K_INT_BMISS | ATH9K_INT_GLOBAL);=0A=
+	ah->imask =3D ATH9K_INT_BMISS | ATH9K_INT_GLOBAL;=0A=
+=0A=
+	ath9k_hw_wow_enable(ah, wake_up_events);=0A=
+	device_set_wakeup_enable(sc->dev, 1);=0A=
+=0A=
+	ath_print(common, ATH_DBG_ANY,=0A=
+		"WoW enabled\n");=0A=
+=0A=
+	sc->wow_sleep_proc_intr =3D true;=0A=
+=0A=
+	/*=0A=
+	sc->wow_intr_before_sleep =3D ah->mask_reg;=0A=
+		ath9k_hw_set_interrupts(ah, ATH9K_INT_BMISS | ATH9K_INT_GLOBAL);=0A=
+		sc->imask =3D ATH9K_INT_BMISS | ATH9K_INT_GLOBAL;=0A=
+=0A=
+		ath9k_hw_wow_enable(ah, wake_up_events);=0A=
+		device_set_wakeup_enable(sc->dev, 1);=0A=
+=0A=
+		DPRINTF(sc, ATH_DBG_ANY,=0A=
+			"WoW enabled\n");=0A=
+=0A=
+		sc->wow_sleep_proc_intr =3D true;=0A=
+	*/=0A=
+=0A=
+=0A=
+}=0A=
+=0A=
+=0A=
 static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
 {=0A=
 	struct ieee80211_hw *hw =3D pci_get_drvdata(pdev);=0A=
 	struct ath_wiphy *aphy =3D hw->priv;=0A=
 	struct ath_softc *sc =3D aphy->sc;=0A=
 =0A=
+	if (!!sc->wow_triggers_enabled && device_can_wakeup(&pdev->dev))=0A=
+		ath9k_pci_wow_enable(sc);=0A=
+=0A=
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);=0A=
 =0A=
 	pci_save_state(pdev);=0A=
 	pci_disable_device(pdev);=0A=
+=0A=
+=0A=
+	if (!!sc->wow_triggers_enabled && device_can_wakeup(&pdev->dev)) {=0A=
+		pci_prepare_to_sleep(pdev);=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	pci_wake_from_d3(pdev, !!sc->wow_triggers_enabled);=0A=
+=0A=
 	pci_set_power_state(pdev, PCI_D3hot);=0A=
 =0A=
 	return 0;=0A=
 }=0A=
 =0A=
+=0A=
+static void ath9k_pci_wow_wake(struct ath_softc *sc)=0A=
+{=0A=
+	struct ath_hw *ah =3D sc->sc_ah;=0A=
+	u32 wow_status;=0A=
+=0A=
+	ath9k_hw_set_interrupts(ah, sc->wow_intr_before_sleep);=0A=
+	ah->imask =3D sc->wow_intr_before_sleep;=0A=
+	struct ath_common *common =3D ath9k_hw_common(ah);=0A=
+=0A=
+	wow_status =3D ath9k_hw_wow_wake_up(sc->sc_ah);=0A=
+=0A=
+	if (sc->wow_got_bmiss_intr) {=0A=
+		/*=0A=
+		 * Some devices may not pick beacon miss=0A=
+		 * as the reason they woke up so we add that=0A=
+		 * here for that shortcoming=0A=
+		 */=0A=
+		wow_status |=3D AH_WOW_BEACON_MISS;=0A=
+		sc->wow_got_bmiss_intr =3D false;=0A=
+		ath_print(common, ATH_DBG_ANY,=0A=
+			"Beacon miss interrupt picked up during sleep, "=0A=
+			"adding as possible wake up reason\n");=0A=
+	}=0A=
+=0A=
+	if (wow_status) {=0A=
+		ath_print(common, ATH_DBG_ANY,=0A=
+			"Waking up due to WoW trigger%s\n",=0A=
+			ath9k_hw_wow_event_to_string(wow_status));=0A=
+		ath_print(common, ATH_DBG_ANY,=0A=
+			"WoW status: %d\n WoW reason: %s\n",=0A=
+			wow_status,=0A=
+			ath9k_hw_wow_event_to_string((wow_status & 0x0FFF)));=0A=
+	}=0A=
+}=0A=
+=0A=
+=0A=
 static int ath_pci_resume(struct pci_dev *pdev)=0A=
 {=0A=
 	struct ieee80211_hw *hw =3D pci_get_drvdata(pdev);=0A=
@@ -285,6 +429,10 @@ static int ath_pci_resume(struct pci_dev *pdev)=0A=
 	if ((val & 0x0000ff00) !=3D 0)=0A=
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);=0A=
 =0A=
+	if (sc->wow_triggers_enabled)=0A=
+		ath9k_pci_wow_wake(sc);=0A=
+=0A=
+=0A=
 	/* Enable LED */=0A=
 	ath9k_hw_cfg_output(sc->sc_ah, sc->sc_ah->led_pin,=0A=
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);=0A=
diff --git a/drivers/net/wireless/ath/ath9k/reg.h =
b/drivers/net/wireless/ath/ath9k/reg.h=0A=
index d01c4ad..2891d65 100644=0A=
--- a/drivers/net/wireless/ath/ath9k/reg.h=0A=
+++ b/drivers/net/wireless/ath/ath9k/reg.h=0A=
@@ -707,8 +707,9 @@=0A=
 #define AR_WA_D3_TO_L1_DISABLE_REAL     (1 << 16)=0A=
 #define AR_WA_ASPM_TIMER_BASED_DISABLE  (1 << 17)=0A=
 #define AR_WA_RESET_EN                  (1 << 18) /* Sw Control to =
enable PCI-Reset to POR (bit 15) */=0A=
-#define AR_WA_ANALOG_SHIFT              (1 << 20)=0A=
-#define AR_WA_POR_SHORT                 (1 << 21) /* PCI-E Phy reset =
control */=0A=
+#define AR_WA_UNTIE_RESET_EN	(1 << 15)   /* Enable PCI Reset to POR =
(power-on-reset) */=0A=
+#define AR_WA_ANALOG_SHIFT	(1 << 20)=0A=
+#define AR_WA_POR_SHORT		(1 << 21)   /* PCI-E Phy reset control */=0A=
 #define AR9285_WA_DEFAULT		0x004a050b=0A=
 #define AR9280_WA_DEFAULT           	0x0040073b=0A=
 #define AR_WA_DEFAULT               	0x0000073f=0A=
@@ -1824,6 +1825,154 @@ enum {=0A=
 #define AR_KEYTABLE_TYPE(_n)    (AR_KEYTABLE(_n) + 20)=0A=
 #define AR_KEYTABLE_MAC0(_n)    (AR_KEYTABLE(_n) + 24)=0A=
 #define AR_KEYTABLE_MAC1(_n)    (AR_KEYTABLE(_n) + 28)=0A=
+/* WoW - Wake On Wireless */=0A=
+=0A=
+#define AR_PMCTRL_AUX_PWR_DET		0x10000000  /* Puts Chip in L2 state */=0A=
+#define AR_PMCTRL_D3COLD_VAUX		0x00800000=0A=
+#define AR_PMCTRL_HOST_PME_EN		0x00400000    /* Send OOB WAKE_L on WoW =
event */=0A=
+#define AR_PMCTRL_WOW_PME_CLR		0x00200000    /* Clear WoW event */=0A=
+#define AR_PMCTRL_PWR_STATE_MASK	0x0F000000    /* Power State Mask */=0A=
+#define AR_PMCTRL_PWR_STATE_D1D3	0x0F000000    /* Activate D1 and D3 */=0A=
+#define AR_PMCTRL_PWR_STATE_D0		0x08000000    /* Activate D0 */=0A=
+#define AR_PMCTRL_PWR_PM_CTRL_ENA	0x00008000    /* Enable power =
management */=0A=
+=0A=
+#define AR_WOW_BEACON_TIMO_MAX		0xFFFFFFFF  /* Max. value for Beacon =
Timeout */=0A=
+=0A=
+/*=0A=
+ * MAC WoW Registers.=0A=
+ */=0A=
+#define AR_WOW_PATTERN_REG		0x825C=0A=
+#define AR_WOW_COUNT_REG		0x8260=0A=
+#define AR_WOW_BCN_EN_REG		0x8270=0A=
+#define AR_WOW_BCN_TIMO_REG		0x8274=0A=
+#define AR_WOW_KEEP_ALIVE_TIMO_REG	0x8278=0A=
+#define AR_WOW_KEEP_ALIVE_REG		0x827C=0A=
+#define AR_WOW_US_SCALAR_REG		0x8284=0A=
+#define AR_WOW_KEEP_ALIVE_DELAY_REG	0x8288=0A=
+#define AR_WOW_PATTERN_MATCH_REG	0x828C=0A=
+#define AR_WOW_PATTERN_OFF1_REG		0x8290 /* Pattern bytes 0 -> 3 */=0A=
+#define AR_WOW_PATTERN_OFF2_REG		0x8294 /* Pattern bytes 4 -> 7 */=0A=
+/* For AR9285 or Later version of chips */=0A=
+#define AR_WOW_EXACT_REG		0x829C=0A=
+#define AR_WOW_LENGTH1_REG		0x8360=0A=
+#define AR_WOW_LENGTH2_REG		0x8364=0A=
+/* Register to enable pattern match for less than 256 bytes packets */=0A=
+#define AR_WOW_PATTERN_MATCH_LT_256B_REG	0x8368=0A=
+=0A=
+/* AR_WOW_PATTERN_REG Values */=0A=
+#define AR_WOW_BACK_OFF_SHIFT(x)	((x & 0xf) << 27)    /* in usecs */=0A=
+#define AR_WOW_MAC_INTR_EN		0x00040000=0A=
+#define AR_WOW_MAGIC_EN			0x00010000=0A=
+#define AR_WOW_PATTERN_EN(x)		((x & 0xff) << 0)=0A=
+#define AR_WOW_PATTERN_FOUND_SHIFT	8=0A=
+#define AR_WOW_PATTERN_FOUND(x)		(x & (0xff << =
AR_WOW_PATTERN_FOUND_SHIFT))=0A=
+#define AR_WOW_PATTERN_FOUND_MASK	((0xff) << AR_WOW_PATTERN_FOUND_SHIFT)=0A=
+#define AR_WOW_MAGIC_PAT_FOUND		0x00020000=0A=
+#define AR_WOW_MAC_INTR			0x00080000=0A=
+#define AR_WOW_KEEP_ALIVE_FAIL		0x00100000=0A=
+#define AR_WOW_BEACON_FAIL		0x00200000=0A=
+=0A=
+#define AR_WOW_STATUS(x)	(x & (AR_WOW_PATTERN_FOUND_MASK | \=0A=
+				      AR_WOW_MAGIC_PAT_FOUND | \=0A=
+				      AR_WOW_KEEP_ALIVE_FAIL | \=0A=
+				      AR_WOW_BEACON_FAIL))=0A=
+#define AR_WOW_CLEAR_EVENTS(x)	(x & ~(AR_WOW_PATTERN_EN(0xff) | \=0A=
+				       AR_WOW_MAGIC_EN | \=0A=
+				       AR_WOW_MAC_INTR_EN | \=0A=
+				       AR_WOW_BEACON_FAIL | \=0A=
+				       AR_WOW_KEEP_ALIVE_FAIL))=0A=
+=0A=
+/* AR_WOW_COUNT_REG Values */=0A=
+#define AR_WOW_AIFS_CNT(x)		((x & 0xff) << 0)=0A=
+#define AR_WOW_SLOT_CNT(x)		((x & 0xff) << 8)=0A=
+#define AR_WOW_KEEP_ALIVE_CNT(x)	((x & 0xff) << 16)=0A=
+=0A=
+/* AR_WOW_BCN_EN_REG */=0A=
+#define AR_WOW_BEACON_FAIL_EN		0x00000001=0A=
+=0A=
+/* AR_WOW_BCN_TIMO_REG */=0A=
+#define AR_WOW_BEACON_TIMO		0x40000000  /* Valid if BCN_EN is set */=0A=
+=0A=
+/* AR_WOW_KEEP_ALIVE_TIMO_REG */=0A=
+#define AR_WOW_KEEP_ALIVE_TIMO		0x00007A12=0A=
+#define AR_WOW_KEEP_ALIVE_NEVER		0xFFFFFFFF=0A=
+=0A=
+/* AR_WOW_KEEP_ALIVE_REG */=0A=
+#define AR_WOW_KEEP_ALIVE_AUTO_DIS	0x00000001=0A=
+#define AR_WOW_KEEP_ALIVE_FAIL_DIS	0x00000002=0A=
+=0A=
+/* AR_WOW_KEEP_ALIVE_DELAY_REG */=0A=
+#define AR_WOW_KEEP_ALIVE_DELAY		0x000003E8 /* 1 msec */=0A=
+=0A=
+/*=0A=
+ * Keep it long for Beacon workaround - ensures no false alarm=0A=
+ */=0A=
+#define AR_WOW_BMISSTHRESHOLD 0x20=0A=
+=0A=
+/* AR_WOW_PATTERN_MATCH_REG */=0A=
+#define AR_WOW_PAT_END_OF_PKT(x)	((x & 0xf) << 0)=0A=
+#define AR_WOW_PAT_OFF_MATCH(x)		((x & 0xf) << 8)=0A=
+=0A=
+/*=0A=
+ * Default values for Wow Configuration for backoff, aifs, slot, =
keep-alive, etc=0A=
+ * to be programmed into various registers.=0A=
+ */=0A=
+#define AR_WOW_PAT_BACKOFF	0x00000004 /* AR_WOW_PATTERN_REG */=0A=
+#define AR_WOW_CNT_AIFS_CNT	0x00000022 /* AR_WOW_COUNT_REG */=0A=
+#define AR_WOW_CNT_SLOT_CNT	0x00000009 /* AR_WOW_COUNT_REG */=0A=
+/*=0A=
+ * Keepalive count applicable for AR9280 2.0 and above.=0A=
+ */=0A=
+#define AR_WOW_CNT_KA_CNT 0x00000008    /* AR_WOW_COUNT_REG */=0A=
+=0A=
+/* WoW - Transmit buffer for keep alive frames */=0A=
+#define AR_WOW_TRANSMIT_BUFFER	0xE000 /* E000 - EFFC */=0A=
+=0A=
+#define AR_WOW_KA_DESC_WORD2	0xE000=0A=
+#define AR_WOW_KA_DESC_WORD3	0xE004=0A=
+#define AR_WOW_KA_DESC_WORD4	0xE008=0A=
+#define AR_WOW_KA_DESC_WORD5	0xE00C=0A=
+#define AR_WOW_KA_DESC_WORD6	0xE010=0A=
+#define AR_WOW_KA_DESC_WORD7	0xE014=0A=
+#define AR_WOW_KA_DESC_WORD8	0xE018=0A=
+#define AR_WOW_KA_DESC_WORD9	0xE01C=0A=
+#define AR_WOW_KA_DESC_WORD10	0xE020=0A=
+#define AR_WOW_KA_DESC_WORD11	0xE024=0A=
+#define AR_WOW_KA_DESC_WORD12	0xE028=0A=
+#define AR_WOW_KA_DESC_WORD13	0xE02C=0A=
+=0A=
+#define AR_WOW_KA_DATA_WORD0	0xE030=0A=
+#define AR_WOW_KA_DATA_WORD1	0xE034=0A=
+#define AR_WOW_KA_DATA_WORD2	0xE038=0A=
+#define AR_WOW_KA_DATA_WORD3	0xE03C=0A=
+#define AR_WOW_KA_DATA_WORD4	0xE040=0A=
+#define AR_WOW_KA_DATA_WORD5	0xE044=0A=
+=0A=
+/* WoW Transmit Buffer for patterns */=0A=
+#define AR_WOW_TB_PATTERN0	0xE100=0A=
+#define AR_WOW_TB_PATTERN1	0xE200=0A=
+#define AR_WOW_TB_PATTERN2	0xE300=0A=
+#define AR_WOW_TB_PATTERN3	0xE400=0A=
+#define AR_WOW_TB_PATTERN4	0xE500=0A=
+#define AR_WOW_TB_PATTERN5	0xE600=0A=
+#define AR_WOW_TB_PATTERN6	0xE700=0A=
+#define AR_WOW_TB_PATTERN7	0xE800=0A=
+#define AR_WOW_TB_MASK0		0xEC00=0A=
+#define AR_WOW_TB_MASK1		0xEC20=0A=
+#define AR_WOW_TB_MASK2		0xEC40=0A=
+#define AR_WOW_TB_MASK3		0xEC60=0A=
+#define AR_WOW_TB_MASK4		0xEC80=0A=
+#define AR_WOW_TB_MASK5		0xECa0=0A=
+#define AR_WOW_TB_MASK6		0xECC0=0A=
+#define AR_WOW_TB_MASK7		0xECE0=0A=
+=0A=
+/* Currently Pattern 0-7 are supported - so bit 0-7 are set */=0A=
+#define AR_WOW_PATTERN_SUPPORTED	0xFF=0A=
+#define AR_WOW_LENGTH_MAX		0xFF=0A=
+#define AR_WOW_LENGTH1_SHIFT(_i)	((0x3 - ((_i) & 0x3)) << 0x3)=0A=
+#define AR_WOW_LENGTH1_MASK(_i)		(AR_WOW_LENGTH_MAX << =
AR_WOW_LENGTH1_SHIFT(_i))=0A=
+#define AR_WOW_LENGTH2_SHIFT(_i)	((0x7 - ((_i) & 0x7)) << 0x3)=0A=
+#define AR_WOW_LENGTH2_MASK(_i)		(AR_WOW_LENGTH_MAX << =
AR_WOW_LENGTH2_SHIFT(_i))=0A=
 =0A=
 #define AR9271_CORE_CLOCK	117   /* clock to 117Mhz */=0A=
 #define AR9271_TARGET_BAUD_RATE	19200 /* 115200 */=0A=
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c=0A=
index f152a25..5a711c3 100644=0A=
--- a/drivers/net/wireless/mwl8k.c=0A=
+++ b/drivers/net/wireless/mwl8k.c=0A=
@@ -3256,7 +3256,7 @@ static int mwl8k_start(struct ieee80211_hw *hw)=0A=
 	return rc;=0A=
 }=0A=
 =0A=
-static void mwl8k_stop(struct ieee80211_hw *hw)=0A=
+static void mwl8k_stop(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct mwl8k_priv *priv =3D hw->priv;=0A=
 	int i;=0A=
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h =
b/drivers/net/wireless/rt2x00/rt2x00.h=0A=
index 0ae942c..0e59b84 100644=0A=
--- a/drivers/net/wireless/rt2x00/rt2x00.h=0A=
+++ b/drivers/net/wireless/rt2x00/rt2x00.h=0A=
@@ -1082,7 +1082,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,=0A=
  */=0A=
 int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);=0A=
 int rt2x00mac_start(struct ieee80211_hw *hw);=0A=
-void rt2x00mac_stop(struct ieee80211_hw *hw);=0A=
+void rt2x00mac_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow);=0A=
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,=0A=
 			    struct ieee80211_vif *vif);=0A=
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,=0A=
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c =
b/drivers/net/wireless/rt2x00/rt2x00mac.c=0A=
index 235e037..92a95cd 100644=0A=
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c=0A=
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c=0A=
@@ -175,7 +175,7 @@ int rt2x00mac_start(struct ieee80211_hw *hw)=0A=
 }=0A=
 EXPORT_SYMBOL_GPL(rt2x00mac_start);=0A=
 =0A=
-void rt2x00mac_stop(struct ieee80211_hw *hw)=0A=
+void rt2x00mac_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)=0A=
 {=0A=
 	struct rt2x00_dev *rt2x00dev =3D hw->priv;=0A=
 =0A=
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c =
b/drivers/net/wireless/rtl818x/rtl8187_dev.c=0A=
index 38fa824..f62f464 100644=0A=
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c=0A=
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c=0A=
@@ -987,7 +987,7 @@ rtl8187_start_exit:=0A=
 	return ret;=0A=
 }=0A=
 =0A=
-static void rtl8187_stop(struct ieee80211_hw *dev)=0A=
+static void rtl8187_stop(struct ieee80211_hw *dev, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct rtl8187_priv *priv =3D dev->priv;=0A=
 	struct sk_buff *skb;=0A=
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h=0A=
index 31603e8..805048c 100644=0A=
--- a/include/linux/nl80211.h=0A=
+++ b/include/linux/nl80211.h=0A=
@@ -311,6 +311,19 @@=0A=
  * @NL80211_CMD_SET_WIPHY_NETNS: Set a wiphy's netns. Note that all =
devices=0A=
  *	associated with this wiphy must be down and will follow.=0A=
  *=0A=
+ * @NL80211_CMD_GET_WOW: get Wake-on-Wireless-LAN (WoW) settings.=0A=
+ * @NL80211_CMD_SET_WOW: set Wake-on-Wireless-LAN (Wow) settings. Wake =
on=0A=
+ *	wireless makes use of standard Wake-on-LAN (WoL) frames, you receive=0A=
+ *	a WoW frame when your AP sends you a regular WOL frame. The =
difference=0A=
+ *	difference WoL is you need to be associated to an AP in order to=0A=
+ *	receive WoW frames, so additional triggers are available for a =
wakeup.=0A=
+ *	A driver capable of WoW should initialize the wiphy with its =
supported=0A=
+ *	WoW triggers. Upon suspend cfg80211 will inform the driver of the =
user=0A=
+ *	enabled triggers. By default no WoW triggers are enabled.=0A=
+ *	For more information see:=0A=
+ *	http://wireless.kernel.org/en/users/Documentation/WoW=0A=
+ *=0A=
+ *=0A=
  * @NL80211_CMD_REMAIN_ON_CHANNEL: Request to remain awake on the =
specified=0A=
  *	channel for the specified amount of time. This can be used to do=0A=
  *	off-channel operations like transmit a Public Action frame and wait =
for=0A=
@@ -462,6 +475,8 @@ enum nl80211_commands {=0A=
 	NL80211_CMD_DISCONNECT,=0A=
 =0A=
 	NL80211_CMD_SET_WIPHY_NETNS,=0A=
+	NL80211_CMD_GET_WOW,=0A=
+	NL80211_CMD_SET_WOW,=0A=
 =0A=
 	NL80211_CMD_GET_SURVEY,=0A=
 	NL80211_CMD_NEW_SURVEY_RESULTS,=0A=
@@ -509,6 +524,8 @@ enum nl80211_commands {=0A=
 #define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE=0A=
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE=0A=
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT=0A=
+#define NL80211_CMD_GET_WOW NL80211_CMD_GET_WOW=0A=
+#define NL80211_CMD_SET_WOW NL80211_CMD_SET_WOW=0A=
 =0A=
 /**=0A=
  * enum nl80211_attrs - nl80211 netlink attributes=0A=
@@ -736,6 +753,12 @@ enum nl80211_commands {=0A=
  *=0A=
  * @NL80211_ATTR_PID: Process ID of a network namespace.=0A=
  *=0A=
+ * @NL80211_ATTR_WOW_TRIGGERS_SUPPORTED: the supported WoW triggers=0A=
+ * @NL80211_ATTR_WOW_TRIGGERS_ENABLED: used by %NL80211_CMD_SET_WOW to=0A=
+ *	indicate which WoW triggers should be enabled. This is also=0A=
+ *	used by %NL80211_CMD_GET_WOW to get the currently enabled WoW=0A=
+ *	triggers.=0A=
+ *=0A=
  * @NL80211_ATTR_GENERATION: Used to indicate consistent snapshots for=0A=
  *	dumps. This number increases whenever the object list being=0A=
  *	dumped changes, and as such userspace can verify that it has=0A=
@@ -927,6 +950,9 @@ enum nl80211_attrs {=0A=
 	NL80211_ATTR_KEYS,=0A=
 =0A=
 	NL80211_ATTR_PID,=0A=
+	=0A=
+	NL80211_ATTR_WOW_TRIGGERS_SUPPORTED,=0A=
+	NL80211_ATTR_WOW_TRIGGERS_ENABLED,=0A=
 =0A=
 	NL80211_ATTR_4ADDR,=0A=
 =0A=
@@ -1703,6 +1729,17 @@ enum nl80211_key_attributes {=0A=
 };=0A=
 =0A=
 /**=0A=
+ * enum nl80211_wow_triggers - Wake-on-Wireless-LAN triggers=0A=
+ *=0A=
+ * NL80211_WOW_TRIGGER_MAGIC_PACKET: a wake signal will be sent to the=0A=
+ *     devices if a magic packet is received.=0A=
+ */=0A=
+enum nl80211_wow_triggers {=0A=
+	NL80211_WOW_TRIGGER_MAGIC_PACKET	=3D 1 << 1,=0A=
+};=0A=
+=0A=
+=0A=
+/**=0A=
  * enum nl80211_tx_rate_attributes - TX rate set attributes=0A=
  * @__NL80211_TXRATE_INVALID: invalid=0A=
  * @NL80211_TXRATE_LEGACY: Legacy (non-MCS) rates allowed for TX rate =
selection=0A=
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h=0A=
index 4c8c727..2d1ba87 100644=0A=
--- a/include/net/cfg80211.h=0A=
+++ b/include/net/cfg80211.h=0A=
@@ -780,6 +780,9 @@ struct cfg80211_crypto_settings {=0A=
 	bool control_port_no_encrypt;=0A=
 };=0A=
 =0A=
+=0A=
+=0A=
+=0A=
 /**=0A=
  * struct cfg80211_auth_request - Authentication request data=0A=
  *=0A=
@@ -977,6 +980,27 @@ struct cfg80211_pmksa {=0A=
 	u8 *pmkid;=0A=
 };=0A=
 =0A=
+=0A=
+/*=0A=
+ * struct cfg80211_wow - Wake on Wireless-LAN support info=0A=
+ *=0A=
+ * This structure defines the WoW triggers enabled and set for the =
device.=0A=
+ * For now we only carry the supported tiggers but this is expected to =
grow=0A=
+ * once we add support for user patterns.=0A=
+ *=0A=
+ * @triggers_enabled: enabled triggers by the user. Default=0A=
+ *	is to disable all triggers. The flags for this bitmask=0A=
+ *	are %NL80211_WOW_TRIGGER_*.=0A=
+ * @netdev: net_device where we enabled WoW. This is only used to clear=0A=
+ *	the @triggers_enabled upon disassociation and to prevent settings=0A=
+ *	onto other netdevices from the same rdev.=0A=
+ */=0A=
+struct cfg80211_wow {=0A=
+	u32 triggers_enabled;=0A=
+	struct net_device *netdev;=0A=
+};=0A=
+=0A=
+=0A=
 /**=0A=
  * struct cfg80211_ops - backend description for wireless configuration=0A=
  *=0A=
@@ -990,8 +1014,11 @@ struct cfg80211_pmksa {=0A=
  * wireless extensions but this is subject to reevaluation as soon as =
this=0A=
  * code is used more widely and we have a first user without wext.=0A=
  *=0A=
- * @suspend: wiphy device needs to be suspended=0A=
- * @resume: wiphy device needs to be resumed=0A=
+ * @suspend: wiphy device needs to be suspended. We pass the struct =
cfg80211_wow=0A=
+ *	so the device enables the appropriate triggers during suspend.=0A=
+ * @resume: wiphy device needs to be resumed. We pass the struct =
cfg80211_wow=0A=
+ * 	so the device can opt out from adding new information for the AP we=0A=
+ *	we were last associated to when WoW was enabled=0A=
  *=0A=
  * @add_virtual_intf: create a new virtual interface with the given =
name,=0A=
  *	must set the struct wireless_dev's iftype. Beware: You must create=0A=
@@ -1115,8 +1142,11 @@ struct cfg80211_pmksa {=0A=
  *=0A=
  */=0A=
 struct cfg80211_ops {=0A=
-	int	(*suspend)(struct wiphy *wiphy);=0A=
-	int	(*resume)(struct wiphy *wiphy);=0A=
+//	int	(*suspend)(struct wiphy *wiphy);=0A=
+//	int	(*resume)(struct wiphy *wiphy);=0A=
+=0A=
+	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wow *wow);=0A=
+	int	(*resume)(struct wiphy *wiphy, struct cfg80211_wow *wow);=0A=
 =0A=
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,=0A=
 				    enum nl80211_iftype type, u32 *flags,=0A=
@@ -1337,6 +1367,10 @@ struct ieee80211_txrx_stypes {=0A=
  * @frag_threshold: Fragmentation threshold =
(dot11FragmentationThreshold);=0A=
  *	-1 =3D fragmentation disabled, only odd values >=3D 256 used=0A=
  * @rts_threshold: RTS threshold (dot11RTSThreshold); -1 =3D RTS/CTS =
disabled=0A=
+ * @wow_triggers_supported: supported bitmask of Wake-on-Wireless =
triggers.=0A=
+ *	The flags for this bitmask are %NL80211_WOW_TRIGGER_*. The driver=0A=
+ *	should set the capabilities before registering the wiphy. WoW =
triggers=0A=
+ *	which should be used are passed to the driver upon suspend.=0A=
  * @_net: the network namespace this wiphy currently lives in=0A=
  * @perm_addr: permanent MAC address of this device=0A=
  * @addr_mask: If the device supports multiple MAC addresses by masking,=0A=
@@ -1414,6 +1448,7 @@ struct wiphy {=0A=
 	u32 hw_version;=0A=
 =0A=
 	u8 max_num_pmkids;=0A=
+	u32 wow_triggers_supported;=0A=
 =0A=
 	/* If multiple wiphys are registered and you're handed e.g.=0A=
 	 * a regular netdev with assigned ieee80211_ptr, you won't=0A=
diff --git a/include/net/mac80211.h b/include/net/mac80211.h=0A=
index f91fc33..c04b222 100644=0A=
--- a/include/net/mac80211.h=0A=
+++ b/include/net/mac80211.h=0A=
@@ -1520,12 +1520,14 @@ enum ieee80211_ampdu_mlme_action {=0A=
  *	Must be implemented and can sleep.=0A=
  *=0A=
  * @stop: Called after last netdevice attached to the hardware=0A=
- *	is disabled. This should turn off the hardware (at least=0A=
- *	it must turn off frame reception.)=0A=
- *	May be called right after add_interface if that rejects=0A=
- *	an interface. If you added any work onto the mac80211 workqueue=0A=
- *	you should ensure to cancel it on this callback.=0A=
- *	Must be implemented and can sleep.=0A=
+ *	is disabled or during suspend. This should turn off the=0A=
+ *	hardware (at least it must turn off frame reception) unless=0A=
+ *	the device wants to enable Wake-on-Wireless-LAN. In order to=0A=
+ *	process WoW triggers the radio must be left on and the driver=0A=
+ *	must enable the triggers in hardware. This callback may be=0A=
+ *	called right after add_interface if that rejects an interface.=0A=
+ *	Must be implemented. WoW triggers which should be enabled prior=0A=
+ *	suspend are passed in the callback.=0A=
  *=0A=
  * @add_interface: Called when a netdevice attached to the hardware is=0A=
  *	enabled. Because it is not called for monitor mode devices, @start=0A=
@@ -1696,7 +1698,7 @@ enum ieee80211_ampdu_mlme_action {=0A=
 struct ieee80211_ops {=0A=
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);=0A=
 	int (*start)(struct ieee80211_hw *hw);=0A=
-	void (*stop)(struct ieee80211_hw *hw);=0A=
+	void (*stop)(struct ieee80211_hw *hw, struct cfg80211_wow *wow);=0A=
 	int (*add_interface)(struct ieee80211_hw *hw,=0A=
 			     struct ieee80211_vif *vif);=0A=
 	int (*change_interface)(struct ieee80211_hw *hw,=0A=
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c=0A=
index 5de1ca3..ba85860 100644=0A=
--- a/net/mac80211/cfg.c=0A=
+++ b/net/mac80211/cfg.c=0A=
@@ -1132,14 +1132,14 @@ static int ieee80211_set_channel(struct wiphy =
*wiphy,=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_PM=0A=
-static int ieee80211_suspend(struct wiphy *wiphy)=0A=
+static int ieee80211_suspend(struct wiphy *wiphy, struct cfg80211_wow =
*wow)=0A=
 {=0A=
-	return __ieee80211_suspend(wiphy_priv(wiphy));=0A=
+	return __ieee80211_suspend(wiphy_priv(wiphy) , wow);=0A=
 }=0A=
 =0A=
-static int ieee80211_resume(struct wiphy *wiphy)=0A=
+static int ieee80211_resume(struct wiphy *wiphy, struct cfg80211_wow =
*wow)=0A=
 {=0A=
-	return __ieee80211_resume(wiphy_priv(wiphy));=0A=
+	return __ieee80211_resume(wiphy_priv(wiphy) ,wow);=0A=
 }=0A=
 #else=0A=
 #define ieee80211_suspend NULL=0A=
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h=0A=
index 6064b7b..82a695d 100644=0A=
--- a/net/mac80211/driver-ops.h=0A=
+++ b/net/mac80211/driver-ops.h=0A=
@@ -24,12 +24,13 @@ static inline int drv_start(struct ieee80211_local =
*local)=0A=
 	return ret;=0A=
 }=0A=
 =0A=
-static inline void drv_stop(struct ieee80211_local *local)=0A=
+static inline void drv_stop(struct ieee80211_local *local, struct =
cfg80211_wow *wow)=0A=
 {=0A=
 	might_sleep();=0A=
 =0A=
-	trace_drv_stop(local);=0A=
-	local->ops->stop(&local->hw);=0A=
+	trace_drv_stop(local, wow);=0A=
+	local->ops->stop(&local->hw, wow);=0A=
+=0A=
 	trace_drv_return_void(local);=0A=
 =0A=
 	/* sync away all work on the tasklet before clearing started */=0A=
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h=0A=
index 16f7fb1..5313ecd 100644=0A=
--- a/net/mac80211/ieee80211_i.h=0A=
+++ b/net/mac80211/ieee80211_i.h=0A=
@@ -723,6 +723,13 @@ struct ieee80211_local {=0A=
 	 * ease timer cancelling etc.=0A=
 	 */=0A=
 	bool quiescing;=0A=
+	/*=0A=
+	 * This will be true if we had enabled PS before going to suspend.=0A=
+	 * We use this to help resume restore the PS state to what it was.=0A=
+	 * Note that this only makes sense if we're associated and are a=0A=
+	 * station.=0A=
+	 */=0A=
+	bool ps_before_suspend;=0A=
 =0A=
 	/* device is started */=0A=
 	bool started;=0A=
@@ -1178,23 +1185,25 @@ void ieee80211_process_measurement_req(struct =
ieee80211_sub_if_data *sdata,=0A=
 				       size_t len);=0A=
 =0A=
 /* Suspend/resume and hw reconfiguration */=0A=
-int ieee80211_reconfig(struct ieee80211_local *local);=0A=
-void ieee80211_stop_device(struct ieee80211_local *local);=0A=
+int ieee80211_reconfig(struct ieee80211_local *local, struct =
cfg80211_wow *wow);=0A=
+void ieee80211_stop_device(struct ieee80211_local *local,  struct =
cfg80211_wow *wow);=0A=
 =0A=
 #ifdef CONFIG_PM=0A=
-int __ieee80211_suspend(struct ieee80211_hw *hw);=0A=
+int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow);=0A=
 =0A=
-static inline int __ieee80211_resume(struct ieee80211_hw *hw)=0A=
+static inline int __ieee80211_resume(struct ieee80211_hw *hw,=0A=
+				     struct cfg80211_wow *wow)=0A=
 {=0A=
-	return ieee80211_reconfig(hw_to_local(hw));=0A=
+	return ieee80211_reconfig(hw_to_local(hw), wow);=0A=
 }=0A=
 #else=0A=
-static inline int __ieee80211_suspend(struct ieee80211_hw *hw)=0A=
+static inline int __ieee80211_suspend(struct ieee80211_hw *hw, struct =
cfg80211_wow *wow)=0A=
 {=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static inline int __ieee80211_resume(struct ieee80211_hw *hw)=0A=
+static inline int __ieee80211_resume(struct ieee80211_hw *hw,=0A=
+				     struct cfg80211_wow *wow)=0A=
 {=0A=
 	return 0;=0A=
 }=0A=
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c=0A=
index c1cc200..78506a6 100644=0A=
--- a/net/mac80211/iface.c=0A=
+++ b/net/mac80211/iface.c=0A=
@@ -216,7 +216,7 @@ static int ieee80211_do_open(struct net_device *dev, =
bool coming_up)=0A=
 =0A=
 		if (!is_valid_ether_addr(dev->dev_addr)) {=0A=
 			if (!local->open_count)=0A=
-				drv_stop(local);=0A=
+				drv_stop(local,NULL);=0A=
 			return -EADDRNOTAVAIL;=0A=
 		}=0A=
 	}=0A=
@@ -338,7 +338,7 @@ static int ieee80211_do_open(struct net_device *dev, =
bool coming_up)=0A=
 	drv_remove_interface(local, &sdata->vif);=0A=
  err_stop:=0A=
 	if (!local->open_count)=0A=
-		drv_stop(local);=0A=
+		drv_stop(local,NULL);=0A=
  err_del_bss:=0A=
 	sdata->bss =3D NULL;=0A=
 	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)=0A=
@@ -543,7 +543,7 @@ static void ieee80211_do_stop(struct =
ieee80211_sub_if_data *sdata,=0A=
 		if (local->ops->napi_poll)=0A=
 			napi_disable(&local->napi);=0A=
 		ieee80211_clear_tx_pending(local);=0A=
-		ieee80211_stop_device(local);=0A=
+		ieee80211_stop_device(local,NULL);=0A=
 =0A=
 		/* no reconfiguring after stop! */=0A=
 		hw_reconf_flags =3D 0;=0A=
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c=0A=
index 0cb822c..9072293 100644=0A=
--- a/net/mac80211/mlme.c=0A=
+++ b/net/mac80211/mlme.c=0A=
@@ -1912,7 +1912,8 @@ static void ieee80211_sta_monitor_work(struct =
work_struct *work)=0A=
 	struct ieee80211_sub_if_data *sdata =3D=0A=
 		container_of(work, struct ieee80211_sub_if_data,=0A=
 			     u.mgd.monitor_work);=0A=
-=0A=
+	if (sdata->local->scanning)=0A=
+		return;=0A=
 	ieee80211_mgd_probe_ap(sdata, false);=0A=
 }=0A=
 =0A=
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c=0A=
index d287fde..37bd195 100644=0A=
--- a/net/mac80211/pm.c=0A=
+++ b/net/mac80211/pm.c=0A=
@@ -6,14 +6,68 @@=0A=
 #include "driver-ops.h"=0A=
 #include "led.h"=0A=
 =0A=
-int __ieee80211_suspend(struct ieee80211_hw *hw)=0A=
+int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wow =
*wow)=0A=
 {=0A=
 	struct ieee80211_local *local =3D hw_to_local(hw);=0A=
 	struct ieee80211_sub_if_data *sdata;=0A=
 	struct sta_info *sta;=0A=
+	=0A=
+	bool wow_netdev_found =3D false;=0A=
 =0A=
 	ieee80211_scan_cancel(local);=0A=
 =0A=
+=0A=
+	local->ps_before_suspend =3D !!(local->hw.conf.flags & =
IEEE80211_CONF_PS);=0A=
+=0A=
+	if (wow->triggers_enabled) {=0A=
+		if (!local->ps_before_suspend) {=0A=
+			local->hw.conf.flags |=3D IEEE80211_CONF_PS;=0A=
+			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);=0A=
+		}=0A=
+=0A=
+		del_timer_sync(&local->dynamic_ps_timer);=0A=
+		cancel_work_sync(&local->dynamic_ps_enable_work);=0A=
+=0A=
+		/*=0A=
+		 * Send nullfunc PS frame to AP so it can buffer frames for us,=0A=
+		 * unless we already are in that PS state. We'll discard all=0A=
+		 * frames except the ones our harware will process and use for=0A=
+		 * triggering a wake up.=0A=
+		 */=0A=
+		list_for_each_entry(sdata, &local->interfaces, list) {=0A=
+			struct ieee80211_if_managed *ifmgd;=0A=
+			if (sdata->dev !=3D wow->netdev)=0A=
+				continue;=0A=
+			/* WoW only applies to STAs */=0A=
+			if (WARN_ON(sdata->vif.type !=3D NL80211_IFTYPE_STATION))=0A=
+				continue;=0A=
+			ifmgd =3D &sdata->u.mgd;=0A=
+			/*=0A=
+			 * cfg80211 should have cleared the=0A=
+			 * triggers upon disassociation.=0A=
+			 */=0A=
+			if (WARN_ON(!ifmgd->associated))=0A=
+				continue;=0A=
+			if (!local->ps_before_suspend)=0A=
+				ieee80211_send_nullfunc(local, sdata, 1);=0A=
+			wow_netdev_found =3D true;=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		/*=0A=
+		 * WoW triggers should be cleared if the netdev claiming=0A=
+		 * it no longer exists=0A=
+		 */=0A=
+		WARN_ON(!wow_netdev_found);=0A=
+=0A=
+	}=0A=
+=0A=
+	if (wow_netdev_found)=0A=
+		printk(KERN_DEBUG "mac80211: WoW enabled interface found, "=0A=
+		       "will try to enable WoW during suspend\n");=0A=
+=0A=
+=0A=
+=0A=
 	ieee80211_stop_queues_by_reason(hw,=0A=
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);=0A=
 =0A=
@@ -69,6 +123,9 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)=0A=
 		switch(sdata->vif.type) {=0A=
 		case NL80211_IFTYPE_STATION:=0A=
 			ieee80211_sta_quiesce(sdata);=0A=
+			/* Don't remove the interface when WoW is enabled */=0A=
+			if (sdata->dev !=3D wow->netdev)=0A=
+				continue;=0A=
 			break;=0A=
 		case NL80211_IFTYPE_ADHOC:=0A=
 			ieee80211_ibss_quiesce(sdata);=0A=
@@ -94,9 +151,11 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)=0A=
 		drv_remove_interface(local, &sdata->vif);=0A=
 	}=0A=
 =0A=
-	/* stop hardware - this must stop RX */=0A=
-	if (local->open_count)=0A=
-		ieee80211_stop_device(local);=0A=
+=0A=
+			if (wow_netdev_found)=0A=
+				ieee80211_stop_device(local, wow);=0A=
+			else if (local->open_count)=0A=
+				ieee80211_stop_device(local, NULL);=0A=
 =0A=
 	local->suspended =3D true;=0A=
 	/* need suspended to be visible before quiescing is false */=0A=
diff --git a/net/mac80211/util.c b/net/mac80211/util.c=0A=
index bd40b11..bda9f53 100644=0A=
--- a/net/mac80211/util.c=0A=
+++ b/net/mac80211/util.c=0A=
@@ -1083,26 +1083,30 @@ u32 ieee80211_sta_get_rates(struct =
ieee80211_local *local,=0A=
 	return supp_rates;=0A=
 }=0A=
 =0A=
-void ieee80211_stop_device(struct ieee80211_local *local)=0A=
+void ieee80211_stop_device(struct ieee80211_local *local,  struct =
cfg80211_wow *wow)=0A=
 {=0A=
 	ieee80211_led_radio(local, false);=0A=
 =0A=
 	cancel_work_sync(&local->reconfig_filter);=0A=
 =0A=
 	flush_workqueue(local->workqueue);=0A=
-	drv_stop(local);=0A=
+	drv_stop(local, wow);=0A=
 }=0A=
 =0A=
-int ieee80211_reconfig(struct ieee80211_local *local)=0A=
+int ieee80211_reconfig(struct ieee80211_local *local, struct =
cfg80211_wow *wow)=0A=
 {=0A=
 	struct ieee80211_hw *hw =3D &local->hw;=0A=
 	struct ieee80211_sub_if_data *sdata;=0A=
 	struct sta_info *sta;=0A=
 	int res;=0A=
+	bool from_suspend =3D local->suspended;=0A=
 =0A=
 	if (local->suspended)=0A=
 		local->resuming =3D true;=0A=
 =0A=
+	if (from_suspend && local->ps_before_suspend)=0A=
+		local->hw.conf.flags |=3D IEEE80211_CONF_PS;=0A=
+=0A=
 	/* restart hardware */=0A=
 	if (local->open_count) {=0A=
 		/*=0A=
@@ -1122,11 +1126,16 @@ int ieee80211_reconfig(struct ieee80211_local =
*local)=0A=
 		ieee80211_led_radio(local, true);=0A=
 	}=0A=
 =0A=
-	/* add interfaces */=0A=
+	/*=0A=
+	 * Add all interfaces back again. If we had enabled WoW we=0A=
+	 * don't need to add the interface as we never removed it=0A=
+	 * at suspend.=0A=
+	 */=0A=
 	list_for_each_entry(sdata, &local->interfaces, list) {=0A=
 		if (sdata->vif.type !=3D NL80211_IFTYPE_AP_VLAN &&=0A=
 		    sdata->vif.type !=3D NL80211_IFTYPE_MONITOR &&=0A=
-		    ieee80211_sdata_running(sdata))=0A=
+		    ieee80211_sdata_running(sdata) &&=0A=
+		    sdata->dev !=3D wow->netdev)=0A=
 			res =3D drv_add_interface(local, &sdata->vif);=0A=
 	}=0A=
 =0A=
@@ -1235,6 +1244,18 @@ int ieee80211_reconfig(struct ieee80211_local =
*local)=0A=
 		return 0;=0A=
 =0A=
 #ifdef CONFIG_PM=0A=
+=0A=
+	if (!local->ps_before_suspend) {=0A=
+		list_for_each_entry(sdata, &local->interfaces, list) {=0A=
+			struct ieee80211_if_managed *ifmgd;=0A=
+			if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)=0A=
+				continue;=0A=
+			ifmgd =3D &sdata->u.mgd;=0A=
+			if (ifmgd->associated)=0A=
+				ieee80211_send_nullfunc(local, sdata, 0);=0A=
+		}=0A=
+	}=0A=
+=0A=
 	/* first set suspended false, then resuming */=0A=
 	local->suspended =3D false;=0A=
 	mb();=0A=
diff --git a/net/wireless/core.h b/net/wireless/core.h=0A=
index 58ab2c7..80c69b0 100644=0A=
--- a/net/wireless/core.h=0A=
+++ b/net/wireless/core.h=0A=
@@ -69,6 +69,9 @@ struct cfg80211_registered_device {=0A=
 =0A=
 	struct work_struct conn_work;=0A=
 	struct work_struct event_work;=0A=
+	=0A=
+	/* Used to keep track of user configurable triggers */=0A=
+	struct cfg80211_wow wow;=0A=
 =0A=
 	/* must be last because of the way we do wiphy_priv(),=0A=
 	 * and it should at least be aligned to NETDEV_ALIGN */=0A=
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c=0A=
index 85a23de..75c73b0 100644=0A=
--- a/net/wireless/nl80211.c=0A=
+++ b/net/wireless/nl80211.c=0A=
@@ -142,6 +142,8 @@ static const struct nla_policy =
nl80211_policy[NL80211_ATTR_MAX+1] =3D {=0A=
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] =3D { .type =3D NLA_U32 },=0A=
 	[NL80211_ATTR_WPA_VERSIONS] =3D { .type =3D NLA_U32 },=0A=
 	[NL80211_ATTR_PID] =3D { .type =3D NLA_U32 },=0A=
+	[NL80211_ATTR_WOW_TRIGGERS_SUPPORTED] =3D { .type =3D NLA_U32 },=0A=
+	[NL80211_ATTR_WOW_TRIGGERS_ENABLED] =3D { .type =3D NLA_U32 },=0A=
 	[NL80211_ATTR_4ADDR] =3D { .type =3D NLA_U8 },=0A=
 	[NL80211_ATTR_PMKID] =3D { .type =3D NLA_BINARY,=0A=
 				 .len =3D WLAN_PMKID_LEN },=0A=
@@ -4470,6 +4472,153 @@ static int nl80211_wiphy_netns(struct sk_buff =
*skb, struct genl_info *info)=0A=
 	return err;=0A=
 }=0A=
 =0A=
+=0A=
+static int nl80211_get_wow(struct sk_buff *skb,=0A=
+			   struct genl_info *info)=0A=
+{=0A=
+	struct cfg80211_registered_device *rdev;=0A=
+	struct net_device *dev;=0A=
+	struct wiphy *wiphy;=0A=
+	int err;=0A=
+	void *hdr;=0A=
+	struct sk_buff *msg;=0A=
+=0A=
+	rtnl_lock();=0A=
+	/* Look up our device */=0A=
+	err =3D get_rdev_dev_by_info_ifindex(info, &rdev, &dev);=0A=
+	if (err)=0A=
+		goto out_rtnl;=0A=
+=0A=
+	wiphy =3D &rdev->wiphy;=0A=
+=0A=
+	/* Draw up a netlink message to send back */=0A=
+	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);=0A=
+	if (!msg) {=0A=
+		err =3D -ENOBUFS;=0A=
+		goto out;=0A=
+	}=0A=
+	hdr =3D nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,=0A=
+			     NL80211_CMD_GET_WOW);=0A=
+	if (!hdr)=0A=
+		goto nla_put_failure;=0A=
+	NLA_PUT_U32(msg, NL80211_ATTR_WOW_TRIGGERS_SUPPORTED,=0A=
+		    wiphy->wow_triggers_supported);=0A=
+	NLA_PUT_U32(msg, NL80211_ATTR_WOW_TRIGGERS_ENABLED,=0A=
+		    rdev->wow.triggers_enabled);=0A=
+=0A=
+	genlmsg_end(msg, hdr);=0A=
+	err =3D genlmsg_reply(msg, info);=0A=
+	goto out;=0A=
+=0A=
+ nla_put_failure:=0A=
+	genlmsg_cancel(msg, hdr);=0A=
+	err =3D -EMSGSIZE;=0A=
+ out:=0A=
+	/* Cleanup */=0A=
+	cfg80211_unlock_rdev(rdev);=0A=
+	dev_put(dev);=0A=
+ out_rtnl:=0A=
+	rtnl_unlock();=0A=
+=0A=
+	return err;=0A=
+}=0A=
+=0A=
+static int nl80211_set_wow(struct sk_buff *skb, struct genl_info *info)=0A=
+{=0A=
+	int err;=0A=
+	struct cfg80211_registered_device *rdev;=0A=
+	struct net_device *dev;=0A=
+	struct wiphy *wiphy;=0A=
+	struct wireless_dev *wdev;=0A=
+	u32 triggers_requested;=0A=
+=0A=
+	if (!info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED])=0A=
+		return -EINVAL;=0A=
+=0A=
+	rtnl_lock();=0A=
+=0A=
+	err =3D get_rdev_dev_by_info_ifindex(info, &rdev, &dev);=0A=
+	if (err)=0A=
+		goto out_rtnl;=0A=
+=0A=
+	wiphy =3D &rdev->wiphy;=0A=
+=0A=
+	if (!wiphy->wow_triggers_supported) {=0A=
+		err =3D -EOPNOTSUPP;=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	triggers_requested =3D=0A=
+		nla_get_u32(info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED]);=0A=
+=0A=
+	if (rdev->wow.netdev) {=0A=
+		if (rdev->wow.netdev !=3D dev) {=0A=
+			err =3D -EALREADY;=0A=
+			goto out;=0A=
+		}=0A=
+		if (!triggers_requested) {=0A=
+			rdev->wow.triggers_enabled =3D 0;=0A=
+			rdev->wow.netdev =3D NULL;=0A=
+			goto out;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	/* This would be a no-op as the rdev->wow should be unconfigured */=0A=
+	if (!triggers_requested)=0A=
+		goto out;=0A=
+=0A=
+	/* We only support magic packet right now */=0A=
+	if (triggers_requested & ~NL80211_WOW_TRIGGER_MAGIC_PACKET) {=0A=
+		err =3D -EOPNOTSUPP;=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	if ((triggers_requested & wiphy->wow_triggers_supported) !=3D=0A=
+	    triggers_requested) {=0A=
+		err =3D -EOPNOTSUPP;=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	/*=0A=
+	 * It only makes sense to enable WoW if we're associated as a STA,=0A=
+	 * the AP should be buffering frames for us. We'll discard all frames=0A=
+	 * and only process the frames which will trigger us on in hardware.=0A=
+	 */=0A=
+	wdev =3D dev->ieee80211_ptr;=0A=
+=0A=
+	wdev_lock(wdev);=0A=
+=0A=
+	if (wdev->iftype !=3D NL80211_IFTYPE_STATION) {=0A=
+		err =3D -EINVAL;=0A=
+		wdev_unlock(wdev);=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	if (wdev->sme_state !=3D CFG80211_SME_CONNECTED) {=0A=
+		err =3D -ENOTCONN;=0A=
+		wdev_unlock(wdev);=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	wdev_unlock(wdev);=0A=
+=0A=
+	/*=0A=
+	 * Apply changes. This information gets passed to the=0A=
+	 * drivers during suspend.=0A=
+	 */=0A=
+	rdev->wow.netdev =3D dev;=0A=
+	rdev->wow.triggers_enabled =3D triggers_requested;=0A=
+=0A=
+ out:=0A=
+	/* cleanup */=0A=
+	cfg80211_unlock_rdev(rdev);=0A=
+	dev_put(dev);=0A=
+ out_rtnl:=0A=
+	rtnl_unlock();=0A=
+=0A=
+	return err;=0A=
+ }=0A=
+=0A=
 static int nl80211_setdel_pmksa(struct sk_buff *skb, struct genl_info =
*info)=0A=
 {=0A=
 	struct cfg80211_registered_device *rdev;=0A=
@@ -5154,6 +5303,22 @@ static struct genl_ops nl80211_ops[] =3D {=0A=
 		.policy =3D nl80211_policy,=0A=
 		.flags =3D GENL_ADMIN_PERM,=0A=
 	},=0A=
+=0A=
+=0A=
+	{=0A=
+		.cmd =3D NL80211_CMD_GET_WOW,=0A=
+		.doit =3D nl80211_get_wow,=0A=
+		.policy =3D nl80211_policy,=0A=
+		/* can be retrieved by unprivileged users */=0A=
+	},=0A=
+	{=0A=
+		.cmd =3D NL80211_CMD_SET_WOW,=0A=
+		.doit =3D nl80211_set_wow,=0A=
+		.policy =3D nl80211_policy,=0A=
+		.flags =3D GENL_ADMIN_PERM,=0A=
+	},=0A=
+=0A=
+=0A=
 	{=0A=
 		.cmd =3D NL80211_CMD_GET_INTERFACE,=0A=
 		.doit =3D nl80211_get_interface,=0A=
diff --git a/net/wireless/sme.c b/net/wireless/sme.c=0A=
index a8c2d6b..ec066a6 100644=0A=
--- a/net/wireless/sme.c=0A=
+++ b/net/wireless/sme.c=0A=
@@ -704,7 +704,21 @@ void __cfg80211_disconnected(struct net_device =
*dev, const u8 *ie,=0A=
 	wdev->wext.connect.ssid_len =3D 0;=0A=
 #endif=0A=
 =0A=
+/*=0A=
+	 * If we're not associated we cannot possibly get frames=0A=
+	 * to generate a WoW trigger. We also do this for security=0A=
+	 * purposes as with 802.11 we can roam to untrusted networks.=0A=
+	 * We require userspace to send a request to enable WoW for=0A=
+	 * each BSS.=0A=
+	 */=0A=
+	if (rdev->wow.netdev && rdev->wow.netdev =3D=3D dev) {=0A=
+		rdev->wow.netdev =3D NULL;=0A=
+		rdev->wow.triggers_enabled =3D 0;=0A=
+	}=0A=
+=0A=
 	schedule_work(&cfg80211_disconnect_work);=0A=
+	=0A=
+=0A=
 }=0A=
 =0A=
 void cfg80211_disconnected(struct net_device *dev, u16 reason,=0A=
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c=0A=
index 74a9e3c..31807e2 100644=0A=
--- a/net/wireless/sysfs.c=0A=
+++ b/net/wireless/sysfs.c=0A=
@@ -84,7 +84,7 @@ static int wiphy_suspend(struct device *dev, =
pm_message_t state)=0A=
 =0A=
 	if (rdev->ops->suspend) {=0A=
 		rtnl_lock();=0A=
-		ret =3D rdev->ops->suspend(&rdev->wiphy);=0A=
+		ret =3D rdev->ops->suspend(&rdev->wiphy, &rdev->wow);=0A=
 		rtnl_unlock();=0A=
 	}=0A=
 =0A=
@@ -103,7 +103,7 @@ static int wiphy_resume(struct device *dev)=0A=
 =0A=
 	if (rdev->ops->resume) {=0A=
 		rtnl_lock();=0A=
-		ret =3D rdev->ops->resume(&rdev->wiphy);=0A=
+		ret =3D rdev->ops->resume(&rdev->wiphy, &rdev->wow);=0A=
 		rtnl_unlock();=0A=
 	}=0A=
 =0A=
-- =0A=
1.7.0.4=0A=
=0A=

------=_NextPart_001_004E_01CB5403.6DBCDCC0--

------=_NextPart_000_004D_01CB5403.6DBCDCC0
Content-Type: application/pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIYAzCCA58w
ggKHoAMCAQICASYwDQYJKoZIhvcNAQEFBQAwcTELMAkGA1UEBhMCREUxHDAaBgNVBAoTE0RldXRz
Y2hlIFRlbGVrb20gQUcxHzAdBgNVBAsTFlQtVGVsZVNlYyBUcnVzdCBDZW50ZXIxIzAhBgNVBAMT
GkRldXRzY2hlIFRlbGVrb20gUm9vdCBDQSAyMB4XDTk5MDcwOTEyMTEwMFoXDTE5MDcwOTIzNTkw
MFowcTELMAkGA1UEBhMCREUxHDAaBgNVBAoTE0RldXRzY2hlIFRlbGVrb20gQUcxHzAdBgNVBAsT
FlQtVGVsZVNlYyBUcnVzdCBDZW50ZXIxIzAhBgNVBAMTGkRldXRzY2hlIFRlbGVrb20gUm9vdCBD
QSAyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqwujNeCLKRSxFIWvPBDkOW81XUqu
3ephjZVJ9G9koxpgZqSpQCKE2dSl5XiTDmgBrblNXDrO07ioQkDfz6O6gllqkhusHJraCCslJ/lp
I0fx4Ossepv1EwLQfjR8wp48AFmr9doM9TI8K6xQ2tbD3oOUyqgMmTIOCEhWW2r72uFYWAFJX3JB
PBUGAY5draq4k7TNnuun6GotUjTbOu9cdVHa2/Mx+e5xmDLEVBVEDPmbVe2t3xgIoKOGiknuUwWP
GUzV3lh5m9JqHEKrxdWnz2gPluThYZh2YciRfNY+AOKRUIfhnQrmrZfSHcY6fcu82gM01Y5bAfVq
B7cWtm5KfwIDAQABo0IwQDAdBgNVHQ4EFgQUMcN5G7r1U9cX4Il6LRdsCrMrnTMwDwYDVR0TBAgw
BgEB/wIBBTAOBgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQEFBQADggEBAJRkWa05ZOcp6xP+WsOL
E1fIBCTwdHfAYONn++mJpoO/loJ8btTDPe+egG67KbSYerE7VOs5F0d+Go4L/B8xWTEEss4X8yzH
YjZV4iLYiVW0mEiqZPrWHDbYRHhaWiM6V5f1ejBPrp9qTEsrjqAD4z7gqdTSe9KzqOJyPK2e/4BZ
5JtFtPY7sM05GZgy5eohYZDkMSGONLH3LzVKhRDa54o3Ib5ZY+DyhYgxU9RUFIVwefQuBncndS8f
uIr5/sW62Dbkg+znZbe/Y1rzRq+BlDfUQYzWI9Yez/VoG0Rjolq6pzVZoeVwBZsOI1eZlAptujlj
KIaS8xiE2PvRzwVWZFcwggQuMIIDFqADAgECAgIBDDANBgkqhkiG9w0BAQUFADBxMQswCQYDVQQG
EwJERTEcMBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRy
dXN0IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMDcxMjA1
MTUxODU4WhcNMTkwNjMwMjM1OTU5WjBnMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2Zl
cjEhMB8GA1UECxMYRnJhdW5ob2ZlciBDb3Jwb3JhdGUgUEtJMSAwHgYDVQQDExdGcmF1bmhvZmVy
IFJvb3QgQ0EgMjAwNzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMM9HslljVuIN/c+
wSG2VN6wOlcbGhzumAh0AVpvtd82VytERc7zRhNldpWYVMeohRVuEqQX6AvhIacxPSnd/6PWT9K0
if1jStqrU+9ZBbRP4jsqkZnAy2VXgaMwk5AOyb39FTIyCKRIfFYF8rs2ieJIwm9LkgwlRb6tPtTH
Ae2xyBK0MAhup29/eiCnu7TlNYBULBmP2UvAHatD+GEUlPuwHV23kexiwJHRXt2nC7MtH2Y5GDyu
BBTl0n022bLNpxOwzEWdVgRRcTM2XC9dUROeT0iQDpdaS3DbuXnZodaUyJLQpftgvy2tnnEAF4bA
/UhmnRRMBU5M0XFEC9B6D7ECAwEAAaOB2TCB1jAfBgNVHSMEGDAWgBQxw3kbuvVT1xfgiXotF2wK
syudMzAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFC9FQh4xBYDVcNj4HVfLW3rVPZz3MBIGA1Ud
EwEB/wQIMAYBAf8CAQEwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDovL3BraS50ZWxlc2VjLmRlL2Nn
aS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNybF9mb3JtYXQ9WF81MDkmLWlzc3Vl
cj1EVF9ST09UX0NBXzIwDQYJKoZIhvcNAQEFBQADggEBABq3THo85d3CY7LehiVORWJM9PKPX13X
5Y3ODtf1lOGLkzE2p5oj52fhUsFaGNaZ4YBkOA9KNTNdZnoo3Dh/N3LNUnVuEI5sfYz3Ket3wrkZ
BdS3PWG66AUS1FBiU+8iVGL8TQHDXtQNg3RpUdU8nqzbpCt8bYSW03FNz9UtcaOSxD9Vz5s9I3cH
V+nIzh2XtjP7kZdglg/39t5vJZASqxlH1UQjrsGSNSi/KkNeD+oHXdJE0IWC4xK8R+osrfjwQVJ9
Nroin3qgMu9LvPk6B7Ypxn04XzVVfjjyP3yz7i1uIXhfuRPP795lgMgl9WYtVEqtztkuDjDPgDOn
ixly6kEwggTGMIIDrqADAgECAgphHTMZAAAAAAADMA0GCSqGSIb3DQEBBQUAMGcxCzAJBgNVBAYT
AkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEwHwYDVQQLExhGcmF1bmhvZmVyIENvcnBvcmF0ZSBQ
S0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIgUm9vdCBDQSAyMDA3MB4XDTA3MTIxMjE0NDkzNVoXDTE5
MDYzMDIzNTk1OVowZzELMAkGA1UEBhMCREUxEzARBgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsT
GEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEgMB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIw
MDcwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDCdBBRy3XRgfErNZ1agjqvkq7NAvyu
yPsgdw7/aBIVkEmnZ3xoJF/6DiYaZT5KngkK04dPMxGKa1WiS02lT1Yb48d4efijC95VRmSH2owP
PU6JYS8JPppdvVW6leZy4Ta0sHWctee2+nQruSX38b6TucFwp/eWf0y8i3XrsYFR7PzJ4XM75gWw
UUvjsPVKCp/j2b8mJlBHTh4PHAOTxhWkT/avPKu9+FZ5SPluPsuwaDecLbqla6lm26TkNrB2KPa4
r92/seVnbDK1YnihgKUP3Tb4Aeb7rgHIUZ7ADWR4KQIjwsz+/0BWGKpNrp3XMRF8D4KO9qInwd7k
Gd8Rzlf3AgMBAAGjggFyMIIBbjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBRPHa+Iym24
qhwJ+cXREe1ZtJP6CzAOBgNVHQ8BAf8EBAMCAQYwHwYDVR0jBBgwFoAUL0VCHjEFgNVw2PgdV8tb
etU9nPcwdQYDVR0fBG4wbDBqoGigZoYxaHR0cDovL2NybC5wa2kuZnJhdW5ob2Zlci5kZS9maGct
cm9vdC1jYS0yMDA3LmNybIYxaHR0cDovL2NybC5mcmF1bmhvZmVyLXBraS5kZS9maGctcm9vdC1j
YS0yMDA3LmNybDCBkAYIKwYBBQUHAQEEgYMwgYAwPgYIKwYBBQUHMAKGMmh0dHA6Ly9jZXJ0LnBr
aS5mcmF1bmhvZmVyLmRlL2ZoZy1yb290LWNhLTIwMDcuY2VyMD4GCCsGAQUFBzAChjJodHRwOi8v
Y2VydC5mcmF1bmhvZmVyLXBraS5kZS9maGctcm9vdC1jYS0yMDA3LmNlcjANBgkqhkiG9w0BAQUF
AAOCAQEAAHdsjDP57lcEJcrLiDnmTkykzsKWSxmGTbhEV8KVqRA37DBVMV/1nrW7tWtaoXfseksl
2OFdQs3BQzhhd8AO28iFf+ncgudyPZbmU48vc41LIy2bnA+I3jY2t0BLt/bELGLLhNzE3xRSYK/z
XgBTB1ZJBxsd5VV2/hdyd/vcXlx5P8Af8iCnf0SIjDE0+Pmvq2tjEwrGAHuJICdL89k12BjfLbo4
woLFFG8HyQvcKzogiTDSTNYu7FFalSiKLMFu4eUKVlDbtROEQLAxM+3XqVwmGgCMD6axCJK9HROt
86h4ZjOHoEu4hpgXzUKIVDuoyTljXCfXSManNHP+FlB4PDCCBagwggSQoAMCAQICChDLDkIAAAAA
SmIwDQYJKoZIhvcNAQEFBQAwZzELMAkGA1UEBhMCREUxEzARBgNVBAoTCkZyYXVuaG9mZXIxITAf
BgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEgMB4GA1UEAxMXRnJhdW5ob2ZlciBVc2Vy
IENBIDIwMDcwHhcNMDgxMDE2MTAzMjE0WhcNMTQxMDE1MTAzMjE0WjBaMQswCQYDVQQGEwJERTET
MBEGA1UEChMKRnJhdW5ob2ZlcjEOMAwGA1UECxMFRk9LVVMxDzANBgNVBAsTBlBlb3BsZTEVMBMG
A1UEAxMMQnVyYWsgU2ltc2VrMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4/j8Cq0T
LI1gTUMObyoy0q5Z53qQ7rMz2Z5EEmIRrlXXY8kPjmlICf02zX6vskC/s3lUbnp+YxrQDmLFWzmk
b4g7lrwECjYQXm4N6bA4mfTYEWbaugII0H/9Fl5ix1hZhdOLwDqQ66TED5yc3KemV6sQ9rlLrmO8
nErzq45qQdC1irmT+WzWUty4cfZ63cet4+ZAm3dRBBJB5dYyNDOKfypJEXRrUeb79OkGy0UrcL4S
8eu6dr+Y1LbJWuJBfyeTQIacYXgcvSHDn6eI4/ApcMI+WFFnLcIXoONZJTVp6S1GlkqoMk3gS7no
mQk0Ne/W3xwFWLG/uTbGM6uNMpzYTQIDAQABo4ICYTCCAl0wDgYDVR0PAQH/BAQDAgbAMCsGA1Ud
EQQkMCKBIGJ1cmFrLnNpbXNla0Bmb2t1cy5mcmF1bmhvZmVyLmRlMB0GA1UdDgQWBBSP/XQQ8rB8
HBO8RjXkd12B6unhMjAfBgNVHSMEGDAWgBRPHa+Iym24qhwJ+cXREe1ZtJP6CzB1BgNVHR8EbjBs
MGqgaKBmhjFodHRwOi8vY3JsLnBraS5mcmF1bmhvZmVyLmRlL2ZoZy11c2VyLWNhLTIwMDcuY3Js
hjFodHRwOi8vY3JsLmZyYXVuaG9mZXItcGtpLmRlL2ZoZy11c2VyLWNhLTIwMDcuY3JsMIIBCgYI
KwYBBQUHAQEEgf0wgfowPgYIKwYBBQUHMAKGMmh0dHA6Ly9jZXJ0LnBraS5mcmF1bmhvZmVyLmRl
L2ZoZy11c2VyLWNhLTIwMDcuY2VyMD4GCCsGAQUFBzAChjJodHRwOi8vY2VydC5mcmF1bmhvZmVy
LXBraS5kZS9maGctdXNlci1jYS0yMDA3LmNlcjA7BggrBgEFBQcwAYYvaHR0cDovL2ZoZy11c2Vy
LWNhLTIwMDcub2NzcC5wa2kuZnJhdW5ob2Zlci5kZS8wOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGct
dXNlci1jYS0yMDA3Lm9jc3AuZnJhdW5ob2Zlci1wa2kuZGUvMBMGA1UdJQQMMAoGCCsGAQUFBwME
MEQGA1UdIAQ9MDswOQYLKwYBBAGGClADAQEwKjAoBggrBgEFBQcCARYcaHR0cDovL3BraS5mcmF1
bmhvZmVyLmRlL2NwLzANBgkqhkiG9w0BAQUFAAOCAQEAG6FTr4/gKhN47dFYahdJvJbnpXPN+p3k
t/L7uj3NZkBhVng/DTed+GLXi2q0dYkFg9OSnaOXBvnqyQ/WzRrwnlnubOvbwIDXdmv4h+zwvKov
RWDOUXYfD+5x7kb2kb0bdvx/cgpeMws66Lht0T35wd1fiwG1TUu6Gt/CWMsq09ktUZTNAfOhFBrQ
o92qTntB3n6BwBfFz+MDChdi/vTM3uGrEcUVH9Q2PNIqn1siq6SRCoUfZPRt/d+1bO/bb5r0QnYC
Xc1s/+haKPxaE355vF8c44JIAoNITit6vd8xcamLPuOhBH5E66oeOFHTp6f6Nz02ura4nQxOjak1
ef2/IDCCBbQwggScoAMCAQICChDLC3MAAAAASmEwDQYJKoZIhvcNAQEFBQAwZzELMAkGA1UEBhMC
REUxEzARBgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBL
STEgMB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIwMDcwHhcNMDgxMDE2MTAzMjEzWhcNMTQx
MDE1MTAzMjEzWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEOMAwGA1UECxMF
Rk9LVVMxDzANBgNVBAsTBlBlb3BsZTEVMBMGA1UEAxMMQnVyYWsgU2ltc2VrMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxugMz/DdOl8MAyli8vlMXUxof8/7XqhJaIUUoRQbR/DbszqZ
VMlD2tRiWWpNA3LTr0sVPyhjDU7e/7LmICLYKqeYAggE54ehQZUIrsjTr2MCEnnfX0Zp4w0Gu8yw
CfdjSSXk2EpUJbTkCRQNB1qq+wbACnJ4f5b0efMn4qCCaqFMLNDokY6sEa++cEkn8MpS2Ja4PzE4
e9v3k5Yp/UxAri9oCvwPAWY4x/P9aeTsulamD8WD7A2F38IXuUXD76tVraM/b4aqvHPmbeB1N1Sp
V/Gs1O4eehQAfacSpn98MFQ4zs/QOiKcmYwTVDYMihBJKCW8LcgeyaNnsn1TFWaW5QIDAQABo4IC
bTCCAmkwDgYDVR0PAQH/BAQDAgQwMCsGA1UdEQQkMCKBIGJ1cmFrLnNpbXNla0Bmb2t1cy5mcmF1
bmhvZmVyLmRlMB0GA1UdDgQWBBT3SwHoDf+d70rz2OH6u6WkOzB1cDAfBgNVHSMEGDAWgBRPHa+I
ym24qhwJ+cXREe1ZtJP6CzB1BgNVHR8EbjBsMGqgaKBmhjFodHRwOi8vY3JsLnBraS5mcmF1bmhv
ZmVyLmRlL2ZoZy11c2VyLWNhLTIwMDcuY3JshjFodHRwOi8vY3JsLmZyYXVuaG9mZXItcGtpLmRl
L2ZoZy11c2VyLWNhLTIwMDcuY3JsMIIBCgYIKwYBBQUHAQEEgf0wgfowPgYIKwYBBQUHMAKGMmh0
dHA6Ly9jZXJ0LnBraS5mcmF1bmhvZmVyLmRlL2ZoZy11c2VyLWNhLTIwMDcuY2VyMD4GCCsGAQUF
BzAChjJodHRwOi8vY2VydC5mcmF1bmhvZmVyLXBraS5kZS9maGctdXNlci1jYS0yMDA3LmNlcjA7
BggrBgEFBQcwAYYvaHR0cDovL2ZoZy11c2VyLWNhLTIwMDcub2NzcC5wa2kuZnJhdW5ob2Zlci5k
ZS8wOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGctdXNlci1jYS0yMDA3Lm9jc3AuZnJhdW5ob2Zlci1w
a2kuZGUvMB8GA1UdJQQYMBYGCisGAQQBgjcKAwQGCCsGAQUFBwMEMEQGA1UdIAQ9MDswOQYLKwYB
BAGGClADAQEwKjAoBggrBgEFBQcCARYcaHR0cDovL3BraS5mcmF1bmhvZmVyLmRlL2NwLzANBgkq
hkiG9w0BAQUFAAOCAQEAgOFdC0c38/nirLUIOLHYFLnguuEawTbuXvXeYcaSiK0xESYSd4YuU+8p
oD6CnF6qnKHkKiJ0mcAo+Rdxd5YVKXgrheIwGxwRcEQgzKMXqf5jyQY5msEcze7/zL2I8mp2q2sv
EAZbs+Ji9DdvLss3eiqlyacNhy+1ldLCqH9lLSBa6YLvpJxytNo+xj6Qf3xaAtCBZ/0MFeq5xTtQ
h+A8X1YqWSEiDoyYsydc199UBFp/rOB9IuNv3zG1pDmDBEaVLnCDZ72oXWTPwB1fcidvguR1JyDL
HB/gVGxB/MhtiFW5fpp/h4KmJpT2jHnGyAf771qGbGKFKZRBMstANb5pbTGCA2owggNmAgEBMHUw
ZzELMAkGA1UEBhMCREUxEzARBgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIg
Q29ycG9yYXRlIFBLSTEgMB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCChDLDkIAAAAA
SmIwCQYFKw4DAhoFAKCCAcowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMTAwOTE0MDk1MzIxWjAjBgkqhkiG9w0BCQQxFgQUF2G2RqHsC/BqR5Tq9TH/Hk05FnMwWwYJ
KoZIhvcNAQkPMU4wTDAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAw
BwYFKw4DAgcwDQYIKoZIhvcNAwICASgwBwYFKw4DAhowgYQGCSsGAQQBgjcQBDF3MHUwZzELMAkG
A1UEBhMCREUxEzARBgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9y
YXRlIFBLSTEgMB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCChDLC3MAAAAASmEwgYYG
CyqGSIb3DQEJEAILMXegdTBnMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEhMB8G
A1UECxMYRnJhdW5ob2ZlciBDb3Jwb3JhdGUgUEtJMSAwHgYDVQQDExdGcmF1bmhvZmVyIFVzZXIg
Q0EgMjAwNwIKEMsLcwAAAABKYTANBgkqhkiG9w0BAQEFAASCAQBA/4g31vIXD4fW1mKDJdmLoGm4
fvLcqDe5q6OJ35Xuvy+uIqejM6p6CqSsdm85bbyKoxjEHvTdWZbNpWefZIW07fUgbXbvuQp0mADy
TaCPABU2lCiMUWf6qetdp6TCXCEwdanTDtQzLRk2vxa1B2dd3N1HolIKvvuAAixf9OQyAeZyHQFM
XAHJ4pw8Jekn1lpAs+YyIn1PltbzVkStud9HBene84+F22r3MlMk+YmTgEC4QtDpRZLrwB8u5356
DZlmMbfQ45Pv4/uf5gbMEZ3SQVT+Vvt4XgWw2n1gDb8kQt4kJfgWKOcjfzDSPh7HN65zfm0zoBh5
21JKgjAtZGkGAAAAAAAA

------=_NextPart_000_004D_01CB5403.6DBCDCC0--
