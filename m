Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:64112 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab3DKJRU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 05:17:20 -0400
From: Szymon Janc <szymon.janc@tieto.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
CC: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: include/linux/device.h:715:38: error: 'THIS_MODULE' undeclared
Date: Thu, 11 Apr 2013 11:17:17 +0200
Message-ID: <3231828.tgzQTMkMFI@uw000953> (sfid-20130411_111726_125184_735769FF)
In-Reply-To: <CAFSJ42a5PsnbhgEaWWWZTBDVKhKUGR4xWY1pEXPc-UaQcC9AFA@mail.gmail.com>
References: <CAFSJ42ZZH7Y+MPUURG_hQRuwhv8UKkF5sQQebsTjhH0uT07rjA@mail.gmail.com> <8701347.YaW7b4Fxgt@uw000953> <CAFSJ42a5PsnbhgEaWWWZTBDVKhKUGR4xWY1pEXPc-UaQcC9AFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 of April 2013 17:21:57 Eugene Krasnikov wrote:

Hi,

> Thanx for reply. That also works.
> But is it a solution or workaround? May be there should be smarter
> check than just a kernel version?

Note that android kernel is not vanilla kernel.

If you have custom kernel (e.g android kernel) with extra features backported
you need to enable support for those features in compat-drivers for
your kernel i.e. mark it as applicable for lower kernel version (comparing to
vanilla kernel which introduced this feature)

The 'proper' solution would be to have support for Android (or CM) kernel in
compat-drivers (same as eg. RH kernel would). But Android kernels varies
heavily among devices and it could be hard to support all of them. It is also
worth noting that often custom non-mainlined code doesn't even build when
configured as module e.g. bluesleep driver from grouper kernel. This is extra
obstacle as one would have to fix or disable such offending code.

-- 
BR
Szymon Janc
