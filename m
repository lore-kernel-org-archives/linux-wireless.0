Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51166 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab1LOL3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 06:29:11 -0500
Received: by wgbdr13 with SMTP id dr13so3905627wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 03:29:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ee9d496.ZmxUcTz7IvcMM2Tq%francesco.gringoli@ing.unibs.it>
References: <4ee9d496.ZmxUcTz7IvcMM2Tq%francesco.gringoli@ing.unibs.it>
Date: Thu, 15 Dec 2011 12:29:10 +0100
Message-ID: <CACna6rxc9HPWg7VekDr7LFSZp7wMCinsvao-LxEEHnrD95HCig@mail.gmail.com> (sfid-20111215_122914_800234_96226408)
Subject: Re: [PATCH] b43: avoid packet losses in the dma worker code.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: francesco.gringoli@ing.unibs.it
Cc: m@bues.ch, linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	michele.orru@hotmail.it, b43-dev@lists.infradead.org,
	riccardo.paolillo@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/15  <francesco.gringoli@ing.unibs.it>:
> This patch addresses a bug in the dma worker code that keeps draining
> packets even when the hardware queues are full. In such cases packets
> can not be passed down to the device and are erroneusly dropped by the
> code.
>
> This problem was already discussed here
>
> http://www.mail-archive.com/b43-dev@lists.infradead.org/msg01413.html
>
> and acknowledged by Michael.
>
> The patch also introduces separate workers for each hardware queues
> and dedicated buffers where storing packets from mac80211 before sending
> them down to the hardware.

Have you considered just a one worked iterating over queues?

I'm not sure if it's efficient to have so many workers, each can be
stopped&resumed, each is taking wl mutex...

-- 
Rafał
