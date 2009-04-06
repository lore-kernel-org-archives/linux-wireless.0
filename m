Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:34943 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbZDFLrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 07:47:09 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] p54spi: get rid of busy-wait loops
Date: Mon, 6 Apr 2009 13:47:06 +0200
Cc: linux-wireless@vger.kernel.org
References: <> <200904060030.25425.chunkeey@web.de> <200904060916.03555.jcmvbkbc@gmail.com>
In-Reply-To: <200904060916.03555.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904061347.06042.chunkeey@web.de> (sfid-20090406_134714_325491_2BF7551B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 April 2009 07:16:02 Max Filippov wrote:
> >
> > By the way a few days ago the libertas driver authors posted a patch
> > which "improve the average throughput 13%."
> >
> > http://marc.info/?l=linux-wireless&m=123871643203161
> >
> > I wonder if this would also work with p54spi.
> > But to test this theory, one has to rewrite the driver to use kthread
> > instead of hogging workqueues.... just in case you're looking for more
> > TODOs ;-)
> I'm just getting it to work. And there are still problems in tx path, e.g.
> it cannot withstand dd if=/dev/zero | ssh ... "cat >/dev/null".

hmm, sounds familiar. 
(" p54usb: fix random traffic stalls (LM87)" (43af18f06d5
and p54usb: fix packet loss with first generation devices  ")

can you please run
for ((size=0; size < 9000;size++)); do ping $IP -s $size

and see if there's a connection between the stalls/hangs and the frame length?

Regards,
	Chr
