Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61495 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0KCApG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 20:45:06 -0400
Received: by ywc21 with SMTP id 21so61664ywc.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 17:45:05 -0700 (PDT)
Message-ID: <4CD0B0AC.4050102@lwfinger.net>
Date: Tue, 02 Nov 2010 19:45:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>	<4CCF7B73.7040906@lwfinger.net>	<4CCF7EFC.1050000@mandriva.com.br>	<AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>	<4CD0A583.40105@lwfinger.net> <AANLkTin937V6hJ4L2o-SF5riTh0MpTd3e6faZnbZuV48@mail.gmail.com>
In-Reply-To: <AANLkTin937V6hJ4L2o-SF5riTh0MpTd3e6faZnbZuV48@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2010 07:01 PM, Rogerio Luz Coelho wrote:
 No effect is better than "regression" right?
> 
> I am not saying the chip got magically better, it still seems a cheap
> POS, but with Cascardo's patch is as good as the Win7 driver here.

If you apply Herton's series of 9 patches, you should see a throughput
improvement. On my card, I get full performance from the 54M rate (27 Mb/s),
whereas the best I could do before those patches was 11 Mb/s.

Incidentally, making the Realtek drivers work on x86_64 is not that difficult.
In any place that they cast a pointer as (u32), that gets changed to
(__kernel_size_t). The other place that is affected is due to changes in the skb
buffer parameters tail and data, which are pointers in 32-bit, and offsets in
64-bit systems. The main point is that you cannot ignore any gcc warnings.

Larry
