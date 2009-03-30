Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:27223 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZC3N75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 09:59:57 -0400
Received: by yx-out-2324.google.com with SMTP id 31so1980635yxl.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 06:59:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <231862.66787.qm@web52408.mail.re2.yahoo.com>
References: <231862.66787.qm@web52408.mail.re2.yahoo.com>
Date: Mon, 30 Mar 2009 09:59:55 -0400
Message-ID: <b6c5339f0903300659l2e67b511kb13906ead0fc415a@mail.gmail.com> (sfid-20090330_160002_792667_A515E179)
Subject: Re: ath5k kernel oops
From: Bob Copeland <me@bobcopeland.com>
To: Joo Aun Saw <jasaw81@yahoo.com.au>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 29, 2009 at 10:37 PM, Joo Aun Saw <jasaw81@yahoo.com.au> wrote:
> Hello,
>
> I'm getting kernel oops when modprobe ath5k on kernel 2.6.29 on ARM
> big-endian platform. PCI card is Atheros AR5413 168c:001b (rev 01).

Your kernel is tainted due to the ixp400 module.  I doubt it matters in
this case, but you should generally try to provide oopses on untainted
kernels or else people may just ignore it.

> [42949474.280000] Bad mode in data abort handler detected
> [42949474.280000] Internal error: Oops - bad mode: 0 [#1]

I don't know arm architecture enough to know quite what that means...

> [42949474.280000] Backtrace:
> [42949474.280000] [<bf2d5eb4>] (ath5k_hw_register_timeout+0x0/0xcc [ath5k]) from [<bf2d645c>] (ath5k_hw_nic_reset+0x17c/0x2bc [ath5k])
> [42949474.280000] [<bf2d62e0>] (ath5k_hw_nic_reset+0x0/0x2bc [ath5k]) from [<bf2d6778>] (ath5k_hw_nic_wakeup+0x1dc/0x570 [ath5k])

I think it's an endianness issue -- ath5k probably hasn't seen much testing on
BE platforms.

ath5k_hw_register_timeout polls a register in a loop waiting for a specific
bit to be set or cleared (this happens e.g. while calibrating the card).
The problem is ioread32 will return an le32 but as far as I can tell we
just assume it is native endianness.

I don't have an appropriate platform available, would you be willing to test
patches?

-- 
Bob Copeland %% www.bobcopeland.com
