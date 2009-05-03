Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34635 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZECVqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2009 17:46:10 -0400
Received: by fxm2 with SMTP id 2so3348271fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 03 May 2009 14:46:09 -0700 (PDT)
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241374060.13562.37.camel@johannes.local>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
Content-Type: multipart/mixed; boundary="=-ZmuF6qpMMgWroQiB2dV5"
Date: Mon, 04 May 2009 00:46:03 +0300
Message-Id: <1241387163.10486.6.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZmuF6qpMMgWroQiB2dV5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2009-05-03 at 20:07 +0200, Johannes Berg wrote:
> On Sat, 2009-05-02 at 04:32 +0300, Maxim Levitsky wrote:
> 
> > > * iwlwifi.git - very close to current head, yesterday HEAD
> > > * disable_hw_scan=1 - this bug is present regardless of this setting,
> > > yet this rules out firmware interactions during rfkill.
> 
> Are you absolutely sure this also happens with disable_hw_scan=1? That
> seems rather strange. Can you please also put a printk into
> net/wireless/scan.c:cfg80211_scan_done, and provide separate logs w/ and
> w/o disable_hw_scan=1.
> 
> johannes

Yes, sure
For record I use iwlwifi.git commit
5a94b6d38100b7056a5a347e5c51359d924d305d


Logs attached.
This bug can be reliably reproduced, happens every 5~10 times when I
turn rfkill on/off, but today again this happened after resume from
disk.

Sorry for misleading MAC80211, I noticed that long ago, but this was for
debugging only.

Current diff attached too.




--=-ZmuF6qpMMgWroQiB2dV5
Content-Disposition: attachment; filename="scanlog"
Content-Type: text/plain; name="scanlog"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

maxim@maxim-laptop:~$ cat /sys/module/iwl3945/parameters/disable_hw_scan 
1

May  4 00:28:48 maxim-laptop kernel: [  495.686773] iwl3945 0000:06:00.0: Radio Frequency Kill Switch is On:
May  4 00:28:48 maxim-laptop kernel: [  495.686778] Kill switch must be turned off for wireless networking to work.
May  4 00:28:49 maxim-laptop kernel: [  496.376281] iwl3945 0000:06:00.0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
May  4 00:28:49 maxim-laptop kernel: [  496.440209] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
May  4 00:28:49 maxim-laptop kernel: [  496.440216] iwl3945 0000:06:00.0: Error clearing ASSOC_MSK on current configuration (-5).
May  4 00:28:49 maxim-laptop kernel: [  496.440226] wlan0: authenticate with AP 00:1b:9e:d8:77:02
May  4 00:28:49 maxim-laptop kernel: [  496.561097] cfg80211: scan requested
May  4 00:28:49 maxim-laptop kernel: [  496.561105] __ieee80211_start_scan: scan requested
May  4 00:28:49 maxim-laptop kernel: [  496.680161] wlan0: deauthenticating by local choice (reason=3)
May  4 00:28:56 maxim-laptop kernel: [  503.222373] Registered led device: iwl-phy0::radio
May  4 00:28:56 maxim-laptop kernel: [  503.222416] Registered led device: iwl-phy0::assoc
May  4 00:28:56 maxim-laptop kernel: [  503.222449] Registered led device: iwl-phy0::RX
May  4 00:28:56 maxim-laptop kernel: [  503.222483] Registered led device: iwl-phy0::TX
May  4 00:28:56 maxim-laptop kernel: [  503.300956] wlan0: direct probe to AP 00:21:63:76:b3:a4 try 1
May  4 00:28:56 maxim-laptop kernel: [  503.306274] wlan0 direct probe responded
May  4 00:28:56 maxim-laptop kernel: [  503.306282] wlan0: authenticate with AP 00:21:63:76:b3:a4
May  4 00:28:56 maxim-laptop kernel: [  503.309830] wlan0: authenticated
May  4 00:28:56 maxim-laptop kernel: [  503.309838] wlan0: associate with AP 00:21:63:76:b3:a4
May  4 00:28:56 maxim-laptop kernel: [  503.331597] wlan0: RX AssocResp from 00:21:63:76:b3:a4 (capab=0x401 status=0 aid=2)
May  4 00:28:56 maxim-laptop kernel: [  503.331604] wlan0: associated
May  4 00:28:56 maxim-laptop kernel: [  503.376487] wlan0: disassociating by local choice (reason=3)
May  4 00:28:56 maxim-laptop kernel: [  503.466026] wlan0: authenticate with AP 00:21:63:76:b3:a4
May  4 00:28:56 maxim-laptop kernel: [  503.466121] cfg80211: scan requested
May  4 00:28:56 maxim-laptop kernel: [  503.466126] cfg80211: can't scan, already scanning
May  4 00:28:56 maxim-laptop kernel: [  503.470264] wlan0: authenticated
May  4 00:28:56 maxim-laptop kernel: [  503.470271] wlan0: associate with AP 00:21:63:76:b3:a4
May  4 00:28:56 maxim-laptop kernel: [  503.471184] wlan0: authenticated
May  4 00:28:56 maxim-laptop kernel: [  503.471188] wlan0: associate with AP 00:21:63:76:b3:a4
May  4 00:29:17 maxim-laptop kernel: [  524.167149] cfg80211: scan requested
May  4 00:29:17 maxim-laptop kernel: [  524.167156] cfg80211: can't scan, already scanning



---------------------------------------------------------------------------------------------------------------------------------------------


maxim@maxim-laptop:~$ cat /sys/module/iwl3945/parameters/disable_hw_scan 
0


May  4 00:33:58 maxim-laptop kernel: [  805.657465] iwl3945 0000:06:00.0: Radio Frequency Kill Switch is On:
May  4 00:33:58 maxim-laptop kernel: [  805.657471] Kill switch must be turned off for wireless networking to work.
May  4 00:34:04 maxim-laptop kernel: [  811.173430] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
May  4 00:34:04 maxim-laptop kernel: [  811.173438] iwl3945 0000:06:00.0: Error setting new configuration (-5).
May  4 00:34:04 maxim-laptop kernel: [  811.173450] wlan0: direct probe to AP 00:21:63:4c:41:34 try 1
May  4 00:34:04 maxim-laptop kernel: [  811.252620] wlan0: deauthenticating by local choice (reason=3)
May  4 00:34:17 maxim-laptop kernel: [  824.212764] Registered led device: iwl-phy0::radio
May  4 00:34:17 maxim-laptop kernel: [  824.212845] Registered led device: iwl-phy0::assoc
May  4 00:34:17 maxim-laptop kernel: [  824.212879] Registered led device: iwl-phy0::RX
May  4 00:34:17 maxim-laptop kernel: [  824.212910] Registered led device: iwl-phy0::TX
May  4 00:34:17 maxim-laptop kernel: [  824.384165] wlan0: direct probe to AP 00:21:63:4c:41:34 try 1
May  4 00:34:17 maxim-laptop kernel: [  824.475392] cfg80211: scan requested
May  4 00:34:17 maxim-laptop kernel: [  824.475401] __ieee80211_start_scan: scan requested
May  4 00:34:17 maxim-laptop kernel: [  824.475627] cfg80211: scan requested
May  4 00:34:17 maxim-laptop kernel: [  824.475632] cfg80211: can't scan, already scanning
May  4 00:34:17 maxim-laptop kernel: [  824.582579] wlan0: direct probe to AP 00:21:63:4c:41:34 try 2
May  4 00:34:17 maxim-laptop kernel: [  824.586617] wlan0 direct probe responded
May  4 00:34:17 maxim-laptop kernel: [  824.586622] wlan0: authenticate with AP 00:21:63:4c:41:34
May  4 00:34:17 maxim-laptop kernel: [  824.590000] wlan0: authenticated
May  4 00:34:17 maxim-laptop kernel: [  824.590005] wlan0: associate with AP 00:21:63:4c:41:34
May  4 00:34:17 maxim-laptop kernel: [  824.592160] wlan0: RX AssocResp from 00:21:63:4c:41:34 (capab=0x401 status=0 aid=1)
May  4 00:34:17 maxim-laptop kernel: [  824.592165] wlan0: associated
May  4 00:34:17 maxim-laptop kernel: [  824.595337] wlan0: disassociating by local choice (reason=3)
May  4 00:34:17 maxim-laptop kernel: [  825.010593] __ieee80211_start_scan: scan requested
May  4 00:34:38 maxim-laptop kernel: [  845.170857] cfg80211: scan requested
May  4 00:34:38 maxim-laptop kernel: [  845.170865] cfg80211: can't scan, already scanning


--=-ZmuF6qpMMgWroQiB2dV5
Content-Disposition: attachment; filename="test_patch.diff"
Content-Type: text/x-patch; name="test_patch.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 127bd54..47969d5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -276,6 +276,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	struct ieee80211_sub_if_data *sdata;
 	bool was_hw_scan;
 
+	printk("ieee80211_scan_completed: aborted=%i\n", aborted);
 	mutex_lock(&local->scan_mtx);
 
 	if (WARN_ON(!local->hw_scanning && !local->sw_scanning)) {
@@ -354,6 +355,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
+	printk("ieee80211_scan_completed: exit\n");
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
@@ -424,8 +426,11 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	int rc;
 
-	if (local->scan_req)
+	printk("__ieee80211_start_scan: scan requested\n");
+	if (local->scan_req) {
+		printk("__ieee80211_start_scan: scan failed - busy\n");
 		return -EBUSY;
+	}
 
 	if (local->ops->hw_scan) {
 		u8 *ies;
@@ -491,6 +496,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		local->scan_sdata = NULL;
 	}
 
+	printk("__ieee80211_start_scan: scan requested OK\n");
 	return rc;
 }
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 10b4887..88602fe 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -23,6 +23,7 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 #ifdef CONFIG_WIRELESS_EXT
 	union iwreq_data wrqu;
 #endif
+	printk("cfg80211_scan_done: scan done. aborted=%d\n", aborted);
 
 	dev = dev_get_by_index(&init_net, request->ifidx);
 	if (!dev)
@@ -585,11 +586,14 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		return -ENETDOWN;
 
 	rdev = cfg80211_get_dev_from_ifindex(dev->ifindex);
+	
+	printk("cfg80211: scan requested\n");
 
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
 	if (rdev->scan_req) {
+		printk("cfg80211: can't scan, already scanning\n");
 		err = -EBUSY;
 		goto out;
 	}
@@ -644,6 +648,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	rdev->scan_req = creq;
 	err = rdev->ops->scan(wiphy, dev, creq);
 	if (err) {
+		printk("cfg80211: scan failed. error=%d\n", err);
 		rdev->scan_req = NULL;
 		kfree(creq);
 	}

--=-ZmuF6qpMMgWroQiB2dV5--

