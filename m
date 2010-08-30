Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49609 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0H3HdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 03:33:24 -0400
Received: by iwn5 with SMTP id 5so4684251iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 00:33:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinzeS=2rc5YYpOcQ6L6CoDN4jq2--zKS=NfDbEv@mail.gmail.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
 <1282979590-31113-3-git-send-email-lrodriguez@atheros.com> <AANLkTinzeS=2rc5YYpOcQ6L6CoDN4jq2--zKS=NfDbEv@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 30 Aug 2010 00:29:43 -0700
Message-ID: <AANLkTi=o_tG2RK8Ced=VO-AaWXwB=bDu6-3iVY8_jWVi@mail.gmail.com>
Subject: Re: [RFC 2/3] mac80211: allow drivers to specify sw scan wait constraints
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, amod.bodas@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 29, 2010 at 12:55 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Sat, Aug 28, 2010 at 12:13 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>
>> @@ -520,23 +521,38 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
>>                /*
>>                 * we're on the operating channel currently, let's
>>                 * leave that channel now to scan another one
>> +                * unless the driver has other wait time constraints
>>                 */
>> -               local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
>> +               if (drv_sw_scan_wait_constraints(local) &&
>> +                   local->scan_oper_chan_waits < 2) {
>> +                       local->next_scan_state = SCAN_DECISION;
>> +                       local->scan_oper_chan_waits++;
>> +               } else {
>> +                       local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
>> +                       local->scan_oper_chan_waits = 0;
>> +               }
>>        }
>>
>> -       *next_delay = 0;
>> +       if (local->next_scan_state == SCAN_DECISION)
>> +               *next_delay = HZ / 5;
>
> This needs some good review as well. As its implemented here we'll
> essentially stop all TX except null data frames and probe requests as
> local->scanning is set by SCAN_SW_SCANNING through
> __ieee80211_start_scan(). One possible alternative is to do the
> drv_sw_scan_wait_constraints() check prior to calling the sw scan and
> fail the __ieee80211_start_scan() call if we need to wait. I didn't
> think this was the best thing to do at first though because the user
> will just get a scan busy error from userspace. It seemed more
> rational to queue the request in since we just have to wait until the
> driver clears its wait constraints -- or we wait too long (just a loop
> counter now on the operating channel).

After some testing I notice that these are actually very rare if
called prior to scan. If you think about it it makes sense, there are
only several wait constraints that ath9k would use. The nullfunc wait
that is not yet handled in mac80211 is from the off channel operation,
but that can eventually be handled internally within mac80211 as well.
There are other things though that are a bit more rare, like the
beacon synch requirement which would happen when our TSF gets off
track from the AP's. It seems reasonable to let drivers notify
mac80211 about these and let mac80211 do the work. This is a lot of
work though and I would prefer to start out knocking one wait
constraint at a time. Since the wait constraints are rare at least for
ath9k prior to starting a scan then it seems reasonable to me to at
least skip the userspace requested scan if we have wait constraints.
Later I think though our goal should be to WARN_ON() the wait
constraints prior to initiating the scan as all wait constraints would
ideally be handled within mac80211.

>> @@ -544,8 +560,26 @@ static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *loca
>>        else
>>                *next_delay = HZ / 10;
>>
>> +       /*
>> +        * If we're not getting ACKs for our nullfuncs we're likely in bad
>> +        * shape so we should not care about missed data as we can't even
>> +        * hear the AP. We want to help roam away if we can so just go
>> +        * ahead and scan. Try getting the ACK just 3 times.
>> +        */
>> +       r = drv_sw_scan_wait_constraints(local);
>> +       if (r == -EAGAIN) {
>> +               local->scan_nullfunc_retries++;
>> +               *next_delay = HZ / 10;
>
> After some review I believe we need to set here
> local->offchannel_ps_enabled otherwise we won't resend the nullfunc.
> Also we may want to reconsider the amount of time we wait for a resend
> as in that duration we will be only letting through nullfuncs and
> probe requests.

Tested this and think its the right thing to do. I'm now toying with
something like this:

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b50e4b5..77d7539 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -322,6 +322,12 @@ enum ieee80211_sta_flags {
        IEEE80211_STA_RESET_SIGNAL_AVE  = BIT(9),
 };

+enum ieee80211_nullfunc_type {
+       IEEE80211_NULLFUNC_DYN_PS       = BIT(0),
+       IEEE80211_NULLFUNC_OFFCHAN      = BIT(1),
+       IEEE80211_NULLFUNC_PRIVATE      = BIT(2),
+};
+
 struct ieee80211_if_managed {
        struct timer_list timer;
        struct timer_list conn_mon_timer;
@@ -350,6 +356,7 @@ struct ieee80211_if_managed {
        struct work_struct request_smps_work;

        unsigned int flags;
+       enum ieee80211_nullfunc_type nullfunc_type;

        u32 beacon_crc;

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5282ac1..ba4a622 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2181,6 +2181,7 @@ int ieee80211_mgd_assoc(struct
ieee80211_sub_if_data *sdata,

        ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
        ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+       ifmgd->nullfunc_type = 0;

        for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
                if (req->crypto.ciphers_pairwise[i] ==
WLAN_CIPHER_SUITE_WEP40 ||
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 571b32b..acfc3d1 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -280,18 +280,50 @@ void ieee80211_tx_status(struct ieee80211_hw
*hw, struct sk_buff *skb)
                        local->dot11FailedCount++;
        }

+       /*
+        * We perform a nullfunc ACK check on two separate code paths:
+        *      - dynamic ps
+        *      - when going off channel during sw scan
+        *
+        * Both nullfunc retries are handled separately.
+        */
        if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
            (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
            !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-           local->ps_sdata && !(local->scanning)) {
-               if (info->flags & IEEE80211_TX_STAT_ACK) {
-                       local->ps_sdata->u.mgd.flags |=
+           local->ps_sdata) {
+               if (!local->scanning) {
+                       if (info->flags & IEEE80211_TX_STAT_ACK) {
+                               printk("NULLFUNCK ACK: dynamic PS: %d,
last type: %d\n",
+                                      IEEE80211_NULLFUNC_DYN_PS;
+                                      local->ps_sdata->u.mgd.nullfunc_type);
+                               local->ps_sdata->u.mgd.flags |=
                                        IEEE80211_STA_NULLFUNC_ACKED;
-                       ieee80211_queue_work(&local->hw,
+                               local->ps_sdata->u.mgd.nullfunc_type =
+                                       IEEE80211_NULLFUNC_DYN_PS;
+                               ieee80211_queue_work(&local->hw,
                                        &local->dynamic_ps_enable_work);
-               } else
-                       mod_timer(&local->dynamic_ps_timer, jiffies +
-                                       msecs_to_jiffies(10));
+                       } else
+                               mod_timer(&local->dynamic_ps_timer, jiffies +
+                                         msecs_to_jiffies(10));
+               } else if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
+                       printk("NULLFUNCK ACK: offchannel: %d, last type: %d\n",
+                              IEEE80211_NULLFUNC_OFFCHAN,
+                              local->ps_sdata->u.mgd.nullfunc_type);
+                       local->ps_sdata->u.mgd.flags |=
+                               IEEE80211_STA_NULLFUNC_ACKED;
+                       local->ps_sdata->u.mgd.nullfunc_type =
+                               IEEE80211_NULLFUNC_OFFCHAN;
+               } else {
+                       /*
+                        * other cases might happen but mac80211 currently does
+                        * does not care for them.
+                        */
+                       printk("NULLFUNCK ACK: private: %d, last type: %d\n",
+                              IEEE80211_NULLFUNC_PRIVATE,
+                              local->ps_sdata->u.mgd.nullfunc_type);
+                       local->ps_sdata->u.mgd.null_func_type =
+                               IEEE80211_NULLFUNC_PRIVATE;
+               }
        }

        if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX)


In hopes of covering the whole reason why ath9k has its own ACK check
for the nullfunc. Hope is to get rid of it. I think the reason we
couldn't was that mac80211 *did* not do the nullfunc ACK check for the
offchannel operation, it only did it for the dynamic PS work. So the
above categorizes the nullfuncs and would expect mac80211 to do the
right thing for each case. The exception here obviously ath9k's
virtial wiphjy stuff so hence the private type... but hopefully
that'll all be removed eventually and replaced by using internal
virtual interfaces that can operate on separate bands

I do wonder -- why do we only check for the nullfunc ACK when PS is
set, why not when we come back ? A *good* reason to check for the
nullfunc when we are going to sleep is we want to ensure we are in PS
mode on the AP side, but it seems equally reasonable to except the AP
to know we're awake otherwise if that nullfunc gets dropped the AP
would still buffer our frames for us and we wouldn't wake up for them,
creating a desynchronization between the two. Or am I missing
something?

 Luis
