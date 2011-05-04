Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62978 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1EDN6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 09:58:08 -0400
Received: by eyx24 with SMTP id 24so359368eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 06:58:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Subject: Re: carl9170.ko RX - DMA, TX - COPY.
Date: Wed, 4 May 2011 15:58:00 +0000
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <BANLkTiniamP_zXeGkW2TgatdkSv1+rdfeg@mail.gmail.com> <BANLkTi=gvwkV=JstvtkAFPzU481mKQWtiA@mail.gmail.com> <BANLkTinC6ngn=ihLy2Y3Zx_qSKKCZVyNDw@mail.gmail.com>
In-Reply-To: <BANLkTinC6ngn=ihLy2Y3Zx_qSKKCZVyNDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105041558.00377.chunkeey@googlemail.com> (sfid-20110504_155813_181541_E06FC31A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 May 2011 12:31:45 Andrew V. Stepanov wrote:
> I think main problem is unaligment skbuff.
> But, I don't know how to fix this.
> 
well, you can't really fix it, unless musb now allows unaligned dma.
AR9170 has its own rules about alignment and in this case they
clash with the ones of your system.

What you could do: enable WDS or play around with NET_IP_ALIGN 0 if
your arch supports it [unlikely, given that it is an ARM]

Regards,
	Chr
