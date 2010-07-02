Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:59506 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab0GBSJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:09:16 -0400
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com [172.25.149.7])
	by smtp-out.google.com with ESMTP id o62I9EeG005009
	for <linux-wireless@vger.kernel.org>; Fri, 2 Jul 2010 11:09:14 -0700
Received: from iwn7 (iwn7.prod.google.com [10.241.68.71])
	by hpaq7.eem.corp.google.com with ESMTP id o62I9Cs2017295
	for <linux-wireless@vger.kernel.org>; Fri, 2 Jul 2010 11:09:13 -0700
Received: by iwn7 with SMTP id 7so3504452iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jul 2010 11:09:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278091743.15412.17.camel@jlt3.sipsolutions.net>
References: <AANLkTilV1t1737ciSPyyETeBEcN_QXsYxgEwpZIIucR2@mail.gmail.com>
	<1278091743.15412.17.camel@jlt3.sipsolutions.net>
Date: Fri, 2 Jul 2010 11:09:12 -0700
Message-ID: <AANLkTikfegnc1gAwIUiZKaMeDoUYOFqK8eSc6_3wUggm@mail.gmail.com>
Subject: Re: [PATCH 2.6.34] mac80211: Fix auth retries if AP sends temporary
	deauth
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It may be a weird patch, but probably just because I'm still wrapping
my head around how things work.  The problem is ultimately the call to
__cfg80211_send_deauth() in wireless/mlme.c that is triggered by
reception of the DEAUTH.  That function removes wdev->auth_bsses[i],
which is needed in order for an auth to succeed.  The code path that
gets us there is:

    mac80211/rx.c: ieee80211_rx_h_mgmt()
    mac80211/mlme.c: ieee80211_sta_rx_mgmt()
    ...then through the queued work and...
    ieee80211_sta_rx_queued_mgmt()

At the bottom of the latter function, outside of the block that checks
for our authentication state, we call cfg80211_send_deauth() in
response to IEEE80211_STYPE_DEAUTH, which quite arguably should never
be called if we're authenticated.  The only time this issue touches
cfg80211 is that final call to send_deauth() which I believe is done
in error.  I think the fix should be in mac80211 somewhere.

I didn't find a way to tell where we were in the authentication proces
from within ieee80211_sta_rx_queued_mgmt(), so I swallowed the packet
much earlier in the process from within ieee80211_work_rx_mgmt(),
which has access to that state, and can indeed claim packets for
itself it it believes it knows best what to do with them.

I hope this clears up my thinking on this.  I'd be happy to change the
patch in whatever way makes sense.

--
Paul

On Fri, Jul 2, 2010 at 10:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-07-01 at 10:21 -0700, Paul Stewart wrote:
>> @@ -1030,6 +1030,25 @@ ieee80211_rx_result
>> ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
>>                       skb_queue_tail(&local->work_skb_queue, skb);
>>                       ieee80211_queue_work(&local->hw, &local->work_work);
>>                       return RX_QUEUED;
>> +             case IEEE80211_STYPE_DEAUTH:
>> +                     /*
>> +                      * If we get sent a DEAUTH while we are
>> +                      * actively trying to authenticate to this
>> +                      * station, we shoot ourselves in the foot if
>> +                      * we fall through using RX_CONTINUE and allow
>> +                      * the bss context to disappear
>> +                      * (ieee80211_sta_rx_mgmt()).  This is
>> +                      * especially true if the reason for the
>> +                      * DEAUTH was a negative but temporary direct
>> +                      * response to an AUTH attempt. Let the retry
>> +                      * mechanism run its course instead.
>> +                      */
>> +                        reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
>> +                     if (wk->type == IEEE80211_WORK_AUTH &&
>> +                            reason_code == WLAN_REASON_PREV_AUTH_NOT_VALID) {
>> +                             return RX_DROP_MONITOR;
>> +                     }
>> +                     break;
>
> Ok, wow, I finally understand this patch, but is it weird!! You're
> modifying work.c to avoid having the mlme.c code send this frame to
> cfg80211? That's really confusing.
>
> The real reason for this is that we send up the deauth frame even when
> we're not even authenticated. This happens in mlme.c. Therefore, we
> should improve the logic in ieee80211_sta_rx_queued_mgmt() to make sure
> it only triggers when we're authenticated with the BSS?
>
> Alternatively, since cfg80211 tracks this, it would be easier to modify
> cfg80211_send_rx_auth() to not send the event to userspace in the !done
> case I guess.
>
> johannes
>
>
