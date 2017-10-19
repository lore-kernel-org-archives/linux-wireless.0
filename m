Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42854 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752364AbdJSTKB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 15:10:01 -0400
Received: from mail-io0-f200.google.com ([209.85.223.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1e5GCe-0008Pd-4d
        for linux-wireless@vger.kernel.org; Thu, 19 Oct 2017 19:10:00 +0000
Received: by mail-io0-f200.google.com with SMTP id n33so8554153ioi.7
        for <linux-wireless@vger.kernel.org>; Thu, 19 Oct 2017 12:10:00 -0700 (PDT)
Date: Thu, 19 Oct 2017 14:09:57 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: =?utf-8?B?0JDQvdC00YDQtdC5INCY0LLQsNC90L7Qsg==?= <wowz89@mail.ru>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: Update regulatory rules for Kazakhstan (KZ) on
 5GHz
Message-ID: <20171019190957.fvjqwgwbxzjv6edz@ubuntu-hedt> (sfid-20171019_211005_170355_251B1F3E)
References: <1508325977.297437473@f42.i.mail.ru>
 <20171018184900.nycqbsqbwwfnyuzu@ubuntu-xps13>
 <1508380132.687331572@f226.i.mail.ru>
 <1508432054.240009473@f105.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1508432054.240009473@f105.i.mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 19, 2017 at 07:54:14PM +0300, Андрей Иванов wrote:
> Hello again perirenal forums and laws of Kazakhstan on the 5GHz and everywhere one answer permitted use indoors frequency 5150-5350 and 5470-5725 MHz details there is no law painted as is done in other countries. Please add to this range in Kazakhstan is possible in the future and will develop in more detail the law on wi-fi 5 GHz, but currently it is what it is.

So, based on the doucment you linked to and one given earlier
(http://adilet.zan.kz/rus/docs/P000001379_) I'll send a paatch to allow
5150-5350 adn 5470-5725 MHz. However I think the power limit for all the
rules needs to be limited to 100mW instead of 1W as you had in some of
them, and we need to add the NO-OUTDOOR flag.

One of the documents also refers to ITU Resolution 229 with regard to
the 5GHz ranges, so I do think DFS is necessary in some of the ranges.

I'll follow up with a patch shortly.

> >Четверг, 19 октября 2017, 8:28 +06:00 от Андрей Иванов <wowz89@mail.ru>:
> >
> >Yes, I saw the frequencies wrong, but according to the documentation, you can add support for the frequencies 5150-5350 and 5470-5725 MHz, so that the phones on the Androyd started seeing Wi-fi 5GHz? or are our legislative acts not extinguishing you?
> >
> >I'm just not strong in all of your terms, but my phone does not see wi-fi 5GHz and with support we figured out that due to the fact that it does not exist in wireless-regdb it will not see it.
> >
> >
> >>Четверг, 19 октября 2017, 0:49 +06:00 от Seth Forshee < seth.forshee@canonical.com >:
> >>
> >>On Wed, Oct 18, 2017 at 07:44:54PM +0300, Андрей Иванов wrote:
> >>> 
> >>> In accordance with the communications act ( in the attachment) official source the government website mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
> >>> on page 16 in paragraph 23 outlines that we can use frequency 5150–5350МГц 5470-5725 MHz indoor. It's an official order approved by the government also exert its scan where you can see all the printing and painting reference on the Internet  http://adilet.zan.kz/rus/origins/V1500010730  
> >>
> >>Any reason you dropped the mailing lists from your reply?
> >>
> >>A few notes/questions:
> >>
> >>1. We'll need to add the NO-OUTDOOR flag to the 5150-5350 and 5470-5725
> >>   MHz ranges.
> >>
> >>2. I don't see anything about using DFS in the ranges where you have
> >>   that. It's not unreasonable that this would be required, but I'm
> >>   wondering whether I'm missing that or if there's someplace else which
> >>   specifies this is needed?
> >>
> >>3. I don't see anything about using frequencies above 5725 MHz.
> >>
> >>4. The regulatory db is for unlicensed spectrum only. I'm reading a
> >>   google translation of the document so I'm having a hard time being
> >>   sure of what it says, but I do see a lot of references to permits or
> >>   licenses. Can the spectrum you're trying to add be used without
> >>   obtaining a permit or license?
> >>
> >>Thanks,
> >>Seth
> >>
> >>> 
> >>> >Среда, 18 октября 2017, 19:50 +06:00 от Seth Forshee < seth.forshee@canonical.com >:
> >>> >
> >>> >On Wed, Oct 18, 2017 at 02:26:17PM +0300, Андрей Иванов wrote:
> >>> >> Please add support for 5 GHz in Kazakhstan
> >>> >>         (5170 - 5250 @ 80), (20), AUTO-BW
> >>> >> 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
> >>> >> 	(5650 - 5730 @ 80), (30), DFS
> >>> >> 	(5735 - 5835 @ 80), (30)
> >>> >
> >>> >We got a very similar submission not that long ago, and I had some
> >>> >questions which were never answered.
> >>> >
> >>> > http://lists.infradead.org/pipermail/wireless-regdb/2017-August/001086.html
> >>> >
> >>> >That one provided a link to some documentation for Kazakhstan, but the
> >>> >information there seemed incomplete to me. Can you answer the questions
> >>> >I asked there, or provide a link to a more complete source of
> >>> >information for the regulations in Kazakhstan?
> >>> >
> >>> >Thanks,
> >>> >Seth
> >>> 
> >>> 
> >>> С уважением,
> >>> Андрей Ивaнoв
> >>
> >>
> >>
> >
> >
> >С уважением,
> >Андрей Ивaнoв
> 
> 
> С уважением,
> Андрей Ивaнoв
