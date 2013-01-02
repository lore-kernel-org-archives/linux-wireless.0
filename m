Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1890 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab3ABUsf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 15:48:35 -0500
Message-ID: <50E49D10.7080501@broadcom.com> (sfid-20130102_214838_154504_3E3FFE6C)
Date: Wed, 2 Jan 2013 21:48:16 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: WARNING: at
 drivers/net/wireless/brcm80211/brcmsmac/main.c:7539
References: <CA+55aFwpdyrtvE=86e1aHE9L5TR+_xP7e4PBBKtdcey3=f+Suw@mail.gmail.com>
 <50E4229D.5000900@broadcom.com> <20130102135031.GA11439@thinkpad-t410>
 <50E43F40.4090206@broadcom.com> <20130102150939.GB11439@thinkpad-t410>
In-Reply-To: <20130102150939.GB11439@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2013 04:09 PM, Seth Forshee wrote:
> On Wed, Jan 02, 2013 at 03:08:00PM +0100, Arend van Spriel wrote:
>> On 01/02/2013 02:50 PM, Seth Forshee wrote:
>>> On Wed, Jan 02, 2013 at 01:05:49PM +0100, Arend van Spriel wrote:
>>>> On 12/28/2012 07:07 AM, Linus Torvalds wrote:
>>>>> Ok, maybe somebody is interested in this.. I don't know what triggered
>>>>> it, but maybe the few lines around it give some clue.
>>>>
>>>> Hi Linus,
>>>>
>>>> I am interested (being paid for it kinda helps). The warning itself does
>>>> not necessarily have to be a problem, but the frameid mismatch between
>>>> tx status info and the related buffer taken from the DMA ring does.
>>>> Smells like a race condition, but I need to investigate that.
>>>>
>>>>> I think it's new to 3.8-rc1, because I haven't seen it before (well,
>>>>> I'm running current -git - v3.8.0-rc1-00035-g101e5c7470eb to be exact
>>>>> - but the networking changes since -rc1 are small and seem unrelated).
>>>>> But maybe it just happens under certain circumstances.
>>>>
>>>> We had a big contribution from Canonical (cc-ed Seth) in brcmsmac
>>>> itself. Not playing the blame game, but I suspect it has altered
>>>> circumstances making the real issue (that was already there) more likely
>>>> to happen. Hope that helps us nailing it down.
>>>
>>> I'm certain that both problems existed prior to 3.8-rc1. The warning
>>> itself has generated a fairly consistent trickle of bug reports for a
>>> while now. I haven't noticed any increased frequency of these messages;
>>> if anything I'd say I'm hitting the WARN_ON less often (though I've been
>>> doing a lot of testing under heavy load so my observations may not be
>>> typical).
>>
>> Hi Seth,
>>
>> Indeed the warning has been there for a while, but the fatal error
>> resulting in triggering a restart from mac80211 has popped up late in
>> the 3.7-rc cycles and seem to consistently fail on our smoketest as well.
> 
> I looked at the errors again and realized I was interpreting some of
> your comments in the wrong context. I don't recall having seen the
> frameid != txh->TxFrameID problems in my testing. If you can give me a
> test case to reproduce then I'll take a look as well.

I tried today and got dma_getnexttxp() return NULL pointer, which also
results in a hardware restart.

> Do you recall the exact -rc when it appeared? I can run a bisection if I
> can get it reproducing consistently.

Not sure. We did not upgrade the smoketests to every rc. So it only ran
rc3 and rc6 although mac80211, cfg80211, and brcm80211 drivers were
built and tested nightly from wireless-testing. Digging in my mailbox
the last reliable smoketest seems to be around november 29th.

Greetings,
Arend


