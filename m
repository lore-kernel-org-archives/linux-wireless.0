Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:36982 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933766AbcJUM5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:57:34 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 1/2] mac80211: fix some sphinx warnings
Date: Fri, 21 Oct 2016 15:57:23 +0300
Message-Id: <1477054644-5945-1-git-send-email-jani.nikula@intel.com> (sfid-20161021_145845_991568_8738A01A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 include/net/mac80211.h | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a810dfcb83c2..e2dba93e374f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -811,14 +811,18 @@ enum mac80211_rate_control_flags {
  * in the control information, and it will be filled by the rate
  * control algorithm according to what should be sent. For example,
  * if this array contains, in the format { <idx>, <count> } the
- * information
+ * information::
+ *
  *    { 3, 2 }, { 2, 2 }, { 1, 4 }, { -1, 0 }, { -1, 0 }
+ *
  * then this means that the frame should be transmitted
  * up to twice at rate 3, up to twice at rate 2, and up to four
  * times at rate 1 if it doesn't get acknowledged. Say it gets
  * acknowledged by the peer after the fifth attempt, the status
- * information should then contain
+ * information should then contain::
+ *
  *   { 3, 2 }, { 2, 2 }, { 1, 1 }, { -1, 0 } ...
+ *
  * since it was transmitted twice at rate 3, twice at rate 2
  * and once at rate 1 after which we received an acknowledgement.
  */
@@ -1168,8 +1172,8 @@ enum mac80211_rx_vht_flags {
  * @rate_idx: index of data rate into band's supported rates or MCS index if
  *	HT or VHT is used (%RX_FLAG_HT/%RX_FLAG_VHT)
  * @vht_nss: number of streams (VHT only)
- * @flag: %RX_FLAG_*
- * @vht_flag: %RX_VHT_FLAG_*
+ * @flag: %RX_FLAG_\*
+ * @vht_flag: %RX_VHT_FLAG_\*
  * @rx_flags: internal RX flags for mac80211
  * @ampdu_reference: A-MPDU reference number, must be a different value for
  *	each A-MPDU but the same for each subframe within one A-MPDU
@@ -1432,7 +1436,7 @@ enum ieee80211_vif_flags {
  * @probe_req_reg: probe requests should be reported to mac80211 for this
  *	interface.
  * @drv_priv: data area for driver use, will always be aligned to
- *	sizeof(void *).
+ *	sizeof(void \*).
  * @txq: the multicast data TX queue (if driver uses the TXQ abstraction)
  */
 struct ieee80211_vif {
@@ -1743,7 +1747,7 @@ struct ieee80211_sta_rates {
  * @wme: indicates whether the STA supports QoS/WME (if local devices does,
  *	otherwise always false)
  * @drv_priv: data area for driver use, will always be aligned to
- *	sizeof(void *), size is determined in hw information.
+ *	sizeof(void \*), size is determined in hw information.
  * @uapsd_queues: bitmap of queues configured for uapsd. Only valid
  *	if wme is supported.
  * @max_sp: max Service Period. Only valid if wme is supported.
@@ -2146,12 +2150,12 @@ enum ieee80211_hw_flags {
  *
  * @radiotap_mcs_details: lists which MCS information can the HW
  *	reports, by default it is set to _MCS, _GI and _BW but doesn't
- *	include _FMT. Use %IEEE80211_RADIOTAP_MCS_HAVE_* values, only
+ *	include _FMT. Use %IEEE80211_RADIOTAP_MCS_HAVE_\* values, only
  *	adding _BW is supported today.
  *
  * @radiotap_vht_details: lists which VHT MCS information the HW reports,
  *	the default is _GI | _BANDWIDTH.
- *	Use the %IEEE80211_RADIOTAP_VHT_KNOWN_* values.
+ *	Use the %IEEE80211_RADIOTAP_VHT_KNOWN_\* values.
  *
  * @radiotap_timestamp: Information for the radiotap timestamp field; if the
  *	'units_pos' member is set to a non-negative value it must be set to
@@ -2486,6 +2490,7 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * in the software stack cares about, we will, in the future, have mac80211
  * tell the driver which information elements are interesting in the sense
  * that we want to see changes in them. This will include
+ *
  *  - a list of information element IDs
  *  - a list of OUIs for the vendor information element
  *
-- 
2.1.4
