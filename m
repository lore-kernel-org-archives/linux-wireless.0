Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:57331 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3EETWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 15:22:50 -0400
Received: by mail-qa0-f45.google.com with SMTP id hu16so1137203qab.18
        for <linux-wireless@vger.kernel.org>; Sun, 05 May 2013 12:22:49 -0700 (PDT)
Message-ID: <5186B186.7090703@lwfinger.net> (sfid-20130505_212304_707651_B6749893)
Date: Sun, 05 May 2013 14:22:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Thommy Jakobsson <thommyj@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	m@bues.ch, piotras@gmail.com
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net> <CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com> <CACna6rwk0akD0x+sWTmjDDoaQqF0Y=NQ58rzqgZH92GCug6CeQ@mail.gmail.com>
In-Reply-To: <CACna6rwk0akD0x+sWTmjDDoaQqF0Y=NQ58rzqgZH92GCug6CeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2013 10:43 AM, Rafał Miłecki wrote:
>
> Interesting part is that they write amount of slots + slot index to
> the B43_DMA32_RXINDEX (like 0x120 instead of 0x20). May be worth
> investigating.

Getting that behavior from wl might be useful, but their response to an 
interrupt with bit 13 set will not be of much help. Whenever that occurs, they 
reinitialize the device, and do not try a recovery.

Larry

