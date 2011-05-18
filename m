Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33343 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1ERHBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 03:01:31 -0400
Received: by qyg14 with SMTP id 14so726065qyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 00:01:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinh7VVGUtEUezk3mODqpQ9zPT022Q@mail.gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
	<1305677203-16660-2-git-send-email-zajec5@gmail.com>
	<BANLkTinh7VVGUtEUezk3mODqpQ9zPT022Q@mail.gmail.com>
Date: Wed, 18 May 2011 09:01:30 +0200
Message-ID: <BANLkTinsK3f6Wqpf7ugJKBTMtRbErTdCuw@mail.gmail.com> (sfid-20110518_090135_022166_DA2D8940)
Subject: Re: [PATCH 2/9] b43: add bus device abstraction layer
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 maja 2011 02:28 użytkownik Julian Calaby
<julian.calaby@gmail.com> napisał:
> Rafał,
>
> A quick question:
>
> 2011/5/18 Rafał Miłecki <zajec5@gmail.com>:
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/Makefile |    1 +
>>  drivers/net/wireless/b43/b43.h    |    4 +++-
>>  drivers/net/wireless/b43/bus.c    |   36 ++++++++++++++++++++++++++++++++++++
>
> Would it make more sense to have this be called ssb.c as it contains
> all the ssb specific functions,

It's only ssb specific for now. It will contain BCMA code later.


> that way you can then have an brcma.c
> file to contain the functions specific to that bus?

I'll put BCMA specific code in bus.c.
Right now bus.c contains 100 LOC* and I believe its SSB part is
complete. All the ops functions are one liners. It's so small and
simple file I don't see sense to splitting it and having more mess in
list of files instead.


A one quick question:
Why didn't you respond in "[RFC][PATCH] b43: add bus abstraction
layer" on 2011-04-08? Or more recent "[RFC ONLY 2/5] b43: add bus
device abstraction later" posted on 2011-05-09?


* 100 LOC without GPL header, but including /includes/ and empty lines.

-- 
Rafał
