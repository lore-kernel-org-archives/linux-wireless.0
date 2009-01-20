Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f29.google.com ([209.85.219.29]:34477 "EHLO
	mail-ew0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbZATLpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 06:45:18 -0500
Received: by ewy10 with SMTP id 10so140065ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 03:45:15 -0800 (PST)
Message-ID: <4975B948.2010808@gmail.com> (sfid-20090120_124533_470660_05BD6257)
Date: Tue, 20 Jan 2009 12:45:12 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54usb: fix nasty use after free
References: <200901200027.57128.chunkeey@web.de>
In-Reply-To: <200901200027.57128.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> In theory, the firmware acks the received a data frame, before signaling the driver to free it again.
> However Artur Skawina <art.08.09@gmail.com> has shown that it can happen in reverse order as well.
> This is very bad and could lead to memory corruptions, oopses and panics.
> 
> Thanks to Artur Skawina <art.08.09@gmail.com> for reporting and debugging this issue.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> Anyone with a p54usb device (Especially you, Artur :-) ):
> 
> Please test this!
> Because it should go to wireless-2.6 / 2.6.29 as well (John?)

good news: i've run a few tests w/ it and didn't see any memory corruption warnings,
previously i used to get them almost immediately, usually during association, now
i was able to transfer ~1M of data w/ no sign of corruption.

The large packet loss is still there and the device is still unusable (because of
the extremely low throughput, that 1M took several minutes to transfer and three
attempts to associate before it worked). But no crashes, that's a huge improvement :)

Tested-by: Artur Skawina <art.08.09@gmail.com>

artur

