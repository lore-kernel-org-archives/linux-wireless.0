Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58370 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2BJA4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 19:56:48 -0500
Received: by iacb35 with SMTP id b35so3272311iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 16:56:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328834790.5067.2.camel@dcbw.foobar.com>
References: <1328837032-26137-1-git-send-email-stas.yakovlev@gmail.com>
 <CAGRGNgWVsGt08gxoyaoG7sG7NgubF+qqjk=LaCruRJiUe1fuig@mail.gmail.com> <1328834790.5067.2.camel@dcbw.foobar.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Feb 2012 11:56:26 +1100
Message-ID: <CAGRGNgXWuSxQ=oUg7hgU=uTuae7x3nb28Je5vj2WKoHyHzARuA@mail.gmail.com> (sfid-20120210_015651_253585_15282010)
Subject: Re: [PATCH] ipw2x00: remove ipw2100_rates_11b[]
To: Dan Williams <dcbw@redhat.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Fri, Feb 10, 2012 at 11:46, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2012-02-10 at 11:26 +1100, Julian Calaby wrote:
>> Hi Stanislav,
>>
>> On Fri, Feb 10, 2012 at 12:23, Stanislav Yakovlev
>> <stas.yakovlev@gmail.com> wrote:
>> > It's just a duplicate of ipw2100_bg_rates[].
>>
>> Looks sensible to me.
>
> Except that the 2100 is a B-only device; it doesn't do G at all.  So
> wouldn't it make sense to get rid of ipw2100_rates_bg[] instead?

The extra data in ipw2100_bg_rates[] is used when setting up the wiphy
bands, ipw2100_rates_11b[] is just ipw2100_bg_rates[].bitrate * 100 *
1000.

The cards may not support G, but that doesn't mean the structure can't
be named as if they do. Looking at the driver, it seems that whoever
wrote the band handling code just lumped B and G together and only
used B rates.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
