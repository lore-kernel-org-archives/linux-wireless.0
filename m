Return-Path: <SRS0=v6pW=XO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E5BC3A5A6
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 09:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89D7D2196E
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 09:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="USvraGNP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Qm5yKpp8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389029AbfISJu6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:50:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40884 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388872AbfISJu6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Sep 2019 05:50:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 31E4961359; Thu, 19 Sep 2019 09:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568886657;
        bh=I55K3nBeZJfFZkk97+0qM6fkrU2I6GrKyjKmHvHvsRM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=USvraGNPIkGV+y6ZnillN/Jqmt7xWr0MSkBqQ+J8bTMRugpVudA5OpxgdaYKnieQP
         VYbgSeOQA66x/9P2YlY57AO6vDjFKwSYI0KjaGRU086aH2Z7ZLH3XRLWzsCUMVpVzD
         r20Uvys4jqWRAFo83Hvu96Hll23T+l/OORUfDZ/k=
Received: from x230.qca.qualcomm.com (37-136-106-186.rev.dnainternet.fi [37.136.106.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D53D602F8;
        Thu, 19 Sep 2019 09:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568886656;
        bh=I55K3nBeZJfFZkk97+0qM6fkrU2I6GrKyjKmHvHvsRM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Qm5yKpp8jxl67lbOId5ADtKAS27CuOw4wb/J51a5wf1fKA5ytEx1ItRh7aoEusgWd
         gYoVwE7gJ2HXk5vgHkAawHZkmBGkzlNI7cJ9Oye7TCCVMxZGs5pPqZULz66BntiayL
         zjDXNj+bhRr8Pfn2+A/NW5h6AGUx2bqIyop5VXKI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4D53D602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -net] zd1211rw: zd_usb: Use "%zu" to format size_t
References: <20190919091532.24951-1-geert@linux-m68k.org>
Date:   Thu, 19 Sep 2019 12:50:50 +0300
In-Reply-To: <20190919091532.24951-1-geert@linux-m68k.org> (Geert
        Uytterhoeven's message of "Thu, 19 Sep 2019 11:15:32 +0200")
Message-ID: <87h858ehs5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On 32-bit:
>
>     drivers/net/wireless/zydas/zd1211rw/zd_usb.c: In function =E2=80=98ch=
eck_read_regs=E2=80=99:
>     drivers/net/wireless/zydas/zd1211rw/zd_def.h:18:25: warning: format =
=E2=80=98%ld=E2=80=99 expects argument of type =E2=80=98long int=E2=80=99, =
but argument 6 has type =E2=80=98size_t=E2=80=99 {aka =E2=80=98unsigned int=
=E2=80=99} [-Wformat=3D]
>       dev_printk(level, dev, "%s() " fmt, __func__, ##args)
> 			     ^~~~~~~
>     drivers/net/wireless/zydas/zd1211rw/zd_def.h:22:4: note: in expansion=
 of macro =E2=80=98dev_printk_f=E2=80=99
> 	dev_printk_f(KERN_DEBUG, dev, fmt, ## args)
> 	^~~~~~~~~~~~
>     drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1635:3: note: in expansi=
on of macro =E2=80=98dev_dbg_f=E2=80=99
>        dev_dbg_f(zd_usb_dev(usb),
>        ^~~~~~~~~
>     drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1636:51: note: format st=
ring is defined here
> 	 "error: actual length %d less than expected %ld\n",
> 						     ~~^
> 						     %d
>
> Fixes: 84b0b66352470e64 ("zd1211rw: zd_usb: Use struct_size() helper")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

I'll queue this for v5.4.

--=20
Kalle Valo
