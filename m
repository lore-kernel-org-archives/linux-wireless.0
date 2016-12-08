Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f181.google.com ([209.85.210.181]:35930 "EHLO
        mail-wj0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752495AbcLHUfV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 15:35:21 -0500
Received: by mail-wj0-f181.google.com with SMTP id tk12so102826727wjb.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2016 12:35:21 -0800 (PST)
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
 <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
 <1481102727.4092.34.camel@sipsolutions.net>
 <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com>
 <280cb669-2360-d4fc-779b-80196c944e2e@broadcom.com>
 <20161208175236.GA6121@jouni.qca.qualcomm.com>
Cc: "Vamsi, Krishna" <vamsin@qti.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <63343007-2245-1861-94fd-bdda0de2f7dc@broadcom.com> (sfid-20161208_213526_967952_6E9296C4)
Date: Thu, 8 Dec 2016 21:35:18 +0100
MIME-Version: 1.0
In-Reply-To: <20161208175236.GA6121@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8-12-2016 18:52, Malinen, Jouni wrote:
> On Wed, Dec 07, 2016 at 09:03:23PM +0100, Arend Van Spriel wrote:
>> On 7-12-2016 10:33, Vamsi, Krishna wrote:
>>>> -----Original Message-----
>>>> From: Johannes Berg [mailto:johannes@sipsolutions.net]
>>>
>>>> What about Arend's comment regarding this functionality overlapping with the
>>>> BSS selection offload configuration?
>>>>
>>>> Do you think there's any ability to share attributes/functionality?
>>>
>>> Hi Johannes,
>>>
>>> I think the later comment from Luca on this which I pasted below is more agreeable.
>>>
>>> Yes, similar but not quite the same.  The existing case is for finding BSSs that are worth waking the host up for (while disconnected), so it needs to be better than the RSSI passed (absolute number).  Now this is about relative RSSI as compared to the current connection, so RELATIVE_RSSI is different than RSSI and I think the same attribute should not be used, to avoid confusion.
>>
>> I noticed the response from Luca, but did not get back on this. I know
>> it is not the same, but what I meant is whether we could extend it so it
>> also covers your scenario.
> 
> I'm not sure I see the point of trying to avoid the new RELATIVE_RSSI
> attribute. We need to clearly specify that this new constraint is indeed
> for relative comparison against the currently connected BSS.

Hi Jouni,

I am not saying it should be avoided. Just looking at it conceptually
the scheduled scan request holds so-called matchsets that specify the
constraints to determine whether a BSS was found that is worth notifying
the host/user-space about. As such I would expect the relative RSSI
attribute(s) to be part of the matchset. That way you can specify it
together with the currently connected SSID in a single matchset.

> As far as your second email is concerned, it might make more sense to
> use the existing NL80211_ATTR_BSS_SELECT instead of the new
> NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF since they cover very
> similar purpose in defining RSSI preference between bands. We can take a
> look at doing so. One thing to be a careful about this is in what claims
> there are about using NL80211_ATTR_BSS_SELECT for capability indication
> in GET_WIPHY. I guess we can leave that as-is to apply for _CONNECT and
> the new EXT_FEATURE flag we are adding for sched_scan applies for this
> attribute in SCHED_SCAN.

The NL80211_ATTR_BSS_SELECT supports different methods for BSS
selection. One of them being RSSI_ADJUST which is similar to this. It
lets user-space specify the band and adjustment instead of having a band
implied in the attribute name. Agree that if reusing it for scheduled
scan you would still need the EXT_FEATURE flag.

Regards,
Arend
