Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60045 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002Ab2AMVxB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 16:53:01 -0500
Received: by obcva7 with SMTP id va7so2768993obc.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2012 13:53:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120113192027.GE18899@tuxdriver.com>
References: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
 <CACna6rxffpPhYVqKNttu79JET=NkBP4NrAayywQHWcj=mw=T9A@mail.gmail.com>
 <CAGRGNgUkBUvoBJydcdprBXP0ufR+PQ6nXFXdW546xjHbQ-O2Bg@mail.gmail.com> <20120113192027.GE18899@tuxdriver.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 14 Jan 2012 08:52:38 +1100
Message-ID: <CAGRGNgWCwd4hN3B4znP7BimEzy15SyJHnFLTmz=y65CtXHa6ng@mail.gmail.com> (sfid-20120113_225309_639681_A007C8DE)
Subject: Re: [PATCH] b43: add default option to avoid duplicating device
 support with brcmsmac
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

On Sat, Jan 14, 2012 at 06:20, John W. Linville <linville@tuxdriver.com> wrote:
> On Fri, Jan 13, 2012 at 01:07:03PM +1100, Julian Calaby wrote:
>> 2012/1/13 Rafał Miłecki <zajec5@gmail.com>:
>> > 2012/1/11 John W. Linville <linville@tuxdriver.com>:
>> >> +config B43_BCMA_EXTRA
>> >> +       bool "Support for devices also supported by brcmsmac"
>> >> +       depends on B43_BCMA
>> >> +       default n
>> >> +
>> >
>> > Is this really *the* solution? I wonder if we can do whatever you're
>> > trying to do in a better way? To let final users try both drivers
>> > without recompiling kernel?
>>
>> Another issue is that this should arguably be default y if brcmsmac is disabled.
>
> Can you help by suggesting the correct Kconfig magic to implement that?

I believe that if you change your default line to:

default y if !BRCMSMAC

it should have the desired effect.

See the FONT_8x8 config option in drivers/video/console/Kconfig (line
#150) for an example.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
