Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:50245 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbYLTFrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:47:51 -0500
Message-ID: <494C8705.2030407@lwfinger.net> (sfid-20081220_064811_762774_DFDBF24E)
Date: Fri, 19 Dec 2008 23:47:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] p54usb: fix random traffic stalls (LM87)
References: <200812200221.56534.chunkeey@web.de>
In-Reply-To: <200812200221.56534.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> All LM87 firmwares need a explicit termination "packet",
> in oder to finish the pending transfer properly.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> Larry,
> 
> Does your test case still fail with this one?

No, it seems to be fixed. I still have a failure, but the symptoms are different.

Today I had created the following script:

#! /usr/bin/perl
#
for ($i = 30; $i < 1600 ; $i++) {
        `ping -c 1 -s $i my_server`;
        printf ("%d\n ", $i);
}

I found that this script stalled for i of 372, 884 and 1396. I was still trying
to find it it was a transmit or receive problem when your patch arrived. With
this change, the ping script runs to completion, and my NFS compile ran a lot
longer than previously.

When the connection failed, unloading the driver and reloading it yielded the lines

usb 1-5: (p54usb) reset failed! (-22)
p54usb: probe of 1-5:1.0 failed with error -22

In my estimation, I think the patch is clearly needed and should be pushed.

Larry

