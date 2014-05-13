Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52053 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaEMNnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 09:43:18 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so408445wgh.16
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 06:43:17 -0700 (PDT)
Message-ID: <53722142.6070105@gmail.com> (sfid-20140513_154321_547483_D4AEFCB9)
Date: Tue, 13 May 2014 16:42:26 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: iwlwifi 2014-05-13
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9rvqlQ1CqsPDpOtkUhWGPWtWB5DAcLuL8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9rvqlQ1CqsPDpOtkUhWGPWtWB5DAcLuL8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

here is a bit more content content for 3.15.

We have here a fix from David Spinadel that makes a previous fix more com=
plete, and an off-by-one issue fixed by Eliad in the same area.
I fix the monitor that broke on the way.

Let me know about issues you may have.

Cheers,


The following changes since commit 83f7a85f1134c6e914453f5747435415a23d51=
6b:

  iwlwifi: pcie: disable interrupts upon PCIe alloc (2014-05-07 22:54:32 =
+0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to b538b8ce76f69f7fa225bc0817bbb361b877ea23:

  iwlwifi: mvm: prevent sched scan while not idle (2014-05-13 15:05:32 +0=
300)

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: prevent sched scan while not idle

Eliad Peller (1):
      iwlwifi: mvm: fix off-by-one in scan channels configuration

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix setting channel in monitor mode

 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  6 +++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     |  2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c    | 16 ++++++++--------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wi=
reless/iwlwifi/mvm/mac80211.c
index 593f723..b41dc84 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1007,7 +1007,7 @@ static void iwl_mvm_mc_iface_iterator(void *_data, =
u8 *mac,
        memcpy(cmd->bssid, vif->bss_conf.bssid, ETH_ALEN);
        len =3D roundup(sizeof(*cmd) + cmd->count * ETH_ALEN, 4);

-       ret =3D iwl_mvm_send_cmd_pdu(mvm, MCAST_FILTER_CMD, CMD_SYNC, len=
, cmd);
+       ret =3D iwl_mvm_send_cmd_pdu(mvm, MCAST_FILTER_CMD, CMD_ASYNC, le=
n, cmd);
        if (ret)
                IWL_ERR(mvm, "mcast filter cmd error. ret=3D%d\n", ret);
 }
@@ -1023,7 +1023,7 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm=
 *mvm)
        if (WARN_ON_ONCE(!mvm->mcast_filter_cmd))
                return;

-       ieee80211_iterate_active_interfaces(
+       ieee80211_iterate_active_interfaces_atomic(
                mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
                iwl_mvm_mc_iface_iterator, &iter_data);
 }
@@ -1807,7 +1807,7 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee=
80211_hw *hw,

        mutex_lock(&mvm->mutex);

-       if (iwl_mvm_is_associated(mvm)) {
+       if (!iwl_mvm_is_idle(mvm)) {
                ret =3D -EBUSY;
                goto out;
        }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireles=
s/iwlwifi/mvm/mvm.h
index 84c75a1..f1ec098 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1004,7 +1004,7 @@ static inline bool iwl_mvm_vif_low_latency(struct i=
wl_mvm_vif *mvmvif)
 }

 /* Assoc status */
-bool iwl_mvm_is_associated(struct iwl_mvm *mvm);
+bool iwl_mvm_is_idle(struct iwl_mvm *mvm);

 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wirele=
ss/iwlwifi/mvm/scan.c
index cba88a3..c28de54 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -732,7 +732,7 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
        int band_2ghz =3D mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_cha=
nnels;
        int band_5ghz =3D mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_cha=
nnels;
        int head =3D 0;
-       int tail =3D band_2ghz + band_5ghz;
+       int tail =3D band_2ghz + band_5ghz - 1;
        u32 ssid_bitmap;
        int cmd_len;
        int ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wirel=
ess/iwlwifi/mvm/utils.c
index 6fdbef9..2180902 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -645,21 +645,21 @@ bool iwl_mvm_low_latency(struct iwl_mvm *mvm)
        return result;
 }

-static void iwl_mvm_assoc_iter(void *_data, u8 *mac, struct ieee80211_vi=
f *vif)
+static void iwl_mvm_idle_iter(void *_data, u8 *mac, struct ieee80211_vif=
 *vif)
 {
-       bool *assoc =3D _data;
+       bool *idle =3D _data;

-       if (vif->bss_conf.assoc)
-               *assoc =3D true;
+       if (!vif->bss_conf.idle)
+               *idle =3D false;
 }

-bool iwl_mvm_is_associated(struct iwl_mvm *mvm)
+bool iwl_mvm_is_idle(struct iwl_mvm *mvm)
 {
-       bool assoc =3D false;
+       bool idle =3D true;

        ieee80211_iterate_active_interfaces_atomic(
                        mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-                       iwl_mvm_assoc_iter, &assoc);
+                       iwl_mvm_idle_iter, &idle);

-       return assoc;
+       return idle;
 }


--9rvqlQ1CqsPDpOtkUhWGPWtWB5DAcLuL8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTciFeAAoJEC0Llv5uNjIBi94P/0Fd5oomYuyKe0mtqEGH47Qe
VgX6xjUaev9o32ERLlE02nywItXQ0DUwJyF790HriwXd0tupqZMvPGuh8zqnp6EJ
Q9x06d9FA1L6nVHfOvu6TZa0fsNRCs2oSxtjoxE+G8reaEsrr7nvGJrPywrSHOtC
bGlG7IWaYHMUxRt6ejfXx5lP0LtxvdcQcuxfM+r2Tk3a30dDEfAT0QJ6KU11bXbs
fS/lalrvPQ199Mfxh6EGarhqYyageHiyee6MaVT2cMLbFKvWJFnsHL9jViwWMGAf
j6BgVzscZEJ+BQ7ZlMfy9SE5aAOhGelQeP5DToVa96tNjFtt2rU0XiMmROvvtCOI
LdeGLuMdJTFU3Hya8mSjN2hTaAAA2jffv+UdX24f9pUq3b6YXbcRTMrdABfcNk3p
3+vx0CKEpMjSf6rPfA8B/2jVLO5vFx+VOAelPDQLN9BFxz9rUfwgZ7FVSEFk0wXC
D5dGxdhDzM8IJ8YK3imz09ssVMXGrD/lJJ7cnfOdIv8Y7oi5lw15UCFxijMwiwjg
XsjUuoF6AzD9Olv86S+ovkrKXHvfiriPFkWTrR2pAiX8SOTSk2Z2muuS+JveXVV0
vwuuz2sjb5+PHKX4ad0leOJV6c2tPFRKwmYYm4mKJ0B0Yq9pEh2dMzMjmkpGI1pT
6HMRh/8O2M0xVCeJEXaT
=g5zu
-----END PGP SIGNATURE-----

--9rvqlQ1CqsPDpOtkUhWGPWtWB5DAcLuL8--
