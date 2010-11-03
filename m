Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58341 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0KCBGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 21:06:23 -0400
Received: by vws13 with SMTP id 13so412177vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 18:06:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD0B0AC.4050102@lwfinger.net>
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>
	<4CCF7B73.7040906@lwfinger.net>
	<4CCF7EFC.1050000@mandriva.com.br>
	<AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>
	<4CD0A583.40105@lwfinger.net>
	<AANLkTin937V6hJ4L2o-SF5riTh0MpTd3e6faZnbZuV48@mail.gmail.com>
	<4CD0B0AC.4050102@lwfinger.net>
Date: Tue, 2 Nov 2010 23:06:22 -0200
Message-ID: <AANLkTinpJSKhf9PcG9bAPsLjVRKZ3bJEEK0-UQ4rpxJH@mail.gmail.com>
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/2 Larry Finger <Larry.Finger@lwfinger.net>:
> On 11/02/2010 07:01 PM, Rogerio Luz Coelho wrote:
>  No effect is better than "regression" right?
>>
>> I am not saying the chip got magically better, it still seems a cheap
>> POS, but with Cascardo's patch is as good as the Win7 driver here.
>
> If you apply Herton's series of 9 patches, you should see a throughput
> improvement. On my card, I get full performance from the 54M rate (27 Mb/s),
> whereas the best I could do before those patches was 11 Mb/s.
>
> Incidentally, making the Realtek drivers work on x86_64 is not that difficult.
> In any place that they cast a pointer as (u32), that gets changed to
> (__kernel_size_t). The other place that is affected is due to changes in the skb
> buffer parameters tail and data, which are pointers in 32-bit, and offsets in
> 64-bit systems. The main point is that you cannot ignore any gcc warnings.
>
> Larry

:) My biggest issue wasn't actually doing the patch, it was actually
compiling the damn thing on Ubuntu, that's what you get when you
install a distro that tells you in their kernel help page that they
don't WANT you to be able to compile your own kernel.

But as I said the connect - disconnect is gone.

I will try the new patches alone and with Cascardo's ... will post result here.

Rogerio
