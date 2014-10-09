Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56465 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIRP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 13:15:29 -0400
Date: Thu, 9 Oct 2014 10:15:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bcma: Add dependency on OF_ADDRESS
Message-ID: <20141009171523.GA2410@roeck-us.net> (sfid-20141009_191604_919847_267D5E0F)
References: <1412872877-1771-1-git-send-email-linux@roeck-us.net>
 <CACna6rzOeGcKrrftLx_3uWe_bAXQaQMmWb3wWHP0CjtdO8D0eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzOeGcKrrftLx_3uWe_bAXQaQMmWb3wWHP0CjtdO8D0eg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 09, 2014 at 06:54:48PM +0200, Rafał Miłecki wrote:
> On 9 October 2014 18:41, Guenter Roeck <linux@roeck-us.net> wrote:
> > Commit 2101e533f41a ("bcma: register bcma as device tree driver")
> > introduces a hard dependency on OF_ADDRESS into the bcma driver.
> > OF_ADDRESS is specifically disabled for the sparc architecture.
> > This results in the following error when building sparc64:allmodconfig.
> 
> Won't this make bcma im-POSSIBLE on MIPS? And maybe x86(_64), or at
> least add an unneeded dependency? I think we should somehow limit this
> to BCM5301X arch.

sparc, not mips.

Something like "depends on !OF || OF_ADDRESS" would limit the impact to
sparc, and only if OF is configured as well. I'll update accordingly
and resubmit. Everything else would have to be done in the driver itself,
which I rather not touch myself.

Guenter
