Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:63653 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaGaUdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:33:06 -0400
Received: by mail-ig0-f174.google.com with SMTP id c1so291159igq.7
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 13:33:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53DAA5DD.7050608@hauke-m.de>
References: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
	<1406836788-23704-4-git-send-email-zajec5@gmail.com>
	<53DAA5DD.7050608@hauke-m.de>
Date: Thu, 31 Jul 2014 22:33:06 +0200
Message-ID: <CACna6rwZdcW9KC+dyvm+tUjVvvLJ+TnObY-_Ew6fXmpLqFW0qg@mail.gmail.com> (sfid-20140731_223312_339393_9D340AB1)
Subject: Re: [PATCH 3.18 3/7] b43: flush some writes on Broadcom MIPS SoCs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 July 2014 22:23, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> A comment in brcmsmac says this is only needed to work around a bug in
> the host pcie controller of 4717, 4718 and 4706. I haven't noticed this
> problem with BCM4706, so it could be that it is already fixed in the
> shipped version of bcm4706.
>
> The comment says the following:
> bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
> transactions. As a fix, a read after write is performed on certain
> places in the code. Older chips and the newer 5357 family don't require
> this fix.
>
> This commit did the cleanup:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6a9a25eec0b55ea45e22710a9bcaf9690cb42fe6

Any idea why Broadcom didn't own comments and didn't enable it for
bcm4716 and bcm4706 only?

-- 
Rafał
