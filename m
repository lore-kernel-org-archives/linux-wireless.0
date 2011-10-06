Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:49486 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929Ab1JFUck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 16:32:40 -0400
Message-ID: <4E8E1062.1070206@neratec.com> (sfid-20111006_223243_888633_CAC5C0C5)
Date: Thu, 06 Oct 2011 22:32:34 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	kgiori@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC 5/6] ath9k: enable DFS pulse detection
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <201110041538.12885.chunkeey@googlemail.com> <CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com> <201110061849.48838.chunkeey@googlemail.com> <CAB=NE6WbMi2GYJyFfvsdH-NSXn8dPBsgxgfdGXO_RHiJxwz2Fw@mail.gmail.com>
In-Reply-To: <CAB=NE6WbMi2GYJyFfvsdH-NSXn8dPBsgxgfdGXO_RHiJxwz2Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06.10.2011 20:36, Luis R. Rodriguez wrote:
> On Thu, Oct 6, 2011 at 9:49 AM, Christian Lamparter
> <chunkeey@googlemail.com>  wrote:
>> On Thursday, October 06, 2011 12:27:03 AM Luis R. Rodriguez wrote:
>>> You do have a good point, but I disagree that you do not need to test
>>> / regress test hardware / driver code for DFS.
>>
>> Actually, you are sort of contradicting yourself here.
>>
>> Take a look at your "wireless: add DFS master support" patch
>> series. I don't see any IFDEFs to select between the old
>> and the new "way" even though you know full well that there's
>> some black magic going on.
>
> Well its true, but the regdb and CRDA stuff is can have the DFS master
> region support, its just the mapping, not a technical implementation.
> IMHO DFS support should be a kconfig on both the 802.11 stack and
> driver part, and the driver part depend on the 802.11 stack option.
>
The concept for the management part that will be located in mac80211 and 
hostapd is still WIP at TI, so we can just speculate about its 
implementation for now.

If one consider object size irrelevant (working in the embedded world, I 
tend to not fully agree), it is enough to disable the DFS capability in 
the driver, since DFS requires a full support chain in all three layers 
to enable operation in DFS bands.

>> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/78455
>> Quote:
>> "Here's a puzzle though... If we change this series to use the other
>> pad byte that was available, the first pad byte, instead of the last
>> one, we loose backward compatibility support and I cannot figure out
>> why."
>
> That's an implementation weirdness with python pack on generating the
> binary output, not a DFS issue per se.
>
>> [Note: This is just an recent enough example. I do think I could come
>> up with a better one, e.g.: why didn't athXk have a compile-time
>> switch to disable ANI when it was introduced because it can(and has?)
>> caused some regressions as well?]
>
> No ANI is *required*, without it the cards are useless. ANI is also
> properly tested and validated by our systems team. Have you tried
> disabling ANI? When we introduced a revamp of the new ANI though we
> did enable users to use the new ANI for older generation cards, the
> module parameter is still there.
>
> DFS is a different beast. Testing DFS cannot be compared to testing
> ANI, DFS has a slew of different tests you need to run against, and
> then *if* you do want to sell cards in certain geographies with
> support for DFS channels you need to get proper regulatory
> certification for an intended radiator that supports DFS properly. If
> you get this certification technically you cannot even expose a knob
> to users to disable DFS when operating on a DFS channel.
>
>> so, why do you want a useless compile-time for *this option* *now*?
>
> What I want to do is enable an option which lets distributors disable
> DFS if they don't want to even deal with the question of whether or
> not a card had DFS support enabled through driver support.
>
>> Is this something about politics/laws I don't know about [I'm just
>> curious, because I don't really buy "testing" here, since Zefir
>> obviously has a working prototype
>
> No, we haven't passed certified testing with this code yet.
>
>> and Atheros has a working and certificated codebase as well
>
> Exactly, and that is the code we are enabling Neratec with to be able
> to upstream into the kernel for, but the code being referenced uses a
> different 802.11 stack, different base driver, etc.
>
I see, I should have officially announce the wiki page where we want to 
collect our joint DFS development information [1] to include all those 
valuable thoughts.

For clarification: the existing referenced implementation is not 
portable to ath9k/mac80211. It follows a monolithic approach where the 
DFS detector takes over full processing control after pattern match and 
handles all required management functionality from within. Refactoring 
those processing path to distribute it between driver, mac80211 and 
hostapd is more complicated than a full redesign. FYI, Adrian is 
following this approach for FreeBSD.

For the detector prototype: yes, I worked on some pattern matching 
algorithms and have some working prototype. With the HW reliably 
providing pulse events it's no rocket science to design a radar detector 
that can pass certification (I tested it for ETSI), while it is to 
design one that allows you to use DFS channels (i.e. low false detections).


[1] http://linuxwireless.org/en/developers/DFS/Development

>> which he can access and base his work on. So I don't think its that unstable and needs added
>> ugliness.]
>
> Its the same with 802.11s, its new code and people may want to disable
> this crap to not deal with it in code path or even consider the
> support for it.
>
>>> This is what I'm talking about. But yes, userspace also submits
>>> itself to the same criteria.
>>>>> You may also want to simply disable DFS if you do not want to
>>>>> deal with the regulatory test implications of having it enabled.
>>>> AFAIK you can't "simply" disable the DFS requirement: hostapd
>>>> (hw_features.c), [cfg80211] (checks if tx on secondary channel
>>>> is possible) and mac80211 (tx.c) all have checks. Indeed, the
>>>> easiest way is to modify crda's database. So there's no need
>>>> for an extra compile-time option.
>>>
>>> No, DFS is set for certain channels on wireless-regdb/CRDA, I just
>>> posted DFS master region support for wireless-regdb and CRDA. Apart
>>> from this we then need driver support. To get DFS you need all of
>>> these + hostapd part. Each one has its own set of components and does
>>> deserve its own set of tests and review.
>>
>> This "deserve its own set of tests and review". Does it translate in:
>> "ath9k [every driver], mac80211, cfg80211 and hostapd need extra
>> DFS IFDEFS?".
>
> I still have yet to see patches for cfg80211 / mac80211 for DFS. What
> I'm saying is we have an kconfig option on the 802.11 stack to  allow
> us to disable DFS support, and the driver respective component depend
> on it.
>
As said above, disabling a driver's capability through a Kconfig option 
should be enough (one ifdef per driver).

>> In fact, ifdefs make it harder to do reviews, because
>> sometimes you just forget the IFDEF/ELSIF/ELSE context of the code.
>
> I hate ifdefs, and if you read my e-mail carefully what I was
> suggesting was to do this properly by building all the code if the
> kconfig option is enabled therefore eliminating all ifdef junk from
> the code and only leaving it for header files.
>
>> And regression testing can be done by "git bisect". In fact, isn't
>> this what git bisect is for?
>
> There is a difference between regression testing and finding the
> culprit of an issue. git bisect is used to find the culprit of an
> issue. However if you want to ensure code does not regress you need to
> ensure to run a suite of tests on code after a delta is applied. Only
> if you find an issue do you then use git bisect.
>
> I want proper test infrastructure set up before I even consider
> enabling any DFS code upstream for ath9k.
>
Since regulatory compliance and open source by principle form a 
gray-zone combination [2], testing for sure is essential to keep it more 
white than black ;)

[2] http://linuxwireless.org/en/developers/Regulatory/statement#Principles

>    Luis

Zefir
