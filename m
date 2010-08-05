Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61354 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab0HEVGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 17:06:03 -0400
Received: by vws3 with SMTP id 3so5486673vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 14:06:02 -0700 (PDT)
Message-ID: <4C5B27BE.8010708@lwfinger.net>
Date: Thu, 05 Aug 2010 16:06:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Interesting development regarding b43 DMA ERROR
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yesterday, I had to go back to kernel 2.6.34 for a test of code to avoid ssb
load freezeups on my HP Mini 110 Netbook, which has the SPROM at offset 0x0800,
not 0x1000. As I had been using b43 for this BCM4312 (14e4:4315) card in DMA
mode without any problems, I was quite surprised to see the dreaded DMA errors.
I had attributed the lack of errors with wireless testing to be due to the AMI,
not Phoenix, BIOS in this machine. When I switched to mainline ('git describe'
reports it as v2.6.35-3370-gcdd854b), again it works.

AFAIK, none of any fixes that were put into wt to try to solve this problem had
any affect, yet the device now works here.

Is anyone else that had/has the DMA problem running 2.6.35 + updates from the
linux-2.6.git tree? If so, does your BCM4312 now work with b43, or is my box
special?

Larry
