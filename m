Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45688 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0IUWRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 18:17:30 -0400
Received: by iwn5 with SMTP id 5so5459574iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 15:17:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikAbwntNzX43zAfNjkV56sVeFhOuHiV5odpuL5T@mail.gmail.com>
References: <1285097222-10286-1-git-send-email-lrodriguez@atheros.com>
 <1285097460.12764.13.camel@jlt3.sipsolutions.net> <AANLkTikAbwntNzX43zAfNjkV56sVeFhOuHiV5odpuL5T@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 21 Sep 2010 15:17:09 -0700
Message-ID: <AANLkTim=WSFjhW6N775-tg51PoRmKf2t_KPU9oS0O4cz@mail.gmail.com>
Subject: Re: [RFC] mac80211: Deny new BA sessions from being started during
 offchannel operation
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, srinivasa.duvvuri@atheros.com,
	matt.smith@atheros.com, bennyam.malavazi@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 21, 2010 at 12:39 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Sep 21, 2010 at 12:31 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2010-09-21 at 15:27 -0400, Luis R. Rodriguez wrote:
>>
>>> +     mutex_lock(&local->sta_mtx);
>>> +     list_for_each_entry(sta, &local->sta_list, list)
>>> +             if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
>>> +                     set_sta_flags(sta, WLAN_STA_BLOCK_BA);
>>> +     mutex_unlock(&local->sta_mtx);
>>> +
>>
>> This is really expensive, I don't think we should do it this way.
>> Wouldn't it be possible to put a check into place wherever the flag is
>> checked too?
>
> Good point, sure, we'll need more checks and conditions added later
> too so that would also help to avoid running into this code for
> non-11n cards.

So some notes of a meeting I had with some of our Atheros folks on
this topic and this whole offchanel operation thing:

  * AR9003 has hardware beacon processing so we can
    just detect checksums of IEs, etc. Once we get this code
    settled in we can add a hw flag to mac80211 to indicate support
    for beacon monitoring to be handled by hw and let AR9003 devices
    handle this (we may have this already)

  * bgscan on deadzone: if beacon monitor is OK but
    connection monitor gets hit -- send an event to userspace, we've hit the
    "deadzone" and expect userspace to interpret this as
    a desire on the kernel side to try to roam to another AP

  * If we send an ADDBA request to the AP and timer is pending
    clear timer and reset TID state, that's all

  * in case of BA agreements, no reason to tear them down,
    TX flush, and keep the RX reorder timer as-is because:
    - we do not know what the transmitter is doing,
      so extending the timeout may actually worsten
      the situation. This is expected when going offchannel.
    - we not want to tear down aggregation
    - If we want optimizations here we can consider different
      timeout values for each reorder buffer based on TID / priority
      We should check with Steve Kuhn on some of these values as we
      may already have some values we can use here.

  * We should clear the connection monitor and beacon monitor when we
are able to
    successfully TX data to an AP, but before we enable this we will
want to implement
    a force scan command. If the force scan command is used we do not
want to put off
    delaying offchannel operation if we're currently non-idle. Review
the dynamic PS work and
    if it is based on successful TX data, we can re-use this to know
whether or not we want
    to postpone offchannel operation.

  * We send nulldata frames for going into powersave and when going
offchannel. In the powersave
    case we wait for an ACK and that is perfect. For the offchannel
case we currently do not wait
    for an ACK but we should not add support for checkign for the ACK
-- simply do best effort by
    relying on hardware multi rate retries for the nullfunc frame, all
we need to do is wait for the
    TX completion of the nulldata frame, whether or not the nulldata
frame was successfull or not.

  Luis
