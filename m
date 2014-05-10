Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:65102 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaEJQMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2014 12:12:16 -0400
Received: by mail-ob0-f175.google.com with SMTP id wo20so6281901obc.34
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2014 09:12:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140510171721.54b21a63@wiggum>
References: <1399733088-26607-1-git-send-email-zajec5@gmail.com>
	<20140510171721.54b21a63@wiggum>
Date: Sat, 10 May 2014 18:12:15 +0200
Message-ID: <CACna6rwdXiGwLW=vuo2MMaQHYAWjDwc_W2zufmVbkmpBsMMp-Q@mail.gmail.com> (sfid-20140510_181222_723826_A6AABC3A)
Subject: Re: [RFC][PATCH] b43: drop SSB dependency
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 May 2014 17:17, Michael Büsch <m@bues.ch> wrote:
> On Sat, 10 May 2014 16:44:48 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>> +config B43_BUSES_BCMA_AND_SSB
>> +     bool "BCMA and SSB"
>> +     depends on BCMA_POSSIBLE && SSB_POSSIBLE
>
> I think this needs to be:
>
>         depends on (BCMA_POSSIBLE && (BCMA = y || BCMA = B43)) && (SSB_POSSIBLE && (SSB = y || SSB = B43))
>
> to avoid the case where b43 is y and ssb or bcma is m.
> Or did I miss something and this is caught elsewhere?

Oh, wait, I think I meant B43_BUSES_BCMA_AND_SSB to select BCMA and
SSB (so user doesn't have to enable BCMA and SSB on his own). It it
the way it's handled without my patch (B43 select-s SSB).

I'd like to add
select BCMA
select SSB
, but this won't guarantee BCMA (or SSB) being "y" after choosing B43
to "y". Or will it?

Any idea how to handle that?
