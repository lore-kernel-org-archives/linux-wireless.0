Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:52089 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab0GZXbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 19:31:03 -0400
Received: by pxi14 with SMTP id 14so264291pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 16:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C4E1784.3030702@candelatech.com>
References: <4C4DE6B5.5080307@candelatech.com> <4C4E0580.3060404@candelatech.com>
	<AANLkTi=qJXCxtMZcEm3VQT1s7ioJsdhj2kJzkgGSf3ND@mail.gmail.com>
	<4C4E1784.3030702@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Jul 2010 16:30:41 -0700
Message-ID: <AANLkTimnZ9pSfVLsEPgiDPyc=_eUnyLj89RHCC6rsaX8@mail.gmail.com>
Subject: Re: ath9k: /proc/net/wireless always shows status of 0
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 4:17 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 07/26/2010 03:54 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, Jul 26, 2010 at 3:00 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> On 07/26/2010 12:49 PM, Ben Greear wrote:
>>>>
>>>> This is with today's wireless-testing (with no extra hacks)
>>>
>>> Maybe a better question:  In 2.6.31 you could mount debugfs at /debug
>>> and get the state with:
>>> cat /debug/ieee80211/sta0/state
>>
>> debugfs is not static API. In fact that's a big reason why we use it.
>> I considered defining a filesystem API for 802.11 using configfs but
>> our priority is to first get nl80211 feature-complete with respect to
>> wext, which we have completed now. But anyway, debugfs is *not* API
>> and you should not rely on it, if you want to define API consider
>> configfs.
>>
>>> It seems in .34 there is only phy0 info in debugfs.  Or, am I
>>> just not looking in the right place?
>>>
>>> I don't mind hacking code, but I'd appreciate a pointer to the
>>> right part of the code if anyone has suggestions.
>>
>> The other thing you pointed out with wext, you should stop using wext
>> and instead rely on nl80211. It is true that if you see something on
>> /proc/net/wireless/ that was there before but not there now it is a
>> regression and it should be addressed. Not sure where the status crap
>> comes from on wext.
>
> I really don't care what API I end up using..I am just looking for some
> way to report to users whether the STA is in the various states that
> used to be defined as something similar to:
>
> enum ieee80211_state {
>        IEEE80211_UNINITIALIZED = 0,
>        IEEE80211_INITIALIZED,
>        IEEE80211_ASSOCIATING,
>        IEEE80211_ASSOCIATED,
>        IEEE80211_AUTHENTICATING,
>        IEEE80211_AUTHENTICATED,
>        IEEE80211_SHUTDOWN
> };
>
> I have been reading the net/wireless code, but so far I don't see
> any state machine type logic where this state might be kept.  Maybe
> it would have to be inferred from something else?

You can use nl28011 and register for netlink multicast messages which
broadcast device state changes like the ones you mentioned. These come
in on iw via event.c, see print_event() and see the case statements
for NL80211_CMD_ASSOCIATE, NL80211_CMD_DEAUTHENTICATE,
NL80211_CMD_DISASSOCIATE, etc, you even get reason codes parsed for
you too.

  Luis
