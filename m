Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46813 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2GJFqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 01:46:22 -0400
Received: by lbbgm6 with SMTP id gm6so21560211lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 22:46:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfdUxLn-h3dN-tjHccXXwamxdB4ALouFO+8YEvgWKYzuSA@mail.gmail.com>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
 <1341732211-25871-8-git-send-email-coelho@ti.com> <1341740110.4987.4.camel@jlt3.sipsolutions.net>
 <CA+XVXfdEqQyiyDQoAddCjC9bhH+WqmANiqf_wUCEJFi7=xG5vQ@mail.gmail.com>
 <1341821025.4455.5.camel@jlt3.sipsolutions.net> <CA+XVXfdQCPTrEdDb1WY67rSKucjH=aU9S+zzkZ=xB+GW94Ty9A@mail.gmail.com>
 <CAGRGNgXWackce4pHpbOc1Bd9EhhEGSVfGsimMXvEDsJpguWQ5Q@mail.gmail.com> <CA+XVXfdUxLn-h3dN-tjHccXXwamxdB4ALouFO+8YEvgWKYzuSA@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 10 Jul 2012 15:46:01 +1000
Message-ID: <CAGRGNgVbGQ6fKR8EfbUEei3JD-EMpg4CJmr-5XKnrJc0VRs8QQ@mail.gmail.com> (sfid-20120710_074625_758289_39E690F4)
Subject: Re: [PATCH 7/8] wl18xx: don't send static global struct to FW
To: Arik Nemtsov <arik@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arik,

On Tue, Jul 10, 2012 at 3:42 PM, Arik Nemtsov <arik@wizery.com> wrote:
> Hey Julian,
>
> On Tue, Jul 10, 2012 at 7:32 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Arik,
>>
>> On Mon, Jul 9, 2012 at 6:14 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>> On Mon, Jul 9, 2012 at 11:03 AM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>>>> On Sun, 2012-07-08 at 17:08 +0300, Arik Nemtsov wrote:
>>>>
>>>>> > kzalloc (which is pointless -- use kmemdup) alignment is sufficient,
>>>>> > then most likely you could just put "__aligned(4)" or something on the
>>>>> > conf.phy struct member and not allocate memory at all?
>>>>>
>>>>> Yea we need 4 bytes alignment. The kzalloc is a sort of convention in
>>>>> the driver (see acx.c), but probably here we can use kmemdup.
>>>>> We can't use fancy __aligned(4) notations most likely, since a
>>>>> usermode tool also parses these header files, and it's not too smart
>>>>> :)
>>>>
>>>> This seems like a rather bad excuse for making the runtime code more
>>>> complex and less performant ... I'll let you sort it out with John
>>>> though, I wouldn't let you get away with this though if I maintained the
>>>> tree ;-)
>>>>
>>>> FWIW, I think your actual problem is that you mark wl18xx_priv_conf as
>>>> packed unnecessarily. Otherwise it might actually get alignment, at
>>>> least on ARM I hear.
>>>
>>> It's not an excuse, we really have a usermode tool (called wlconf)
>>> preparing binary conf files. And it usually runs on a different arch
>>> (x86), so we mark everything packed to avoid errors.
>>> I'm pretty sure __aligned(4) would screw up the parser there. It has
>>> to build an internal representation of all the struct, and fill it out
>>> using an ini file.
>>
>> Does this tool parse the compiled code or the actual source files?
>> Because if it parses the source files, surely you could adjust the
>> parser so it doesn't trip over a potential __aligned(4) notation.
>
> The tool goes over source files, but it's not just a matter of
> skipping the token - it has to actually align the next element to 4,
> so it needs to start keeping track of alignment etc.

Ah, does it produce binary chunks of data that are then "parsed" with
this structure?

> I'm afraid we have bigger issues with this tool right now. Currently
> it can't even parse arrays properly :)

That's a big problem =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
