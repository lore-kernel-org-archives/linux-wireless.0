Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47067 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2JPVW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 17:22:28 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so3242611bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2012 14:22:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: Re: [PATCH v2 0/4] Driver for the ar5523 chipset
Date: Tue, 16 Oct 2012 23:22:20 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, hch@lst.de,
	s.L-H@gmx.de
References: <1350415769-8271-1-git-send-email-pontus.fuchs@gmail.com>
In-Reply-To: <1350415769-8271-1-git-send-email-pontus.fuchs@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201210162322.20703.chunkeey@googlemail.com> (sfid-20121016_232232_026487_4CAC4492)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, October 16, 2012 09:29:25 PM Pontus Fuchs wrote:
> Some time ago I found an old USB wireless dongle in my drawer. I was
> surprised it wasn't supported in Linux. Google gave me an old
> unfinished driver created by Christoph Hellwig. Armed with some
> spare time and naivity I picked up where Christoph left in 2007 and
> now it's actually working pretty fine. It does not crash for me and
> throughput is decent.
> 
> It's based on the FreeBSD driver, which in turn is based on the
> reverse engineered Windows driver, hence a very limited feature set.
> Not even HW crypto offload is supported. But at least there is a
> firmware which has a suitable license:
> 
> http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/contrib/dev/uath/ar5523.bin.uu
> 
> Changes v1 to v2:
> 
> * Bugfix: Avoid % 512 transfer sizes on TX as the FW will hang.
Have you tried setting "urb->transfer_flags |= URB_ZERO_PACKET;"
to your outgoing urbs? This might fix the hang as well and you
don't need any ugly skb_put.

Regards,
	Chr
