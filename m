Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab0IVI6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 04:58:32 -0400
Date: Wed, 22 Sep 2010 10:57:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force reset while
 doing scan
Message-ID: <20100922105722.3be42969@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Fri, 17 Sep 2010 14:24:17 -0700
Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> When uCode error condition detected, driver try to perform either
> rf reset or firmware reload in order bring device back to
> working condition.
> 
> If rf reset is required and scan is in process, there is no need
> to issue rf reset since scan already reset the rf.

Yes, and that is already handled by iwl_scan_initiate().

> If firmware reload is required and scan is in process, skip the
> reload request. There is a possibility firmware reload during
> scan cause problem.

If we skip restart request now, next will be scheduled lately (correct?,
I think there are firmware reset requests that are not repeatable). But we
still will have scan pending since firmware is in bad shape and will not
finish scan. So until scan_check delayed work (7s) will not finish scan,
will not be able to reset firmware. I do not think that is what we want.
I think patch is good for .36, but after my current scan patches, it is
not be needed and actually it should be reverted (see below).

> [  485.804046] WARNING: at net/mac80211/main.c:310 ieee80211_restart_hw+0x28/0x62()
> [  485.804049] Hardware name: Latitude E6400
> [  485.804052] ieee80211_restart_hw called with hardware scan in progress
> [  485.804054] Modules linked in: iwlagn iwlcore bnep sco rfcomm l2cap crc16 bluetooth [last unloaded: iwlcore]
> [  485.804069] Pid: 812, comm: kworker/u:3 Tainted: G        W   2.6.36-rc3-wl+ #74
> [  485.804072] Call Trace:
> [  485.804079]  [<c103019a>] warn_slowpath_common+0x60/0x75ieee80211_restart_hw
> [  485.804084]  [<c1030213>] warn_slowpath_fmt+0x26/0x2a
> [  485.804089]  [<c145da67>] ieee80211_restart_hw+0x28/0x62
> [  485.804102]  [<f8b35dc6>] iwl_bg_restart+0x113/0x150 [iwlagn]

In iwl_bg_restart() we cancel scan. First we try to send abort command
via __iwl_down() ->  iwl_scan_cancel_timeout() -> iwl_do_scan_abort().
If sending abort command fail we will complete scan in mac80211, otherwise
if firmware do not finish scan, we will complete scan in
iwl_cancel_deferred_work() -> iwl_cancel_scan_deferred_work(). Hence we should
be safe.

So why we can see this warning? During my testing I saw it also.
There is race regarding SCAN_HW_SCANNING bit, usually we set/clear
this bit under local->mtx, but not in ieee80211_restart_hw()

cpu0						cpu1
__ieee80211_start_scan
  __set_bit(SCAN_HW_SCANNING, &local->scanning);
  
						iwl_bg_restart()
						  ieee80211_restart_hw()
						    WARN
  
   drv_hw_scan
     iwl_mac_hw_scan
     (OK, fail new scan, return error)
   
   local->scanning = 0;

So nothing wrong will happen except printing a call trace. If we want fix that
I would suggest patch like this:

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7c85426..31993c3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -302,16 +302,20 @@ static void ieee80211_restart_work(struct work_struct *work)
 void ieee80211_restart_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	bool sw_scan = false;
 
 	trace_api_restart_hw(local);
 
 	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
 
+	mutex_lock(&local->mtx);
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 		"%s called with hardware scan in progress\n", __func__);
+	sw_scan = test_bit(SCAN_SW_SCANNING, &local->scanning);
+	mutex_unlock(&local->mtx);
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
+	if (unlikely(sw_scan))
 		ieee80211_scan_cancel(local);
 
 	/* use this reason, ieee80211_reconfig will unblock it */

Or just leave code as is, many (harmless) warning's can be printed when restarting
iwlwifi firmware.

Stanislaw
