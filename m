Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:51191 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab3EBLfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 07:35:20 -0400
Received: from cpec03f0ed08c7f-cm001ac318e826.cpe.net.cable.rogers.com ([174.115.5.73]:54005 helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.80)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1UXrTm-0003yE-C2
	for linux-wireless@vger.kernel.org; Thu, 02 May 2013 07:15:14 -0400
Date: Thu, 2 May 2013 07:15:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] [KERNELDOC] Tweak kerneldoc content in *80211.h files.
Message-ID: <alpine.DEB.2.02.1305020713040.18190@oneiric> (sfid-20130502_133525_218173_293D37BB)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Make kerneldoc content match header file content, no functional
change.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

-- 

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26b5b69..159e070 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4153,6 +4153,7 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
  * cfg80211_crit_proto_stopped() - indicate critical protocol stopped by driver.
  *
  * @wdev: the wireless device for which critical protocol is stopped.
+ * @gfp: allocation flags
  *
  * This function can be called by the driver to indicate it has reverted
  * operation back to normal. One reason could be that the duration given
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 04c2d46..a68389c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1235,7 +1235,7 @@ enum ieee80211_sta_rx_bandwidth {
  * struct ieee80211_sta_rates - station rate selection table
  *
  * @rcu_head: RCU head used for freeing the table on update
- * @rates: transmit rates/flags to be used by default.
+ * @rate: transmit rates/flags to be used by default.
  *	Overriding entries per-packet is possible by using cb tx control.
  */
 struct ieee80211_sta_rates {
@@ -1276,7 +1276,7 @@ struct ieee80211_sta_rates {
  *	notifications and capabilities. The value is only valid after
  *	the station moves to associated state.
  * @smps_mode: current SMPS mode (off, static or dynamic)
- * @tx_rates: rate control selection table
+ * @rates: rate control selection table
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
