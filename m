Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:44992 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751675AbeDLIAG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 04:00:06 -0400
Received: by mail-qk0-f174.google.com with SMTP id n139so5078015qke.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 01:00:05 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k:add support for multicast rate control
Date: Thu, 12 Apr 2018 10:00:02 +0200
Message-ID: <1955741.cYYJuYeSWo@bentobox> (sfid-20180412_100045_935269_ED2E94D8)
In-Reply-To: <1523505886-14695-1-git-send-email-pradeepc@codeaurora.org>
References: <1523505886-14695-1-git-send-email-pradeepc@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1958249.qQOIodAC0M"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1958249.qQOIodAC0M
Content-Type: multipart/mixed; boundary="nextPart2487861.YrrPN94Qg5"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart2487861.YrrPN94Qg5
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Mittwoch, 11. April 2018 21:04:46 CEST Pradeep Kumar Chitrapu wrote:
> Issues wmi command to firmware when multicast rate change is received
> with the new BSS_CHANGED_MCAST_RATE flag.
[...]
>  
> +	if (changed & BSS_CHANGED_MCAST_RATE &&
> +	    !WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def))) {
> +		band = def.chan->band;
> +		sband = &ar->mac.sbands[band];
> +		vdev_param = ar->wmi.vdev_param->mcast_data_rate;
> +		rate_index = vif->bss_conf.mcast_rate[band] - 1;
> +		rate = ATH10K_HW_MCS_RATE(sband->bitrates[rate_index].hw_value);
> +		ath10k_dbg(ar, ATH10K_DBG_MAC,
> +			   "mac vdev %d mcast_rate %d\n",
> +			   arvif->vdev_id, rate);
> +
> +		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
> +						vdev_param, rate);
> +		if (ret)
> +			ath10k_warn(ar,
> +				    "failed to set mcast rate on vdev"
> +				    " %i: %d\n", arvif->vdev_id,  ret);
> +	}
> +
>  	mutex_unlock(&ar->conf_mutex);
>  }
>  
> 

I see two major problems here without checking the actual implementation 
details:

* hw_value is incorrect for a couple of devices. Some devices use a different 
  mapping when they receive rates inforamtion (hw_value) then the ones you use
  for the mcast/bcast/beacon rate setting. I've handled in my POC patch like
  this:

    +		if (ath10k_mac_bitrate_is_cck(sband->bitrates[i].bitrate)) {
    +			preamble = WMI_RATE_PREAMBLE_CCK;
    +
    +			/* QCA didn't use the correct rate values for CA99x0
    +			 * and above (ath10k_g_rates_rev2)
    +			 */
    +			switch (sband->bitrates[i].bitrate) {
    +			case 10:
    +				hw_value = ATH10K_HW_RATE_CCK_LP_1M;
    +				break;
    +			case 20:
    +				hw_value = ATH10K_HW_RATE_CCK_LP_2M;
    +				break;
    +			case 55:
    +				hw_value = ATH10K_HW_RATE_CCK_LP_5_5M;
    +				break;
    +			case 110:
    +				hw_value = ATH10K_HW_RATE_CCK_LP_11M;
    +				break;
    +			}
    +		} else {
    +			preamble = WMI_RATE_PREAMBLE_OFDM;
    +		}

* bcast + mcast (+ mgmt) have to be set separately

I have attached my POC patch (which I was using for packet loss based mesh 
metrics) and to work around (using debugfs) the silly mgmt vs. mcast/bcast 
settings of the QCA fw for APs.

Many of the information came from Ben Greears ath10k-ct driver 
https://github.com/greearb/ath10k-ct 

Kind regards,	
	Sven
--nextPart2487861.YrrPN94Qg5
Content-Disposition: attachment; filename="9536-ath10k-Allow-to-configure-bcast-mcast-rate.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="9536-ath10k-Allow-to-configure-bcast-mcast-rate.patch"

From: Sven Eckelmann <sven@narfation.org>
Date: Fri, 16 Feb 2018 13:49:51 +0100
Subject: [PATCH] ath10k: Allow to configure bcast/mcast rate

TODO:

 * find better way to get mcast_rate
 * better get the lowest configured basic rate for APs
 * remove netifd WAR

Signed-off-by: Sven Eckelmann <sven@narfation.org>

Forwarded: no
 not yet in the correct shape
---
 drivers/net/wireless/ath/ath10k/core.h  |   1 +
 drivers/net/wireless/ath/ath10k/debug.c |  78 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |  11 ++++
 drivers/net/wireless/ath/ath10k/mac.c   | 113 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h   |   1 +
 5 files changed, 204 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 3ff4a423c4d873d322deebd3c498ef0688e84e05..a53f7b2042f4a80bbd358b00d4d26d6fabe5df6e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -423,6 +423,7 @@ struct ath10k_vif {
 	bool nohwcrypt;
 	int num_legacy_stations;
 	int txpower;
+	u16 mcast_rate;
 	struct wmi_wmm_params_all_arg wmm_params;
 	struct work_struct ap_csa_work;
 	struct delayed_work connection_loss_work;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index fa72ef54605e74f501ab655a6afd0a50b89b6b7e..fc59f214d2a5288f2ac41824e584def787b4799c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -23,6 +23,7 @@
 #include <linux/firmware.h>
 
 #include "core.h"
+#include "mac.h"
 #include "debug.h"
 #include "hif.h"
 #include "wmi-ops.h"
@@ -2454,6 +2455,83 @@ void ath10k_debug_unregister(struct ath10k *ar)
 	cancel_delayed_work_sync(&ar->debug.htt_stats_dwork);
 }
 
+
+
+static ssize_t ath10k_write_mcast_rate(struct file *file,
+				       const char __user *ubuf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath10k_vif *arvif = file->private_data;
+	struct ath10k *ar = arvif->ar;
+	ssize_t ret = 0;
+	u32 mcast_rate;
+
+	ret = kstrtou32_from_user(ubuf, count, 0, &mcast_rate);
+	if (ret)
+		return ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	arvif->mcast_rate = mcast_rate;
+	ret = ath10k_mac_set_mcast_rate(arvif);
+	if (ret)
+		goto unlock;
+
+	ret = count;
+unlock:
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
+}
+
+static ssize_t ath10k_read_mcast_rate(struct file *file, char __user *ubuf,
+				      size_t count, loff_t *ppos)
+
+{
+	struct ath10k_vif *arvif = file->private_data;
+	struct ath10k *ar = arvif->ar;
+	char buf[32];
+	int len = 0;
+	u16 mcast_rate;
+
+	mutex_lock(&ar->conf_mutex);
+	mcast_rate = arvif->mcast_rate;
+	mutex_unlock(&ar->conf_mutex);
+
+	len = scnprintf(buf, sizeof(buf) - len, "%u\n", mcast_rate);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_mcast_rate = {
+	.read = ath10k_read_mcast_rate,
+	.write = ath10k_write_mcast_rate,
+	.open = simple_open
+};
+
+int ath10k_debug_register_netdev(struct ath10k_vif *arvif)
+{
+	struct dentry *debugfs_netdev;
+
+	debugfs_netdev = debugfs_create_dir("ath10k", arvif->vif->debugfs_dir);
+	if (IS_ERR_OR_NULL(debugfs_netdev)) {
+		if (IS_ERR(debugfs_netdev))
+			return PTR_ERR(debugfs_netdev);
+
+		return -ENOMEM;
+	}
+
+	debugfs_create_file("mcast_rate", S_IRUGO | S_IWUSR,
+			    debugfs_netdev, arvif,
+			    &fops_mcast_rate);
+
+	return 0;
+}
+
+void ath10k_debug_unregister_netdev(struct ath10k_vif *arvif)
+{
+}
+
 #endif /* CPTCFG_ATH10K_DEBUGFS */
 
 #ifdef CPTCFG_ATH10K_DEBUG
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 43dbcdbb3e1bb7bb495377f6a6c1d487453a0a0d..24edf6cf15de1bf22c1126e22051b0aad604d6d7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -77,6 +77,8 @@ int ath10k_debug_create(struct ath10k *ar);
 void ath10k_debug_destroy(struct ath10k *ar);
 int ath10k_debug_register(struct ath10k *ar);
 void ath10k_debug_unregister(struct ath10k *ar);
+int ath10k_debug_register_netdev(struct ath10k_vif *arvif);
+void ath10k_debug_unregister_netdev(struct ath10k_vif *arvif);
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_debug_tpc_stats_process(struct ath10k *ar,
 				    struct ath10k_tpc_stats *tpc_stats);
@@ -134,6 +136,15 @@ static inline void ath10k_debug_unregister(struct ath10k *ar)
 {
 }
 
+static inline int ath10k_debug_register_netdev(struct ath10k_vif *arvif)
+{
+	return 0;
+}
+
+static inline void ath10k_debug_unregister_netdev(struct ath10k_vif *arvif)
+{
+}
+
 static inline void ath10k_debug_fw_stats_process(struct ath10k *ar,
 						 struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 938b8c303312ffaccc14c46cdabbb90e80077359..2bea5e8a6e42cacfa289f0e05052a822c591b05c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -152,6 +152,101 @@ u8 ath10k_mac_bitrate_to_idx(const struct ieee80211_supported_band *sband,
 	return 0;
 }
 
+int ath10k_mac_set_mcast_rate(struct ath10k_vif *arvif)
+{
+	const struct ieee80211_supported_band *sband;
+	struct ath10k *ar = arvif->ar;
+	struct cfg80211_chan_def def;
+	enum nl80211_band band;
+	u16 best_bitrate = 0;
+	u16 hw_value;
+	u32 ratemask;
+	u8 rate_code;
+	u8 preamble;
+	int i;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (ath10k_mac_vif_chan(arvif->vif, &def))
+		return -EPERM;
+
+	band = def.chan->band;
+	sband = ar->hw->wiphy->bands[band];
+	ratemask = arvif->bitrate_mask.control[band].legacy;
+
+	/* it seems that arvif is lost on every fw crash
+	 * read the lowest mcast read of bss
+	 */
+	if (!arvif->mcast_rate && arvif->vif->bss_conf.mcast_rate[band])
+		arvif->mcast_rate = sband->bitrates[arvif->vif->bss_conf.mcast_rate[band] - 1].bitrate;
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (!(ratemask & BIT(i)))
+			continue;
+
+		if (best_bitrate &&
+		    arvif->mcast_rate != sband->bitrates[i].bitrate)
+			continue;
+
+		best_bitrate = sband->bitrates[i].bitrate;
+		hw_value = sband->bitrates[i].hw_value;
+
+		if (ath10k_mac_bitrate_is_cck(sband->bitrates[i].bitrate)) {
+			preamble = WMI_RATE_PREAMBLE_CCK;
+
+			/* QCA didn't use the correct rate values for CA99x0
+			 * and above (ath10k_g_rates_rev2)
+			 */
+			switch (sband->bitrates[i].bitrate) {
+			case 10:
+				hw_value = ATH10K_HW_RATE_CCK_LP_1M;
+				break;
+			case 20:
+				hw_value = ATH10K_HW_RATE_CCK_LP_2M;
+				break;
+			case 55:
+				hw_value = ATH10K_HW_RATE_CCK_LP_5_5M;
+				break;
+			case 110:
+				hw_value = ATH10K_HW_RATE_CCK_LP_11M;
+				break;
+			}
+		} else {
+			preamble = WMI_RATE_PREAMBLE_OFDM;
+		}
+
+		rate_code = ATH10K_HW_RATECODE(hw_value, 0, preamble);
+	}
+
+	if (!best_bitrate) {
+		ath10k_warn(ar, "failed to select multicast rate\n");
+		return -EINVAL;
+	}
+
+	arvif->mcast_rate = best_bitrate;
+
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					ar->wmi.vdev_param->mgmt_rate,
+					rate_code);
+	if (ret)
+		ath10k_warn(ar, "failed to set mgmt fixed rate: %d\n",ret);
+
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					ar->wmi.vdev_param->bcast_data_rate,
+					rate_code);
+	if (ret)
+		ath10k_warn(ar, "failed to set bcast fixed rate: %d\n",ret);
+
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					ar->wmi.vdev_param->mcast_data_rate,
+					rate_code);
+	if (ret)
+		ath10k_warn(ar, "failed to set mcast fixed rate: %d\n",ret);
+
+	return 0;
+}
+
 static int ath10k_mac_get_max_vht_mcs_map(u16 mcs_map, int nss)
 {
 	switch ((mcs_map >> (2 * nss)) & 0x3) {
@@ -5133,6 +5228,9 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	spin_unlock_bh(&ar->htt.tx_lock);
 
 	mutex_unlock(&ar->conf_mutex);
+
+	ath10k_debug_register_netdev(arvif);
+
 	return 0;
 
 err_peer_delete:
@@ -5179,6 +5277,8 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	cancel_work_sync(&arvif->ap_csa_work);
 	cancel_delayed_work_sync(&arvif->connection_loss_work);
 
+	ath10k_debug_unregister_netdev(arvif);
+
 	mutex_lock(&ar->conf_mutex);
 
 	spin_lock_bh(&ar->data_lock);
@@ -5474,6 +5574,12 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				    arvif->vdev_id, ret);
 	}
 
+	/* TODO when should we actually call that */
+	ret = ath10k_mac_set_mcast_rate(arvif);
+	if (ret)
+		ath10k_warn(ar, "failed to set multicast rate params on vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -6958,6 +7064,13 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
+	ret = ath10k_mac_set_mcast_rate(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to set multicast rate params on vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		goto exit;
+	}
+
 exit:
 	mutex_unlock(&ar->conf_mutex);
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 1bd29ecfcdcc913ff8d3e447eb0d85c4d3c56ec2..db3966028c629b29bfeea3222597e8ba8d203556 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -69,6 +69,7 @@ u8 ath10k_mac_hw_rate_to_idx(const struct ieee80211_supported_band *sband,
 			     u8 hw_rate, bool cck);
 u8 ath10k_mac_bitrate_to_idx(const struct ieee80211_supported_band *sband,
 			     u32 bitrate);
+int ath10k_mac_set_mcast_rate(struct ath10k_vif *arvif);
 
 void ath10k_mac_tx_lock(struct ath10k *ar, int reason);
 void ath10k_mac_tx_unlock(struct ath10k *ar, int reason);

--nextPart2487861.YrrPN94Qg5--

--nextPart1958249.qQOIodAC0M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlrPEgIACgkQXYcKB8Em
e0YhGw//TiuOJWR1KiM4cjN47JofuKFFuaiMvaFWwSP1elhYnEQ2lqHafAczcBCa
6n0dL2AJcjedvkHqau2q2VkIq/MZrOhbm+ToGlkmJgqoo4i7To9gtskMUUZyKVRO
DtiGH6fU8DM+Ua5M306lTR+dqk20R2oGAN8nZqsoo7qlACjnxUg+9UwnXhSJxT87
MGJ92XlnX+4s7wKsZjtD6n6pQ+0YuprWiSEuHkK/cUAkgl/ivhnXKWTF3YBWFj1j
FXMArTnySO77H+ClSzyfnUo/yR1cXGAaR5Uyq5sSKbiuICwB5TT/Q2/JxNl+nN91
FE29jZBHiS1v7CSTwPjQG4SxkSt/xxBUEKmfPnE9FaYZvBUQDrZ8vHwjM3mPdHkX
4WcyH1dy/P7rS3/Gb91hy1UdAdrrdgNe71QWFgZ0nOAaFrloYDZQQe0itc8uFsSP
qqM6/RfeJC5lW4JsrY0R9nHrPC0jBSa/HKw7Rg/Ens0rW0jdDMy5ZipucadZcdig
IMGNy0DPfEtNlVUN1kCb3NslWQDq1kvK6U5vUVF7Uf81PLp7FAHRdXYiEk34WlM+
NRAiIVwcvEd9e4uHslM9wkaj6zWYSwAxbbr9G2Jxc35r2rLAgr3ZbCEtfVJ4R7ju
Y8CJ43J6qP6wfurlUuHEekWOMlH2HhT/KgVtO9TlVlQV8XEM83Q=
=Kj2b
-----END PGP SIGNATURE-----

--nextPart1958249.qQOIodAC0M--
