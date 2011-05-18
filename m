Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47451 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1ERHVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 03:21:33 -0400
Received: by iwn34 with SMTP id 34so1074747iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 00:21:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinsK3f6Wqpf7ugJKBTMtRbErTdCuw@mail.gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
 <1305677203-16660-2-git-send-email-zajec5@gmail.com> <BANLkTinh7VVGUtEUezk3mODqpQ9zPT022Q@mail.gmail.com>
 <BANLkTinsK3f6Wqpf7ugJKBTMtRbErTdCuw@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 May 2011 17:21:13 +1000
Message-ID: <BANLkTinaPMr-owT31e5hbRVKBad_u9XbUw@mail.gmail.com> (sfid-20110518_092137_287036_4CD2FB1D)
Subject: Re: [PATCH 2/9] b43: add bus device abstraction layer
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/18 Rafa³ Mi³ecki <zajec5@gmail.com>:
> W dniu 18 maja 2011 02:28 u¿ytkownik Julian Calaby
> <julian.calaby@gmail.com> napisa³:
>> Rafa³,
>>
>> A quick question:
>>
>> 2011/5/18 Rafa³ Mi³ecki <zajec5@gmail.com>:
>>>
>>> Signed-off-by: Rafa³ Mi³ecki <zajec5@gmail.com>
>>> ---
>>>  drivers/net/wireless/b43/Makefile |    1 +
>>>  drivers/net/wireless/b43/b43.h    |    4 +++-
>>>  drivers/net/wireless/b43/bus.c    |   36 ++++++++++++++++++++++++++++++++++++
>>
>> Would it make more sense to have this be called ssb.c as it contains
>> all the ssb specific functions,
>
> It's only ssb specific for now. It will contain BCMA code later.
>
>
>> that way you can then have an brcma.c
>> file to contain the functions specific to that bus?
>
> I'll put BCMA specific code in bus.c.
> Right now bus.c contains 100 LOC* and I believe its SSB part is
> complete. All the ops functions are one liners. It's so small and
> simple file I don't see sense to splitting it and having more mess in
> list of files instead.

As I see it, having two sets of mostly identical  wrapper functions in
a file seems incorrect to me. Especially as once the abstraction is
complete it would technically be correct to build b43 without SSB
support - it's much cleaner to not compile a file than have a massive
#ifdef block in a common file.

Anyway, it's only a minor thing.

> A one quick question:
> Why didn't you respond in "[RFC][PATCH] b43: add bus abstraction
> layer" on 2011-04-08? Or more recent "[RFC ONLY 2/5] b43: add bus
> device abstraction later" posted on 2011-05-09?

While I try to read every patch that passes through the linux-wireless
mailing list, I only skim them, and tend to miss some details. The
thing that prompted this comment was the SSB comment at the start of
the SSB specific wrappers - something I probably didn't read the last
two times the patch came up on the list.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
