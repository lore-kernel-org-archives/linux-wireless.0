Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:46755 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752686AbZBIL6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 06:58:22 -0500
Message-ID: <49901A58.4030403@cosetrain.com> (sfid-20090209_125826_693089_689619E7)
Date: Mon, 09 Feb 2009 12:58:16 +0100
From: Florian Sesser <flomaillist@cosetrain.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Benedikt Elser <elser@in.tum.de>
Subject: Re: [PATCH 3/3] mac80211: Modul. mesh path prot: Skeleton Module
References: <498F36B7.40806@cosetrain.com>	 <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>	 <897787d59c53459e0bff3a6829ac470f6ed2e84e.1234118418.git.flomaillist@cosetrain.com>	 <944d8e06a2b02e5ae6d612fb435d540958023ff9.1234118418.git.flomaillist@cosetrain.com>	 (sfid-20090208_205238_672681_BE3F6B7E) <1234176251.4175.222.camel@johannes.local>
In-Reply-To: <1234176251.4175.222.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Johannes, thanks for all of your comments! I will need some time to work
through them, though, please be patient.

Johannes Berg wrote:
> 00-0F-0F   (hex)                Real ID Technology Co., Ltd.
> 000F0F     (base 16)            Real ID Technology Co., Ltd.
>                                 9F Hanmi B/D 192-19
>                                 Nonhyeon-Dong
>                                 Gangnam-Gu Seoul 135-010
>                                 KOREA, REPUBLIC OF
> 
> Have you asked them about using their OUI?

Nah, sorry about that - I didn't get 0x000FACFF meant 'null' in the
first place, and since I don't have access to an OUI yet, I selected
this value by random. I still hope nobody seriously wants my skeleton
module in the kernel code though.

BTW... do you know which OUI in that case (at devel time, this is an
university project, afaik the university does not have an OUI I can use)
makes sense for stuff like that? I believe there is a reserved range,
but I don't know for what reason it's reserved, and if I should use it
to avoid misunderstandings.

>> +config MAC80211_MESH_PP_TEST
>> +	tristate "80211s: Path selection protocol test module"
>> +	default n
>> +	depends on MAC80211_MESH && MAC80211 && EXPERIMENTAL && m
> 
> && m ???

Limits the tristate to 'n' or 'm', because I didn't want to clutter the
code with ifdefs for the 'compiled-in' case. This cannot be the final
solution either. I need to investigate some more on what happens if I
just compile it in.

[do you really think I should to copy the style of rate control? i don't
like it at all. they have KBs of (IMHO) not very useful code instead of
keeping it to the point? Even in the Kconfig. Please correct me if I got
this wrong.]

> Generally, this looks like a decent idea,

Thanks :)

> but the execution definitely is lacking.

I know that, as I'm pretty new to kernel coding. Should I get me some
mentor from the kernel mentors project, or are you willing to correct my
stupid beginner mistakes all the time?

Also: As you still haven't said anything about my ops struct, I deem you
think I have made a somewhat reasonable selection here?

Again, thanks a lot!

Florian
