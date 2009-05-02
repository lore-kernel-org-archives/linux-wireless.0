Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:61423 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZEBBcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 21:32:32 -0400
Received: by bwz7 with SMTP id 7so2564200bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 01 May 2009 18:32:30 -0700 (PDT)
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241208792.7082.47.camel@maxim-laptop>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
Content-Type: multipart/mixed; boundary="=-DBkDWJHn+3S6G0NvEFbA"
Date: Sat, 02 May 2009 04:32:26 +0300
Message-Id: <1241227946.5192.3.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DBkDWJHn+3S6G0NvEFbA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2009-05-01 at 23:13 +0300, Maxim Levitsky wrote:
> On Fri, 2009-05-01 at 08:58 -0700, reinette chatre wrote:
> > Maxim,
> > 
> > On Fri, 2009-05-01 at 05:00 -0700, Maxim Levitsky wrote:
> > > Don't know if this is new regression, or just exposed race condition,
> > > but currently using rfkill, and/or s2disk sometimes leaves the card in
> > > state in which it can't scan.
> > 
> > Could you please provide more details of this scenario? 
> 
> OK, lets focus on my current setup:
> 
> * iwlwifi.git - very close to current head, yesterday HEAD
> * disable_hw_scan=1 - this bug is present regardless of this setting,
> yet this rules out firmware interactions during rfkill.
> 
> * Network Manager - ubuntu 9.04 unmodified.
> * wpa_supplicant - close to git HEAD, with one local change:
>   It is known that on first attempt scans always fail, with same -EBUSY
>   iwlst scan shows 'Device is busy', supplicant complains about scan
> requested (ret=-1), ... When this happens supplicant waits for 10
> seconds, and I reduced that wait to 1 second.
> 
> 
> When this happens, I can't make the card scan, scans always fail, and I
> can only reload the module.
> 
> Best regards,
> 	Maxim Levitsky
> 


Meanwhile, here are results from debbuging:




> -5
> May  2 04:22:56 maxim-laptop kernel: [ 1174.672463] Registered led device: iwl-phy0::radio
> May  2 04:22:56 maxim-laptop kernel: [ 1174.672500] Registered led device: iwl-phy0::assoc
> May  2 04:22:56 maxim-laptop kernel: [ 1174.672538] Registered led device: iwl-phy0::RX
> May  2 04:22:56 maxim-laptop kernel: [ 1174.672570] Registered led device: iwl-phy0::TX
> May  2 04:22:56 maxim-laptop kernel: [ 1174.769294] wlan0: direct probe to AP 00:11:6b:29:b4:c0 try 1
> May  2 04:22:56 maxim-laptop kernel: [ 1174.858645] MAC80211: scan requested
> May  2 04:22:56 maxim-laptop kernel: [ 1174.858652] __ieee80211_start_scan: scan requested
> May  2 04:22:56 maxim-laptop kernel: [ 1174.859251] MAC80211: scan requested
> May  2 04:22:56 maxim-laptop kernel: [ 1174.859256] MAC80211: can't scan, already scanning
> May  2 04:22:56 maxim-laptop kernel: [ 1174.962564] wlan0: direct probe to AP 00:11:6b:29:b4:c0 try 2
> May  2 04:22:56 maxim-laptop kernel: [ 1175.170108] wlan0: direct probe to AP 00:11:6b:29:b4:c0 try 3
> May  2 04:22:56 maxim-laptop kernel: [ 1175.370109] wlan0: direct probe to AP 00:11:6b:29:b4:c0 timed out
> May  2 04:22:57 maxim-laptop kernel: [ 1175.859705] MAC80211: scan requested
> May  2 04:22:57 maxim-laptop kernel: [ 1175.859712] MAC80211: can't scan, already scanning
> May  2 04:22:57 maxim-laptop kernel: [ 1176.040128] __ieee80211_start_scan: scan requested
> May  2 04:22:57 maxim-laptop kernel: [ 1176.040137] __ieee80211_start_scan: scan requested OK
> May  2 04:22:58 maxim-laptop kernel: [ 1176.861043] MAC80211: scan requested
> May  2 04:22:58 maxim-laptop kernel: [ 1176.861050] MAC80211: can't scan, already scanning
> May  2 04:22:58 maxim-laptop kernel: [ 1177.109763] iwl3945 0000:06:00.0: Radio Frequency Kill Switch is On:
> May  2 04:22:58 maxim-laptop kernel: [ 1177.109768] Kill switch must be turned off for wireless networking to work.
> May  2 04:22:58 maxim-laptop kernel: [ 1177.200160] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:22:58 maxim-laptop kernel: [ 1177.200169] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:22:58 maxim-laptop kernel: [ 1177.200843] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:22:58 maxim-laptop kernel: [ 1177.200850] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:22:58 maxim-laptop kernel: [ 1177.200977] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:22:58 maxim-laptop kernel: [ 1177.200983] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:22:58 maxim-laptop kernel: [ 1177.200992] wlan0: authenticate with AP 00:1b:9e:d8:77:02
> May  2 04:22:58 maxim-laptop kernel: [ 1177.400130] wlan0: authenticate with AP 00:1b:9e:d8:77:02
> May  2 04:22:58 maxim-laptop kernel: [ 1177.590135] wlan0: authenticate with AP 00:1b:9e:d8:77:02
> May  2 04:22:59 maxim-laptop kernel: [ 1177.790135] wlan0: authentication with AP 00:1b:9e:d8:77:02 timed out
> May  2 04:23:02 maxim-laptop kernel: [ 1180.776565] __ieee80211_start_scan: scan requested
> May  2 04:23:02 maxim-laptop kernel: [ 1180.776576] __ieee80211_start_scan: scan requested OK
> May  2 04:23:02 maxim-laptop kernel: [ 1180.800169] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:02 maxim-laptop kernel: [ 1180.800178] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:02 maxim-laptop kernel: [ 1180.852615] wlan0: deauthenticating by local choice (reason=3)
> May  2 04:23:09 maxim-laptop kernel: [ 1187.692165] Registered led device: iwl-phy0::radio
> May  2 04:23:09 maxim-laptop kernel: [ 1187.692243] Registered led device: iwl-phy0::assoc
> May  2 04:23:09 maxim-laptop kernel: [ 1187.692277] Registered led device: iwl-phy0::RX
> May  2 04:23:09 maxim-laptop kernel: [ 1187.692309] Registered led device: iwl-phy0::TX
> May  2 04:23:09 maxim-laptop kernel: [ 1187.779065] wlan0: direct probe to AP 00:21:63:73:3e:cb try 1
> May  2 04:23:09 maxim-laptop kernel: [ 1187.866011] MAC80211: scan requested
> May  2 04:23:09 maxim-laptop kernel: [ 1187.866020] __ieee80211_start_scan: scan requested
> May  2 04:23:09 maxim-laptop kernel: [ 1187.866246] MAC80211: scan requested
> May  2 04:23:09 maxim-laptop kernel: [ 1187.866250] MAC80211: can't scan, already scanning
> May  2 04:23:09 maxim-laptop kernel: [ 1187.970132] wlan0: direct probe to AP 00:21:63:73:3e:cb try 2
> May  2 04:23:09 maxim-laptop kernel: [ 1187.975966] wlan0 direct probe responded
> May  2 04:23:09 maxim-laptop kernel: [ 1187.975972] wlan0: authenticate with AP 00:21:63:73:3e:cb
> May  2 04:23:09 maxim-laptop kernel: [ 1187.980907] wlan0: authenticated
> May  2 04:23:09 maxim-laptop kernel: [ 1187.980916] wlan0: associate with AP 00:21:63:73:3e:cb
> May  2 04:23:09 maxim-laptop kernel: [ 1187.985106] wlan0: RX AssocResp from 00:21:63:73:3e:cb (capab=0x1 status=0 aid=1)
> May  2 04:23:09 maxim-laptop kernel: [ 1187.985112] wlan0: associated
> May  2 04:23:09 maxim-laptop kernel: [ 1187.990358] wlan0: disassociating by local choice (reason=3)
> May  2 04:23:09 maxim-laptop kernel: [ 1188.012606] __ieee80211_start_scan: scan requested
> May  2 04:23:09 maxim-laptop kernel: [ 1188.012615] __ieee80211_start_scan: scan requested OK
> May  2 04:23:10 maxim-laptop kernel: [ 1189.164814] __ieee80211_start_scan: scan requested
> May  2 04:23:10 maxim-laptop kernel: [ 1189.164821] __ieee80211_start_scan: scan requested OK
> May  2 04:23:11 maxim-laptop kernel: [ 1190.314526] __ieee80211_start_scan: scan requested
> May  2 04:23:11 maxim-laptop kernel: [ 1190.314535] __ieee80211_start_scan: scan requested OK
> May  2 04:23:11 maxim-laptop kernel: [ 1190.598788] iwl3945 0000:06:00.0: Radio Frequency Kill Switch is On:
> May  2 04:23:11 maxim-laptop kernel: [ 1190.598793] Kill switch must be turned off for wireless networking to work.
> May  2 04:23:12 maxim-laptop kernel: [ 1190.640157] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:12 maxim-laptop kernel: [ 1190.640166] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:12 maxim-laptop kernel: [ 1190.700126] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:12 maxim-laptop kernel: [ 1190.700132] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:12 maxim-laptop kernel: [ 1190.760135] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:12 maxim-laptop kernel: [ 1190.760142] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:12 maxim-laptop kernel: [ 1190.820135] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:12 maxim-laptop kernel: [ 1190.820142] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:12 maxim-laptop kernel: [ 1190.880128] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:12 maxim-laptop kernel: [ 1190.880134] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:12 maxim-laptop kernel: [ 1190.940134] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:12 maxim-laptop kernel: [ 1190.940141] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:12 maxim-laptop kernel: [ 1191.000059] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:12 maxim-laptop kernel: [ 1191.000065] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:12 maxim-laptop kernel: [ 1191.230193] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:12 maxim-laptop kernel: [ 1191.230201] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:12 maxim-laptop kernel: [ 1191.460151] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:12 maxim-laptop kernel: [ 1191.460159] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:15 maxim-laptop kernel: [ 1193.634947] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:15 maxim-laptop kernel: [ 1193.634955] iwl3945 0000:06:00.0: Error setting new configuration (-5).
> May  2 04:23:15 maxim-laptop kernel: [ 1193.634966] wlan0: authenticate with AP 00:21:63:73:3e:cb
> May  2 04:23:15 maxim-laptop kernel: [ 1193.722617] wlan0: deauthenticating by local choice (reason=3)
> May  2 04:23:22 maxim-laptop kernel: [ 1200.672558] Registered led device: iwl-phy0::radio
> May  2 04:23:22 maxim-laptop kernel: [ 1200.672637] Registered led device: iwl-phy0::assoc
> May  2 04:23:22 maxim-laptop kernel: [ 1200.672672] Registered led device: iwl-phy0::RX
> May  2 04:23:22 maxim-laptop kernel: [ 1200.672703] Registered led device: iwl-phy0::TX
> May  2 04:23:22 maxim-laptop kernel: [ 1200.768734] wlan0: direct probe to AP 00:21:63:73:3e:cb try 1
> May  2 04:23:22 maxim-laptop kernel: [ 1200.848756] MAC80211: scan requested
> May  2 04:23:22 maxim-laptop kernel: [ 1200.848766] __ieee80211_start_scan: scan requested
> May  2 04:23:22 maxim-laptop kernel: [ 1200.962608] wlan0: direct probe to AP 00:21:63:73:3e:cb try 2
> May  2 04:23:22 maxim-laptop kernel: [ 1201.160120] wlan0: direct probe to AP 00:21:63:73:3e:cb try 3
> May  2 04:23:22 maxim-laptop kernel: [ 1201.163983] wlan0 direct probe responded
> May  2 04:23:22 maxim-laptop kernel: [ 1201.163989] wlan0: authenticate with AP 00:21:63:73:3e:cb
> May  2 04:23:22 maxim-laptop kernel: [ 1201.179940] wlan0: authenticated
> May  2 04:23:22 maxim-laptop kernel: [ 1201.179945] wlan0: associate with AP 00:21:63:73:3e:cb
> May  2 04:23:22 maxim-laptop kernel: [ 1201.183360] wlan0: RX AssocResp from 00:21:63:73:3e:cb (capab=0x1 status=0 aid=1)
> May  2 04:23:22 maxim-laptop kernel: [ 1201.183365] wlan0: associated
> May  2 04:23:22 maxim-laptop kernel: [ 1201.185992] __ieee80211_start_scan: scan requested
> May  2 04:23:22 maxim-laptop kernel: [ 1201.186060] __ieee80211_start_scan: scan requested OK
> May  2 04:23:22 maxim-laptop kernel: [ 1201.186645] wlan0: disassociating by local choice (reason=3)
> May  2 04:23:23 maxim-laptop kernel: [ 1202.334386] __ieee80211_start_scan: scan requested
> May  2 04:23:23 maxim-laptop kernel: [ 1202.334394] __ieee80211_start_scan: scan requested OK
> May  2 04:23:24 maxim-laptop kernel: [ 1203.484504] __ieee80211_start_scan: scan requested
> May  2 04:23:24 maxim-laptop kernel: [ 1203.484512] __ieee80211_start_scan: scan requested OK
> May  2 04:23:28 maxim-laptop kernel: [ 1207.338286] MAC80211: scan requested
> May  2 04:23:28 maxim-laptop kernel: [ 1207.338295] __ieee80211_start_scan: scan requested
> May  2 04:23:28 maxim-laptop kernel: [ 1207.338301] __ieee80211_start_scan: scan requested OK
> May  2 04:23:29 maxim-laptop kernel: [ 1208.489879] wlan0: authenticate with AP 00:1b:9e:d8:77:02
> May  2 04:23:29 maxim-laptop kernel: [ 1208.491881] wlan0: authenticated
> May  2 04:23:29 maxim-laptop kernel: [ 1208.491886] wlan0: associate with AP 00:1b:9e:d8:77:02
> May  2 04:23:29 maxim-laptop kernel: [ 1208.494566] wlan0: RX AssocResp from 00:1b:9e:d8:77:02 (capab=0x411 status=0 aid=2)
> May  2 04:23:29 maxim-laptop kernel: [ 1208.494572] wlan0: associated
> May  2 04:23:32 maxim-laptop kernel: [ 1211.353262] iwl3945 0000:06:00.0: Radio Frequency Kill Switch is On:
> May  2 04:23:32 maxim-laptop kernel: [ 1211.353266] Kill switch must be turned off for wireless networking to work.
> May  2 04:23:34 maxim-laptop kernel: [ 1212.852045] iwl3945 0000:06:00.0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
> May  2 04:23:34 maxim-laptop kernel: [ 1212.922732] iwl3945 0000:06:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
> May  2 04:23:34 maxim-laptop kernel: [ 1212.922740] iwl3945 0000:06:00.0: Error clearing ASSOC_MSK on current configuration (-5).
> May  2 04:23:34 maxim-laptop kernel: [ 1212.922751] wlan0: authenticate with AP 00:1b:9e:d8:77:02
> May  2 04:23:34 maxim-laptop kernel: [ 1213.033608] MAC80211: scan requested
> May  2 04:23:34 maxim-laptop kernel: [ 1213.033617] __ieee80211_start_scan: scan requested
> May  2 04:23:34 maxim-laptop kernel: [ 1213.122740] wlan0: deauthenticating by local choice (reason=3)
> May  2 04:23:41 maxim-laptop kernel: [ 1219.682401] Registered led device: iwl-phy0::radio
> May  2 04:23:41 maxim-laptop kernel: [ 1219.682479] Registered led device: iwl-phy0::assoc
> May  2 04:23:41 maxim-laptop kernel: [ 1219.683652] Registered led device: iwl-phy0::RX
> May  2 04:23:41 maxim-laptop kernel: [ 1219.683691] Registered led device: iwl-phy0::TX
> May  2 04:23:41 maxim-laptop kernel: [ 1219.776806] wlan0: direct probe to AP 00:21:63:73:3e:cb try 1
> May  2 04:23:41 maxim-laptop kernel: [ 1219.895887] MAC80211: scan requested
> May  2 04:23:41 maxim-laptop kernel: [ 1219.895893] MAC80211: can't scan, already scanning
> May  2 04:23:41 maxim-laptop kernel: [ 1219.970133] wlan0: direct probe to AP 00:21:63:73:3e:cb try 2
> May  2 04:23:41 maxim-laptop kernel: [ 1220.170110] wlan0: direct probe to AP 00:21:63:73:3e:cb try 3
> May  2 04:23:41 maxim-laptop kernel: [ 1220.370129] wlan0: direct probe to AP 00:21:63:73:3e:cb timed out
> May  2 04:24:02 maxim-laptop kernel: [ 1240.632072] MAC80211: scan requested
> May  2 04:24:02 maxim-laptop kernel: [ 1240.632079] MAC80211: can't scan, already scanning
> May  2 04:24:32 maxim-laptop kernel: [ 1270.630784] MAC80211: scan requested
> May  2 04:24:32 maxim-laptop kernel: [ 1270.630792] MAC80211: can't scan, already scanning
> May  2 04:25:12 maxim-laptop kernel: [ 1310.631028] MAC80211: scan requested
> May  2 04:25:12 maxim-laptop kernel: [ 1310.631035] MAC80211: can't scan, already scanning
> May  2 04:26:02 maxim-laptop kernel: [ 1360.632820] MAC80211: scan requested
> May  2 04:26:02 maxim-laptop kernel: [ 1360.632827] MAC80211: can't scan, already scanning
> May  2 04:27:02 maxim-laptop kernel: [ 1420.630846] MAC80211: scan requested
> May  2 04:27:02 maxim-laptop kernel: [ 1420.630853] MAC80211: can't scan, already scanning
> May  2 04:28:02 maxim-laptop kernel: [ 1480.632698] MAC80211: scan requested
> May  2 04:28:02 maxim-laptop kernel: [ 1480.632705] MAC80211: can't scan, already scanning
> 
> 

Debug patch that created those messages attached

As you see __ieee80211_start_scan never returns.


Best regards,
	Maxim Levitsky


--=-DBkDWJHn+3S6G0NvEFbA
Content-Disposition: attachment; filename="test_patch.diff"
Content-Type: text/x-patch; name="test_patch.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 127bd54..4f834fa 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -424,8 +424,11 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
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
@@ -491,6 +494,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		local->scan_sdata = NULL;
 	}
 
+	printk("__ieee80211_start_scan: scan requested OK\n");
 	return rc;
 }
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 10b4887..c309faa 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -585,11 +585,14 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		return -ENETDOWN;
 
 	rdev = cfg80211_get_dev_from_ifindex(dev->ifindex);
+	
+	printk("MAC80211: scan requested\n");
 
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
 	if (rdev->scan_req) {
+		printk("MAC80211: can't scan, already scanning\n");
 		err = -EBUSY;
 		goto out;
 	}
@@ -644,6 +647,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	rdev->scan_req = creq;
 	err = rdev->ops->scan(wiphy, dev, creq);
 	if (err) {
+		printk("MAC80211: scan failed. error=%d\n", err);
 		rdev->scan_req = NULL;
 		kfree(creq);
 	}

--=-DBkDWJHn+3S6G0NvEFbA--

