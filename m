Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dewberryfields.co.uk ([217.41.92.67]:45618 "EHLO
	mail.dewberryfields.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaEORUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:20:42 -0400
Message-ID: <5374F638.6000505@dewberryfields.co.uk> (sfid-20140515_192045_220941_2317CF3C)
Date: Thu, 15 May 2014 18:15:36 +0100
From: Michael Howard <mike@dewberryfields.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Mwifiex driver on Globalscale Mirabox
References: <5346DED8.2030704@free.fr>
	<CAJwzM1k=OOBa7C3u0+TzmRUBwMYfJSMgB+smbORfKmPE6KnF2g@mail.gmail.com>
	<53480138.2080805@free.fr>	<53733AB4.7010500@free.fr>
	<20140514215126.GA15419@us.netrek.org>
 <CAJwzM1k+75qRJaONyehMNPaOqOHyBhryMGBtZ4NpD6jGHk-cHQ@mail.gmail.com>
In-Reply-To: <CAJwzM1k+75qRJaONyehMNPaOqOHyBhryMGBtZ4NpD6jGHk-cHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 15/05/2014 15:06, Avinash Patil wrote:
> Hi James/Anthony,
>
> If an unsupported command is downloaded to FW, it results into command
> response not supported - code 0x2.
> It wouldnt result into command timeout.
> According to our internal discussions, this issue is seen only on
> Globalscale mirabox where SDIO controller is mvsdio.
>
> "On Mirabox the SDIO controller is mvsdio. It polls for interrupts but
> polling itself doesn’t seem to be the problem.
> In the log, I got from another person it seems that there is no
> SDIO_INT bit in controller “intr” register after scan command is sent.
> Other commands are fine, only scan commands fail. I don’t why scan
> (0x06 or 0x107) is special in this case."
>
> Hi Anthony,
>
> Could you please enable dynamic debug on mwifiex, mwifiex_sdio &
> mvsdio driver; this will confirm if this is same issue.
>
> Thanks,
> Avinash.
>
Using kernel 3.15.0-rc5, starting hostapd results in;

May 15 17:11:04 mirabox kernel: mwifiex_sdio mmc0:0001:1: CMD_RESP: cmd 
0x112 error, result=0x2

hostapd runs but there in no AP.

If I can be of any help testing/debugging just say so.

Cheers,
Mike.

-- 


