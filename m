Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35551 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbHYRra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 13:47:30 -0400
Received: by wicne3 with SMTP id ne3so22328333wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2015 10:47:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440495409.2192.16.camel@sipsolutions.net>
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
 <1439983495.2089.7.camel@sipsolutions.net> <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com>
 <1440007745.2089.11.camel@sipsolutions.net> <CAEnVuW0m5jPMcQnC4inVF+8xubZbuyM-faP6Lebz26jvb4s-XA@mail.gmail.com>
 <1440013262.2089.13.camel@sipsolutions.net> <CAEnVuW21Ocie0RUGv-UZU1U=n=mTinJ_nJa2uHQqVZz-11AbWA@mail.gmail.com>
 <1440014031.2089.14.camel@sipsolutions.net> <CAEnVuW3LHHDUpJzaKoDAcYkBoT8B5ddQM2Va33xtxA-ORgLH3w@mail.gmail.com>
 <CAEnVuW28F2g_x65UzvH-RGpLON+YR2KoJ7dM=3j7gP11VJ8WEg@mail.gmail.com> <1440495409.2192.16.camel@sipsolutions.net>
From: Allan Matthew <allanm84@gmail.com>
Date: Tue, 25 Aug 2015 10:47:09 -0700
Message-ID: <CAEnVuW1FiS+DX-TUC4iQkutgE1U3k9Os-xqGgBAOBxich0xbtg@mail.gmail.com> (sfid-20150825_194733_542171_91E810F1)
Subject: Re: set channel from radiotap headers during injection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2015 at 2:36 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> It's ... complicated. First of all, it's currently not supported I
> believe, in general, since there's no parsing code. Obviously, parsing
> code can be changed, and I think there might even be patches floating
> around for that.

Adding this into the parse_tx_radiotap() is pretty trivial, I've added
MCS and legacy bitrate, FEC, SGI and STBC controls already.  I just
don't quite know where to put transmit power.

> However, not all hardware supports per-frame TX power control. Some
> might, most will not. Until fairly recently, there was also no API with
> drivers to allow setting TX power per frame. This changed with the
> addition of TX power control to rate control, of course.

I'm currently working with ath9k.  It appears that it supports
per-frame power control, although I'm still familiarizing myself.

Where would I stick the transmit power control?  In the
ieee80211_tx_info->control somewhere, or maybe in the
ieee80211_tx_info->rate_driver_data?
