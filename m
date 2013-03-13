Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:60278 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3CMPNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 11:13:05 -0400
Received: by mail-oa0-f42.google.com with SMTP id i18so1213190oag.15
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 08:13:04 -0700 (PDT)
Message-ID: <5140977D.2040403@lwfinger.net> (sfid-20130313_161309_486396_893C754F)
Date: Wed, 13 Mar 2013 10:13:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Patrik, Kluba" <pkluba@dension.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: bug: deadlock in rtl8192cu
References: <20130312163020.67f9532b.pkluba@dension.com> <513F5931.6040509@lwfinger.net> <20130313152505.7dc3466c.pkluba@dension.com>
In-Reply-To: <20130313152505.7dc3466c.pkluba@dension.com>
Content-Type: multipart/mixed;
 boundary="------------050106090902080105020203"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050106090902080105020203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/13/2013 09:25 AM, Patrik, Kluba wrote:
> On Tue, 12 Mar 2013 11:34:57 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>>
>> Please try it with
>>
>>      status = usb_control_msg(udev, pipe, request, reqtype, value,
>>                               index, pdata, len, USB_CTRL_SET_TIMEOUT);
>>
>> That symbol is set to 5000 (milliseconds).
>>
>> Let me know if that helps. I have not seen this problem on x86 or ppc
>> architecture. Perhaps these are fundamentally different than ARM.
>>
>> Larry
>>
>>
>
> Well, at least it avoids the deadlock, but the device is unusable until
> a power cycle has been done. Even scanning reports no results. All I
> can see after an ifconfig wlan0 down + ifconfig wlan0 up is:
>
> [   29.412736] rtl8192cu: MAC auto ON okay!
> [   29.979279] rtl8192cu: Tx queue select: 0x05
>
> rmmod + modprobe does not help also.
>
> I have turned on lock debugging in the hope of catching something, and
> a 'sleeping in invalid context' has turned up at a different place.
>
> [   35.821233] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x431 status=0 aid=9)
> [   35.852506] wlan0: associated
> [   37.857611] BUG: sleeping function called from invalid context at mm/dmapool.c:315
> [   37.857663] in_atomic(): 0, irqs_disabled(): 0, pid: 695, name: kworker/0:2
> [   37.857697] 3 locks held by kworker/0:2/695:
> [   37.857718]  #0:  (rtlpriv->cfg->name){.+.+..}, at: [<c013cd24>] process_one_work+0x1cc/0x3f8
> [   37.857810]  #1:  ((&(&rtlpriv->works.watchdog_wq)->work)){+.+...}, at: [<c013cd24>] process_one_work+0x1cc/0x3f8
> [   37.857884]  #2:  (rcu_read_lock){.+.+..}, at: [<bf0eac38>] rtl92c_dm_dynamic_txpower+0x1a0/0xfac [rtl8192c_common]
> [   37.857978] Backtrace:
> [   37.858039] [<c010fe28>] (dump_backtrace+0x0/0xfc) from [<c041b64c>] (dump_stack+0x18/0x1c)
> [   37.858070]  r7:0000013b r6:c04dd1e6 r5:00000000 r4:c6d5a000
> [   37.858153] [<c041b634>] (dump_stack+0x0/0x1c) from [<c012067c>] (__might_sleep+0x19c/0x1d4)
> [   37.858219] [<c01204e0>] (__might_sleep+0x0/0x1d4) from [<c01a0c5c>] (dma_pool_alloc+0x30/0x17c)
> [   37.858252]  r7:c6d08c80 r6:c6a39f00 r5:c671ee20 r4:00000000
> [   37.858351] [<c01a0c2c>] (dma_pool_alloc+0x0/0x17c) from [<c0334f04>] (td_alloc+0x1c/0x48)
> [   37.858405] [<c0334ee8>] (td_alloc+0x0/0x48) from [<c03352e0>] (ohci_urb_enqueue+0x11c/0x260)
> [   37.858620]  r4:00000000
> [   37.858700] [<c03351c4>] (ohci_urb_enqueue+0x0/0x260) from [<c03205f8>] (usb_hcd_submit_urb+0xac/0x138)
> [   37.858751] [<c032054c>] (usb_hcd_submit_urb+0x0/0x138) from [<c0321030>] (usb_submit_urb+0x2b0/0x2cc)
> [   37.858783]  r9:c6cbe000 r8:c6d5bd1c r7:00000010 r6:00000000 r5:c6cbe000
> [   37.858839] r4:c6cbe038
> [   37.858879] [<c0320d80>] (usb_submit_urb+0x0/0x2cc) from [<c0322264>] (usb_start_wait_urb+0x54/0xdc)
> [   37.858908]  r7:00001388 r6:c6d08c80 r5:00000000 r4:c6d5bcb4
> [   37.858978] [<c0322210>] (usb_start_wait_urb+0x0/0xdc) from [<c032247c>] (usb_internal_control_msg+0x6c/0x80)
> [   37.859009]  r8:000000c0 r7:80000480 r6:c6cbe000 r5:c6059820 r4:c671ef20
> [   37.859090] [<c0322410>] (usb_internal_control_msg+0x0/0x80) from [<c032252c>] (usb_control_msg+0x9c/0xb8)
> [   37.859118]  r7:00000000 r6:00000444 r5:00000004 r4:c671ef20
> [   37.859218] [<c0322490>] (usb_control_msg+0x0/0xb8) from [<bf0ff240>] (_usb_writeN_sync+0xfc/0x200 [rtlwifi])
> [   37.859290] [<bf0ff1d4>] (_usb_writeN_sync+0x90/0x200 [rtlwifi]) from [<bf0ff334>] (_usb_writeN_sync+0x1f0/0x200 [rtlwifi])
> [   37.859359] [<bf0ff2b0>] (_usb_writeN_sync+0x16c/0x200 [rtlwifi]) from [<bf0ff358>] (_usb_read32_sync+0x14/0x18 [rtlwifi])
> [   37.859391]  r8:c6088d40 r7:00001f05 r6:00000000 r5:00000000 r4:c608a160
> [   37.859608] [<bf0ff344>] (_usb_read32_sync+0x0/0x18 [rtlwifi]) from [<bf116098>] (rtl92cu_update_hal_rate_table+0x158/0x17c [rtl8192cu])
> [   37.859684] [<bf115f40>] (rtl92cu_update_hal_rate_table+0x0/0x17c [rtl8192cu]) from [<bf0eac98>] (rtl92c_dm_dynamic_txpower+0x200/0xfac [rtl8192c_common])
> [   37.859720]  r7:00001f05 r6:c608a160 r5:00000001 r4:00000000
> [   37.859802] [<bf0eab84>] (rtl92c_dm_dynamic_txpower+0xec/0xfac [rtl8192c_common]) from [<bf0ebb20>] (rtl92c_dm_watchdog+0xc8/0x708 [rtl8192c_common])
> [   37.859869] [<bf0eba58>] (rtl92c_dm_watchdog+0x0/0x708 [rtl8192c_common]) from [<bf0f7334>] (rtl_watchdog_wq_callback+0x2ac/0x2f0 [rtlwifi])
> [   37.859902]  r6:c608c51c r5:00000020 r4:c608c4e0
> [   37.859982] [<bf0f7088>] (rtl_watchdog_wq_callback+0x0/0x2f0 [rtlwifi]) from [<c013cda8>] (process_one_work+0x250/0x3f8)
> [   37.860033] [<c013cb58>] (process_one_work+0x0/0x3f8) from [<c013d36c>] (worker_thread+0x148/0x23c)
> [   37.860090] [<c013d224>] (worker_thread+0x0/0x23c) from [<c0142c78>] (kthread+0x98/0xa4)
> [   37.860141] [<c0142be0>] (kthread+0x0/0xa4) from [<c012a0a0>] (do_exit+0x0/0x2cc)
> [   37.860168]  r7:00000013 r6:c012a0a0 r5:c0142be0 r4:c7881e78
>
> If I have tracked it down correctly, the problem is with the following
> segment from rtl92c_dm_refresh_rate_adaptive_mask():
>
>      rcu_read_lock();
>      sta = ieee80211_find_sta(mac->vif, mac->bssid);
>      rtlpriv->cfg->ops->update_rate_tbl(hw, sta, p_ra->ratr_state);
>      p_ra->pre_ratr_state = p_ra->ratr_state;
>      rcu_read_unlock();
>
> (again from compat-wireless-02-22, but wireless-next has the same)
>
> According to http://lwn.net/Articles/37889/ no sleeping functions
> should be called inside an rcu_read_lock() region. No sleeping can
> not be guaranteed for USB transfers.
> The comment for ieee80211_find_sta() says that the returned pointer
> is only valid under RCU lock, which leads to an interesting situation.

I think that is the problem that was fixed in wireless-testing commit 
664899786cb4. In that case, we got a scheduling while atomic when the debug 
level was 3 or higher. Check routine rtl92cu_update_hal_rate_table() to see in 
the following statement is the last one in that routine.

        RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, "%x\n",
                rtl_read_dword(rtlpriv, REG_ARFR0));

The patch in question removed that RT_TRACE statement.

Yesterday, Jussi Kivilinna and I found a problem that prevented rtl8192cu from 
reconnecting once it disconnected. That patch is attached.

Larry


--------------050106090902080105020203
Content-Type: text/x-patch;
 name="01-rtl8192cu_set_network_type_with_new_set_check_bssid.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="01-rtl8192cu_set_network_type_with_new_set_check_bssid.patch"

The driver was failing to clear the BSSID when a disconnect happened. That
prevented a reconnection. This problem is reported at
https://bugzilla.redhat.com/show_bug.cgi?id=789605,
https://bugzilla.redhat.com/show_bug.cgi?id=866786,
https://bugzilla.redhat.com/show_bug.cgi?id=906734, and
https://bugzilla.kernel.org/show_bug.cgi?id=46171.

Thanks to Jussi Kivilinna for making the critical observation
that led to the solution.

Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Tested-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

John,

As you can see by the number of bug reports, this patch should be
pushed as soon as possible.

Thanks,

Larry
---

 base.h         |    3 +
 pci.c          |    2 -
 rtl8192cu/hw.c |   87 ++++++++++++++++++++++-----------------------------------
 3 files changed, 39 insertions(+), 53 deletions(-)

Index: linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1377,74 +1377,57 @@ void rtl92cu_card_disable(struct ieee802
 
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
-	/* dummy routine needed for callback from rtl_op_configure_filter() */
-}
-
-/*========================================================================== */
-
-static void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
-			      enum nl80211_iftype type)
-{
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	u8 filterout_non_associated_bssid = false;
+	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
 
-	switch (type) {
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_STATION:
-		filterout_non_associated_bssid = true;
-		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_AP:
-	default:
-		break;
-	}
-	if (filterout_non_associated_bssid) {
+	if (rtlpriv->psc.rfpwr_state != ERFON)
+		return;
+
+	if (check_bssid) {
+		u8 tmp;
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
-			switch (rtlphy->current_io_type) {
-			case IO_CMD_RESUME_DM_BY_SCAN:
-				reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
-				rtlpriv->cfg->ops->set_hw_reg(hw,
-						 HW_VAR_RCR, (u8 *)(&reg_rcr));
-				/* enable update TSF */
-				_rtl92cu_set_bcn_ctrl_reg(hw, 0, BIT(4));
-				break;
-			case IO_CMD_PAUSE_DM_BY_SCAN:
-				reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
-				rtlpriv->cfg->ops->set_hw_reg(hw,
-						 HW_VAR_RCR, (u8 *)(&reg_rcr));
-				/* disable update TSF */
-				_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
-				break;
-			}
+			reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+			tmp = BIT(4);
 		} else {
-			reg_rcr |= (RCR_CBSSID);
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, 0, (BIT(4)|BIT(5)));
+			reg_rcr |= RCR_CBSSID;
+			tmp = BIT(4) | BIT(5);
 		}
-	} else if (filterout_non_associated_bssid == false) {
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
+					      (u8 *) (&reg_rcr));
+		_rtl92cu_set_bcn_ctrl_reg(hw, 0, tmp);
+	} else {
+		u8 tmp;
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
-			reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
+			reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+			tmp = BIT(4);
 		} else {
-			reg_rcr &= (~RCR_CBSSID);
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, (BIT(4)|BIT(5)), 0);
+			reg_rcr &= ~RCR_CBSSID;
+			tmp = BIT(4) | BIT(5);
 		}
+		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
+		rtlpriv->cfg->ops->set_hw_reg(hw,
+					      HW_VAR_RCR, (u8 *) (&reg_rcr));
+		_rtl92cu_set_bcn_ctrl_reg(hw, tmp, 0);
 	}
 }
 
+/*========================================================================== */
+
 int rtl92cu_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	if (_rtl92cu_set_media_status(hw, type))
 		return -EOPNOTSUPP;
-	_rtl92cu_set_check_bssid(hw, type);
+
+	if (rtlpriv->mac80211.link_state == MAC80211_LINKED) {
+		if (type != NL80211_IFTYPE_AP)
+			rtl92cu_set_check_bssid(hw, true);
+	} else {
+		rtl92cu_set_check_bssid(hw, false);
+	}
+
 	return 0;
 }
 
Index: linux-2.6/drivers/net/wireless/rtlwifi/base.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/base.h
+++ linux-2.6/drivers/net/wireless/rtlwifi/base.h
@@ -143,5 +143,8 @@ extern struct attribute_group rtl_attrib
 int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 			 bool isht, u8 desc_rate, bool first_ampdu);
 bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
+struct sk_buff *rtl_make_del_ba(struct ieee80211_hw *hw,
+				u8 *sa, u8 *bssid, u16 tid);
+void rtl_lps_change_work_callback(struct work_struct *work);
 
 #endif
Index: linux-2.6/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/pci.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/pci.c
@@ -939,7 +939,7 @@ static void _rtl_pci_prepare_bcn_tasklet
 	return;
 }
 
-static void rtl_lps_leave_work_callback(struct work_struct *work)
+void rtl_lps_leave_work_callback(struct work_struct *work)
 {
 	struct rtl_works *rtlworks =
 	    container_of(work, struct rtl_works, lps_leave_work);

--------------050106090902080105020203--
