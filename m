Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:31710 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZKHR7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 12:59:22 -0500
Received: by ey-out-2122.google.com with SMTP id 25so32270eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 09:59:27 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] rt2x00: fix build of rt2800lib
Date: Sun, 8 Nov 2009 18:31:43 +0100
Cc: IvDoorn@gmail.com, gwingerde@gmail.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1257682021-23810-1-git-send-email-hauke@hauke-m.de> <200911081325.23424.bzolnier@gmail.com> <4AF6C74A.4020208@hauke-m.de>
In-Reply-To: <4AF6C74A.4020208@hauke-m.de>
MIME-Version: 1.0
Message-Id: <200911081831.43381.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 14:27:38 Hauke Mehrtens wrote:
> Hi,
> 
> I am building recent wireless-testing. Without my patch I get the
> following error while compiling it with CONFIG_RT2800USB=y with
> CONFIG_RT2800USB=m it compiles fine without any modifications. Looks
> like there is an other problem and my patch does not fix the real problem.

I've reproduced it here and your patch is fine but it would be better
if rt2x00usb.h would include <linux/usb.h> itself instead of depending on
its users (device drivers) but I'll leave this decision up to Ivo/Gartjan.

I've fixed the issue in the patch introducing the problem ("rt2800: add
rt2800lib (part three)") to preserve bisectability of rt2800usb driver.

Thanks.
-- 
Bartlomiej Zolnierkiewicz
