Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.watchguard.com ([206.191.171.101]:59289 "EHLO
	watchguard.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161128Ab2KWKaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 05:30:24 -0500
From: Felix Liao <Felix.Liao@watchguard.com>
To: "johannes.berg@intel.com" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Ocean Su <Ocean.Su@watchguard.com>,
	Joe Qiao <Joe.Qiao@watchguard.com>,
	Bryan Phillippe <Bryan.Phillippe@watchguard.com>
Subject: Badness at net/mac80211/offchannel.c:264
Date: Fri, 23 Nov 2012 10:14:12 +0000
Message-ID: <1AA9BD91549CF94C901B05C32D2B081101E00C99@ES02Ch.wgti.net> (sfid-20121123_113037_122856_FE2675E8)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannesh,

I'm Felix Liao from WatchGuard, we encountered a warning call trace when update the compat-wireless driver to the latest stable version 3.6.6-1, but it always dump the call trace at line 264 of offchannel.c:
[   82.205559] ------------[ cut here ]------------
[   82.210188] Badness at /opt/compat-wireless-3.6.6-1/net/mac80211/offchannel.c:264
[   82.210203] NIP: e69df0c0 LR: e69df298 CTR: 00000001
[   82.210215] REGS: d9761c30 TRAP: 0700   Tainted: P             (2.6.35.12)
[   82.210225] MSR: 00029000 <EE,ME,CE>  CR: 20222484  XER: 20000000
[   82.210248] TASK = d972cdb0[1578] 'hostapd' THREAD: d9760000
[   82.210257] GPR00: 00000001 d9761ce0 d972cdb0 d95b0a80 00007b2a ffffffff d9761c3e 00007b29 
[   82.210280] GPR08: 00007af0 d95b1358 00000039 00000000 80222484 100885c4 00000000 10059568 
[   82.210304] GPR16: 00000000 00000000 00000000 10081334 df9f7500 e6a12ad0 e6a12a20 00000001 
[   82.210327] GPR24: d95b1358 d95b1358 dfb83300 d95b1148 d95b1358 d9737480 d95b0a80 d9737480 
[   82.210429] NIP [e69df0c0] ieee80211_start_next_roc+0x38/0x198 [mac80211]
[   82.210462] LR [e69df298] ieee80211_roc_purge+0x78/0x248 [mac80211]
[   82.210471] Call Trace:
[   82.210591] [d9761ce0] [00000001] 0x1 (unreliable)
[   82.210632] [d9761d00] [e69df298] ieee80211_roc_purge+0x78/0x248 [mac80211]
[   82.210672] [d9761d50] [e69e5cd0] ieee80211_do_stop+0xb8/0x60c [mac80211]
[   82.210708] [d9761d80] [e69e623c] ieee80211_stop+0x18/0x2c [mac80211]
[   82.210734] [d9761d90] [c02d8ec4] __dev_close+0x8c/0xe0
[   82.210752] [d9761db0] [c02d5b24] __dev_change_flags+0x138/0x190
[   82.210768] [d9761dd0] [c02d8ca4] dev_change_flags+0x24/0x74
[   82.210785] [d9761df0] [c0338480] devinet_ioctl+0x7a0/0x8e8
[   82.210801] [d9761e60] [c0339d58] inet_ioctl+0xcc/0xf8
[   82.210818] [d9761e70] [c02c39f8] sock_ioctl+0x7c/0x330
[   82.210842] [d9761e90] [c00c3bb8] vfs_ioctl+0x34/0x8c
[   82.210858] [d9761ea0] [c00c3ddc] do_vfs_ioctl+0x94/0x7e0
[   82.210874] [d9761f10] [c00c4578] sys_ioctl+0x50/0x94
[   82.210895] [d9761f40] [c0010e78] ret_from_syscall+0x0/0x3c
[   82.210933] --- Exception: c01 at 0xfbfaaf4
[   82.210938]     LR = 0xfc85bcc
[   82.210945] Instruction dump:
[   82.210954] 7c691b78 93c10018 7c7e1b78 90010024 9361000c 93810010 93a10014 93e1001c 
[   82.210980] 87e908d8 7f9f4800 419e0060 881f0048 <0f000000> 2f800000 409e002c 81230058

the device is running as AP and the driver I used is ath9k, that is, the local->ops->remain_on_channel is null to use, besides, one important point is I use the ACS(http://linuxwireless.org/en/users/Documentation/acs) patch in the hostapd.

One feature of this issue is it only happens when hostapd start, but in the hostapd running time, it doesn't happen again(yes, I replace the WARN_ON_ONCE with WARN_ON in line 264 to get this result). Another feature is after I disable the ACS function, this issue doesn't happen again.

Let me present the process in my mind,  when I start hostapd in the shell, it begin to run the ACS functions, which will send the REMAIN_ON_CHANNEL command(see hostapd_drv_remain_on_channel in hostapd source) to cfg80211, and then will call the function ieee80211_remain_on_channel() in mac80211, which will call the function ieee80211_start_roc_work(), which will queue some works ieee80211_sw_roc_work() on the local->workqueue. The work duration 60 is set by hostapd_config_acs_defaults() provided by ACS patch.

But on the other side, the hostapd also send SIOCSIFFLAGS command(see linux_set_iface_flags in hostapd source) to net core device, which will call the function dev_change_flags() to close the device, the call trace is dev_change_flags->ieee80211_stop->ieee80211_do_stop->ieee80211_roc_purge.

I verify that the roc->started was set to true in ieee80211_sw_roc_work:368, the value of roc->started change road is(hostapd and phy0 are gived by current->comm):

hostapd->ieee80211_start_roc_work[2146] local->roc_list: <empty>
hostapd->ieee80211_start_roc_work[2300] local->roc_list: <1>
    roc d90e7480 started 0 abrt 0 hw_beg 0 notified 0 hw_start 0 dur 60(60)
phy0->ieee80211_sw_roc_work[333] local->roc_list: <1>
    roc d90e7480 started 0 abrt 0 hw_beg 0 notified 0 hw_start 0 dur 60(60)
phy0->ieee80211_sw_roc_work[392] local->roc_list: <1>
    roc d90e7480 started 1 abrt 0 hw_beg 0 notified 1 hw_start 0 dur 60(60)
hostapd->ieee80211_roc_purge[465] local->roc_list: <1>
    roc d90e7480 started 1 abrt 0 hw_beg 0 notified 1 hw_start 0 dur 60(60)
hostapd->ieee80211_start_next_roc[264] roc d90e7480 cause call trace!
hostapd->ieee80211_roc_purge[480] local->roc_list: <1>
    roc d90e7480 started 1 abrt 0 hw_beg 0 notified 1 hw_start 0 dur 60(60)

I suspect the root cause of this issue is after ieee80211_sw_roc_work set roc->start to true and queue it again, the hostapd just call linux_set_iface_flags right now.  I just increase the delay time to magnify the probability of this issue, then it is more easier to reproduce this issue. So I think we should schedule the work as soon as possible, and should set the delay time to zero, that is,

--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -367,7 +367,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 
                roc->started = true;
-               ieee80211_queue_delayed_work(&local->hw, &roc->work,
-                                            msecs_to_jiffies(roc->duration));
+               ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);
        } else {
                /* finish this ROC */
  finish:

this issue is hardly to reproduce with this fix, but since ieee80211_roc_purge() and ieee80211_sw_roc_work are asynchronous, it still happen sometimes. So I take a try to delete the roc from list after queue to avoid the others access it by list, this change requires some other fix, 

At last, to be save I think we should use a static tmp_list or a global tmp_list to save the abort roc in ieee80211_roc_purge.

--------------
the complete patch to fix this issue as below:

$ git diff
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 83608ac..0a9bb58 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -336,14 +336,6 @@ void ieee80211_sw_roc_work(struct work_struct *work)
        if (roc->abort)
                goto finish;
 
-       if (WARN_ON(list_empty(&local->roc_list)))
-               goto out_unlock;
-
-       if (WARN_ON(roc != list_first_entry(&local->roc_list,
-                                           struct ieee80211_roc_work,
-                                           list)))
-               goto out_unlock;
-
        if (!roc->started) {
                struct ieee80211_roc_work *dep;
 
@@ -361,17 +353,18 @@ void ieee80211_sw_roc_work(struct work_struct *work)
                list_for_each_entry(dep, &roc->dependents, list)
                        ieee80211_handle_roc_started(dep);
 
+               list_del(&roc->list); /* delete from the local->roc_list */
                /* if it was pure TX, just finish right away */
                if (!roc->duration)
                        goto finish;
 
                roc->started = true;
-               ieee80211_queue_delayed_work(&local->hw, &roc->work,
-                                            msecs_to_jiffies(roc->duration));
+               ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);
        } else {
                /* finish this ROC */
  finish:
-               list_del(&roc->list);
+               if (roc->abort)
+                       list_del(&roc->list); /* delete from the tmp_list */
                started = roc->started;
                ieee80211_roc_notify_destroy(roc);
 
@@ -443,7 +436,7 @@ void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata)
 {
        struct ieee80211_local *local = sdata->local;
        struct ieee80211_roc_work *roc, *tmp;
-       LIST_HEAD(tmp_list);
+       static LIST_HEAD(tmp_list);
 
        mutex_lock(&local->mtx);
        list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {

--------------
I had test this patch using the same testcase above 10 times, it runs very well and never dump the warning calltrace, can you give a review for this patch? If ok, how can I submit this patch into the repository?

Thanks,
- Felix

