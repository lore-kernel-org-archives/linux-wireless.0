Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skprod2.natinst.com ([130.164.80.23]:52583 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753395AbbBXTCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 14:02:16 -0500
From: James Minor <james.minor@ni.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com,
	davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, xander.huff@ni.com, joshc@ni.com,
	joseph.hershberger@ni.com, ben.shelton@ni.com, jaeden.amero@ni.com,
	rich.tollerton@ni.com, brad.mouring@ni.com,
	James Minor <james.minor@ni.com>
Subject: [PATCH v3] wext: Return -E2BIG when the buffer is too small for the full scan results, including IEs.
Date: Tue, 24 Feb 2015 12:58:20 -0600
Message-Id: <1424804300-7469-1-git-send-email-james.minor@ni.com> (sfid-20150224_200220_079329_B164BBEE)
In-Reply-To: <1424707044.3075.14.camel@sipsolutions.net>
References: <1424707044.3075.14.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using the wext compatibility code in cfg80211, part of the IEs
can be truncated if the passed user buffer is large enough for the
BSS but not large enough for all of the IEs.  This can cause an EAP
network to show up as a PSK network.

These changes allow the scan to always return -E2BIG in that case.

Signed-off-by: James Minor <james.minor@ni.com>
---
 net/wireless/scan.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 76 insertions(+), 10 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 25e1e1f..dffeaca 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1239,15 +1239,25 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 }
 EXPORT_WEXT_HANDLER(cfg80211_wext_siwscan);
 
-static void ieee80211_scan_add_ies(struct iw_request_info *info,
-				   const struct cfg80211_bss_ies *ies,
-				   char **current_ev, char *end_buf)
+static inline void cfg80211_buf_full(char *prev_ev,
+				     char *current_ev,
+				     int *err)
+{
+	if (unlikely(prev_ev == current_ev))
+		*err = -E2BIG;
+}
+
+static int ieee80211_scan_add_ies(struct iw_request_info *info,
+				  const struct cfg80211_bss_ies *ies,
+				  char **current_ev, char *end_buf)
 {
 	const u8 *pos, *end, *next;
 	struct iw_event iwe;
+	char *prev_ev;
+	int err = 0;
 
 	if (!ies)
-		return;
+		return err;
 
 	/*
 	 * If needed, fragment the IEs buffer (at IE boundaries) into short
@@ -1264,10 +1274,11 @@ static void ieee80211_scan_add_ies(struct iw_request_info *info,
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = next - pos;
+		prev_ev = *current_ev;
 		*current_ev = iwe_stream_add_point(info, *current_ev,
 						   end_buf, &iwe,
 						   (void *)pos);
-
+		cfg80211_buf_full(prev_ev, *current_ev, &err);
 		pos = next;
 	}
 
@@ -1275,10 +1286,13 @@ static void ieee80211_scan_add_ies(struct iw_request_info *info,
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = end - pos;
+		prev_ev = *current_ev;
 		*current_ev = iwe_stream_add_point(info, *current_ev,
 						   end_buf, &iwe,
 						   (void *)pos);
+		cfg80211_buf_full(prev_ev, *current_ev, &err);
 	}
+	return err;
 }
 
 static char *
@@ -1292,27 +1306,36 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 	u8 *buf, *cfg, *p;
 	int rem, i, sig;
 	bool ismesh = false;
+	char *prev_ev;
+	char *orig_ev = current_ev;
+	int err = 0;
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWAP;
 	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
 	memcpy(iwe.u.ap_addr.sa_data, bss->pub.bssid, ETH_ALEN);
+	prev_ev = current_ev;
 	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
 					  IW_EV_ADDR_LEN);
+	cfg80211_buf_full(prev_ev, current_ev, &err);
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
 	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->pub.channel->center_freq);
 	iwe.u.freq.e = 0;
+	prev_ev = current_ev;
 	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
+	cfg80211_buf_full(prev_ev, current_ev, &err);
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
 	iwe.u.freq.m = bss->pub.channel->center_freq;
 	iwe.u.freq.e = 6;
+	prev_ev = current_ev;
 	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
+	cfg80211_buf_full(prev_ev, current_ev, &err);
 
 	if (wiphy->signal_type != CFG80211_SIGNAL_TYPE_NONE) {
 		memset(&iwe, 0, sizeof(iwe));
@@ -1341,8 +1364,10 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			/* not reached */
 			break;
 		}
+		prev_ev = current_ev;
 		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
 						  &iwe, IW_EV_QUAL_LEN);
+		cfg80211_buf_full(prev_ev, current_ev, &err);
 	}
 
 	memset(&iwe, 0, sizeof(iwe));
@@ -1352,8 +1377,10 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 	else
 		iwe.u.data.flags = IW_ENCODE_DISABLED;
 	iwe.u.data.length = 0;
+	prev_ev = current_ev;
 	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
 					  &iwe, "");
+	cfg80211_buf_full(prev_ev, current_ev, &err);
 
 	rcu_read_lock();
 	ies = rcu_dereference(bss->pub.ies);
@@ -1371,16 +1398,20 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			iwe.cmd = SIOCGIWESSID;
 			iwe.u.data.length = ie[1];
 			iwe.u.data.flags = 1;
+			prev_ev = current_ev;
 			current_ev = iwe_stream_add_point(info, current_ev, end_buf,
 							  &iwe, (u8 *)ie + 2);
+			cfg80211_buf_full(prev_ev, current_ev, &err);
 			break;
 		case WLAN_EID_MESH_ID:
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWESSID;
 			iwe.u.data.length = ie[1];
 			iwe.u.data.flags = 1;
+			prev_ev = current_ev;
 			current_ev = iwe_stream_add_point(info, current_ev, end_buf,
 							  &iwe, (u8 *)ie + 2);
+			cfg80211_buf_full(prev_ev, current_ev, &err);
 			break;
 		case WLAN_EID_MESH_CONFIG:
 			ismesh = true;
@@ -1395,41 +1426,55 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			sprintf(buf, "Mesh Network Path Selection Protocol ID: "
 				"0x%02X", cfg[0]);
 			iwe.u.data.length = strlen(buf);
+			prev_ev = current_ev;
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
+			cfg80211_buf_full(prev_ev, current_ev, &err);
 			sprintf(buf, "Path Selection Metric ID: 0x%02X",
 				cfg[1]);
 			iwe.u.data.length = strlen(buf);
+			prev_ev = current_ev;
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
+			cfg80211_buf_full(prev_ev, current_ev, &err);
 			sprintf(buf, "Congestion Control Mode ID: 0x%02X",
 				cfg[2]);
 			iwe.u.data.length = strlen(buf);
+			prev_ev = current_ev;
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
+			cfg80211_buf_full(prev_ev, current_ev, &err);
 			sprintf(buf, "Synchronization ID: 0x%02X", cfg[3]);
 			iwe.u.data.length = strlen(buf);
+			prev_ev = current_ev;
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
+			cfg80211_buf_full(prev_ev, current_ev, &err);
 			sprintf(buf, "Authentication ID: 0x%02X", cfg[4]);
 			iwe.u.data.length = strlen(buf);
+			prev_ev = current_ev;
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
+			cfg80211_buf_full(prev_ev, current_ev, &err);
 			sprintf(buf, "Formation Info: 0x%02X", cfg[5]);
 			iwe.u.data.length = strlen(buf);
+			prev_ev = current_ev;
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
+			cfg80211_buf_full(prev_ev, current_ev, &err);
 			sprintf(buf, "Capabilities: 0x%02X", cfg[6]);
 			iwe.u.data.length = strlen(buf);
+			prev_ev = current_ev;
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
+			cfg80211_buf_full(prev_ev, current_ev, &err);
 			kfree(buf);
 			break;
 		case WLAN_EID_SUPP_RATES:
@@ -1445,8 +1490,10 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			for (i = 0; i < ie[1]; i++) {
 				iwe.u.bitrate.value =
 					((ie[i + 2] & 0x7f) * 500000);
+				prev_ev = p;
 				p = iwe_stream_add_value(info, current_ev, p,
 						end_buf, &iwe, IW_EV_PARAM_LEN);
+				cfg80211_buf_full((u8 *) prev_ev, p, &err);
 			}
 			current_ev = p;
 			break;
@@ -1465,8 +1512,10 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			iwe.u.mode = IW_MODE_MASTER;
 		else
 			iwe.u.mode = IW_MODE_ADHOC;
+		prev_ev = current_ev;
 		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
 						  &iwe, IW_EV_UINT_LEN);
+		cfg80211_buf_full(prev_ev, current_ev, &err);
 	}
 
 	buf = kmalloc(31, GFP_ATOMIC);
@@ -1475,22 +1524,31 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 		iwe.cmd = IWEVCUSTOM;
 		sprintf(buf, "tsf=%016llx", (unsigned long long)(ies->tsf));
 		iwe.u.data.length = strlen(buf);
+		prev_ev = current_ev;
 		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
 						  &iwe, buf);
+		cfg80211_buf_full(prev_ev, current_ev, &err);
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVCUSTOM;
 		sprintf(buf, " Last beacon: %ums ago",
 			elapsed_jiffies_msecs(bss->ts));
 		iwe.u.data.length = strlen(buf);
+		prev_ev = current_ev;
 		current_ev = iwe_stream_add_point(info, current_ev,
 						  end_buf, &iwe, buf);
+		cfg80211_buf_full(prev_ev, current_ev, &err);
 		kfree(buf);
 	}
 
-	ieee80211_scan_add_ies(info, ies, &current_ev, end_buf);
+	if (!err)
+		err = ieee80211_scan_add_ies(info, ies, &current_ev, end_buf);
+
 	rcu_read_unlock();
 
-	return current_ev;
+	if (err)
+		return orig_ev;
+	else
+		return current_ev;
 }
 
 
@@ -1499,22 +1557,30 @@ static int ieee80211_scan_results(struct cfg80211_registered_device *rdev,
 				  char *buf, size_t len)
 {
 	char *current_ev = buf;
+	char *prev_ev;
 	char *end_buf = buf + len;
 	struct cfg80211_internal_bss *bss;
+	int err = 0;
 
 	spin_lock_bh(&rdev->bss_lock);
 	cfg80211_bss_expire(rdev);
 
 	list_for_each_entry(bss, &rdev->bss_list, list) {
 		if (buf + len - current_ev <= IW_EV_ADDR_LEN) {
-			spin_unlock_bh(&rdev->bss_lock);
-			return -E2BIG;
+			err = -E2BIG;
+			goto out_unlock;
 		}
+		prev_ev = current_ev;
 		current_ev = ieee80211_bss(&rdev->wiphy, info, bss,
 					   current_ev, end_buf);
+		cfg80211_buf_full(prev_ev, current_ev, &err);
 	}
+out_unlock:
 	spin_unlock_bh(&rdev->bss_lock);
-	return current_ev - buf;
+	if (err)
+		return err;
+	else
+		return current_ev - buf;
 }
 
 
-- 
1.9.1

