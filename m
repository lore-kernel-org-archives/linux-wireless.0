Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50638 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1LPGbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 01:31:12 -0500
Received: by wgbdr13 with SMTP id dr13so5574409wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 22:31:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4eea214d.h4TAGuC6+eReskdR%francesco.gringoli@ing.unibs.it>
References: <4eea214d.h4TAGuC6+eReskdR%francesco.gringoli@ing.unibs.it>
Date: Fri, 16 Dec 2011 07:31:11 +0100
Message-ID: <CACna6rytRwpmnj8EofBi99-+teWGyEyc27Gv+K1qQPni3BZZLQ@mail.gmail.com> (sfid-20111216_073116_211595_617C2BB6)
Subject: Re: [PATCH V2] b43: avoid packet losses in the dma worker code.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: francesco.gringoli@ing.unibs.it
Cc: m@bues.ch, linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, michele.orru@hotmail.it,
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
> The patch also introduces separate workers for each hardware queue
> and dedicated buffers where storing packets from mac80211 before sending
> them down to the hardware. Using different workers let bandwidth be
> perfectly shared among the queues according to contention window parameters
> defined at the air interface (EDCA settings).
>
> Number of hardware queues is now defined in b43.h (B43_QOS_QUEUE_NUM).

Thanks for your changes Francesco. Funny, checkpatch doesn't detect
 braces were used for single-line instructions. Generally it looks fine
 :)

 I still would like to take a look at this solution in comparison to
 single worker. So let me repeat me request: do you still have patch
 implementing 1 worker solution? Could you share it?

-- 
Rafał
