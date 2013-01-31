Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:60322 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab3AaIwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 03:52:41 -0500
Message-ID: <510A30D1.2080604@neratec.com> (sfid-20130131_095245_936882_B7AA1A43)
Date: Thu, 31 Jan 2013 09:52:33 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection command/event
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de> <5107D345.7010101@neratec.com> <20130129143652.GA23425@pandem0nium> <5109094C.8050703@neratec.com> <20130130162531.GA27532@pandem0nium>
In-Reply-To: <20130130162531.GA27532@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2013 05:25 PM, Simon Wunderlich wrote:
> Hey Zefir,
> 
>> [...]
>>>> Not sure if IEEE80211_DFS_UNKNOWN is not missing here, i.e. whether a channel that
>>>> never passed a CAC (or the CAC has been aborted) is always USABLE. Once I realized
>>>> why ETSI defined an UNKNOWN state, but forgot meanwhile - so maybe only relevant
>>>> for managed operation (like an UNKNOWN state can be overridden by external
>>>> information, whereas e.g. UNAVAILABLE can't).
>>>
>>> I've seen the UNKNOWN state in your last mail and your last slides, but didn't see
>>> a purpose for it. If you can remember what we need it for, please tell me. :) We could
>>> reject changes for an UNAVAILABLE channel from outside access if this is required.
>>
>> Double checked it and realized that ETSI removed that state between v1.5 and v1.7.
>> Before, it enabled the frequency manager to differentiate between untouched
>> channels and channels that passed a NOP (which is the only way to become USABLE).
>>
> 
> OK, good, then we can skip it. :)
> 
>>> The idea was that a CAC can always be started, and state transition is only performed
>>> after a succesful CAC. This simplifies the state machine and some corner cases. A
>>> channel stays USABLE through the CAC, and is only changed to AVAILABLE after CAC is
>>> completed. We also don't forbid checking the same channel on different WiFi modules,
>>> if any of them completes the channel is changed to AVAILABLE.
>>>
>> Really, a CAC is done whenever you switch to a DFS channel? I'd expect that
>> switching from an operating channel and back does not require a CAC (that's the
>> sole purpose of the AVAILABLE state and a centralized state handler).
>>
> 
> No, as you say: if you switch operating channel to another one which is available, both
> channels stay available. You can CAC all channels after booting and switch between them
> without doing any other CAC (at least as long as you don't sense a radar).
> 
> 
> What I was trying to say: If the channel is USABLE before (this is also the initial state),
> it is only set AVAILABLE after CAC has finished on this device. If the CAC is aborted, no
> state transition is done.
> 
> If you have a second AP instance (when multiple interfaces are supported at one point, they
> are not in the current version), it can also do start a CAC independently from the first AP.
> 
> I like to keep the interfaces as independent as possible, to prevent weird race conditions/interactions
> between the interfaces which would be hard to debug. :)
> 
>>> The same goes for the OPERATING state (defined in ETSI at least) - I don't have this
>>> as dfs state, because it is just the same as AVAILABLE plus the information that
>>> we currently use it, and that we know in the driver. Adding the state would just
>>> add management overhead with no practical gain, IMHO.
>>>
>> Would there be a benefit of an OPERATING state on systems with multiple wiphys?
>>
> 
> I don't know - I've not looked up who creates the channels, but Johannes told me that different
> wiphys might have independent channel structs, if I remember correctly.
> 
> If we have an OPERATING state we have to sync it over multiple wiphys and/or multiple interfaces
> - for example, when an interface goes down we have to check all other interfaces if they still
> use the channel before setting it back to AVAILABLE. Certainly doable, but bothersome.
> 
> I currently don't see any benefit, but maybe someone else does and can explain. :)
> 
> Cheers,
> 	Simon
> 
Hey Simon,

all my comments were based on a centralized frequency manager I implemented for
our system (in user-space) and my assumption that its functionality should be
portable to mac80211, i.e. channel states being managed by reg.c and wdevs being
continuously notified on state changes.

Take a setup where you have two cards running, one as master and the other as
monitor doing off-channel-CAC. If the monitor detects radar on the master's
operating channel (and the master doesn't), with the current implementation the
master can't be notified to switch. I understand that supporting this very
specific use-case would add unjustifiable complexity, while at the same time, with
the updates you made this can be achieved at higher layers - so it is good enough
as it is.


Looking forward your patches to get integrated soon, to allow people actually
testing DFS. I'm eagerly waiting for more active testers to share some ugly
problems I am observing with ath9k's pulse detector. Therefore: full ACK.


Thanks,
Zefir



