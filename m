Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37639 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab1AQLV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 06:21:26 -0500
MIME-Version: 1.0
In-Reply-To: <1295261783.24530.3.camel@maggie>
References: <AANLkTi=GDcy50zsC6=Dgv1-Ty3cYK2qpx9o=q3JdXuCh@mail.gmail.com> <1295261783.24530.3.camel@maggie>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Mon, 17 Jan 2011 12:21:05 +0100
Message-ID: <AANLkTikJcug7LUTgX_YDD4Z8ZBrdkAdLq8_Epa6TkA5f@mail.gmail.com>
Subject: Re: Merging SSB and HND/AI support
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 January 2011 11:56, Michael Büsch <mb@bu3sch.de> wrote:
> On Mon, 2011-01-17 at 11:46 +0100, Jonas Gorski wrote:
>> a) Merge the HND/AI code into the current SSB code, or
>>
>> b) add the missing code for SoCs to brcm80211 and replace the SSB code with it.
>
> Why can't we keep those two platforms separated?
> Is there really a lot of shared code between SSB and HND/AI?

Yes, as far as I understand the AI bus behaves mostly like a SSB bus
except for places like enabling/disabling cores. E.g. the AI bus also
has a common core, which has a bit for telling whether its a SSB or AI
bus, and has the mostly the same registers as the SSB common cores (so
most driver_chipcommon_* stuff also applies for the AI bus).

> It's true that there's currently a lot of device functionality built
> into ssb. Like pci bridge, mips core, extif, etc...
> If you take all that code out, you're probably not left with anything.

That's because most shared code isn't in brcm80211, but only found in
the SDKs for the SoCs.

> So why do we need to replace or merge SSB in the first place? Can't
> it co-exist with HND/AI?

It probably can, but then the SSB code must be at least made AI aware
so it doesn't try to attach itself if it finds one. Also I don't know
if it is a good idea to let arch-specific code depend on code in
staging.

Jonas
