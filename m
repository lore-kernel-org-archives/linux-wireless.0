Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:44032 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab3EWQdx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 12:33:53 -0400
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.80.1 #3)
	id 1UfYHC-0001Ha-Ht
	for linux-wireless@vger.kernel.org; Thu, 23 May 2013 18:22:02 +0200
Received: from localhost ([::1]:47790 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.80.1 #3)
	id 1UfYHC-0007vd-AK
	for linux-wireless@vger.kernel.org; Thu, 23 May 2013 18:22:02 +0200
Received: from [195.4.92.16] (port=36526 helo=6.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.80.1 #3)
	id 1UfYEC-00007r-70
	for linux-wireless@vger.kernel.org; Thu, 23 May 2013 18:18:56 +0200
Received: from p4fde1c80.dip0.t-ipconnect.de ([79.222.28.128]:42629 helo=mail.maya.org)
	by 6.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:DHE-RSA-AES256-SHA:256) (port 25) (Exim 4.80.1 #3)
	id 1UfYEB-0008SN-RT
	for linux-wireless@vger.kernel.org; Thu, 23 May 2013 18:18:56 +0200
Message-ID: <519E4158.2060600@01019freenet.de> (sfid-20130523_183406_514947_9322C179)
Date: Thu, 23 May 2013 18:18:32 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Mohit <mt1037ag11@pdm.ac.in>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Ralink RT3290 proprietary drivers causing kernel panic
References: <519D0D44.1040901@pdm.ac.in> <14ECE0C4-AE53-4CC5-B6B6-42930C2C26FB@gmail.com> <519E09BE.6060802@pdm.ac.in>
In-Reply-To: <519E09BE.6060802@pdm.ac.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohit wrote:
[...]
> The drivers work in kernel 3.2 but stop working from either kernel ver.
> 3.3, 3.4 or 3.5.

>From my experience, it seems more to be a compiler / binutils problem:

See
http://news.gmane.org/find-root.php?group=gmane.linux.drivers.rt2x00.user&article=1765

> The drivers included in the kernel work, but they are a buggy, have low
> range, connection drops etc.

Exactly my experience here, especially the USB ones (but seems to be
heavily hardware dependent). And they produce enormous cpu load as soon
as throughput rises.

That's why I'm only using the vendor driver (for STA), too (besides the
point that rt2800usb doesn't support a Linksys AE3000 at all e.g.
(http://wikidevi.com/wiki/Linksys_AE3000), which is a really fine device!)

> I switched from Linux mint 13 kernel 3.2, installed the proprietary
> driver and it is way better than rt2800pci drivers interms of signal
> strength, latency, speed etc. I think the proprietary drivers use
> rt2860pci driver instead of a dedicated rt3290sta driver.
> 
> Can the drivers included in the kernel be tweaked to match the
> proprietary driver?

It would be cool on the one hand, if Mediatek would integrate their own
drivers themselves to mac80211, but on the other hand, I fear, this is
mostly impossible because mac80211 (which was heavily built for and from
Atheros and Intel and therefore "optimized" for there own needs) doesn't
match the requirements of the Ralink hardware.

That's why I'm happy they don't integrate their drivers in the existing
mac80211 because I fear a likewise bad quality.


I think the maintainer of rt2800 do all they can given the opportunities
they have so far. Unfortunately, they have very little opportunities
from my point of view.



Kind regards,
Andreas
