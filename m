Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53536 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3DMS7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Apr 2013 14:59:40 -0400
Received: by mail-we0-f174.google.com with SMTP id u12so2780209wey.5
        for <linux-wireless@vger.kernel.org>; Sat, 13 Apr 2013 11:59:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365869899.1089.0.camel@jlt4.sipsolutions.net>
References: <1365849071-2389-1-git-send-email-jogo@openwrt.org>
	<CAJ-VmokacZUw1Wru_0w1XaVRoZWP6nOMcdKo=1yhP-C9rbifHg@mail.gmail.com>
	<1365869899.1089.0.camel@jlt4.sipsolutions.net>
Date: Sat, 13 Apr 2013 11:59:39 -0700
Message-ID: <CAJ-Vmo=bwcxRHB2vESVAy-3_svM+7dDj3o5D=bWgAedMV0ZsBA@mail.gmail.com> (sfid-20130413_205944_520924_DAD587C5)
Subject: Re: [RFC/RFT] mwl8k: don't expose non-standard rates
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jonas Gorski <jogo@openwrt.org>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 April 2013 09:18, Johannes Berg <johannes@sipsolutions.net> wrote:

>> Are these "turbo" mode rates? ie, 40MHz wide channels with pre-11n
>> rates on them?
>
> 22 actually *is* a standard rate, it's just that almost nobody
> implements it.

Well, is it the 20mhz rate or a 40mhz turbo rate?

> The original problem seems a bit strange though, seems those should just
> not be marked basic?

Again, if its a custom rate for 11a/11g 40MHz static turbo style
configurations, it should only be exposed when the AP is running in
that particular mode.

And yes, if the hardware does support it, then it should really only
not be configured for basic rates. That way mwl8k<->mwl8k hardware can
take advantage of it when those stations are talking to each other.

(Yeah, I come from a world where FreeBSD users still want to run
Turbo/Static-40MHz operation with things like fast frames and turbo
rates.. damned legacy hardware. :-)



Adrian
