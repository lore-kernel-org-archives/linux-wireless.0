Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33161 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1FBMkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 08:40:42 -0400
Received: by qyk7 with SMTP id 7so2362893qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 05:40:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307013080-10386-1-git-send-email-zajec5@gmail.com>
References: <1307013080-10386-1-git-send-email-zajec5@gmail.com>
Date: Thu, 2 Jun 2011 14:40:41 +0200
Message-ID: <BANLkTim-ouepU2D7au3yH3dCt3S15cTamA@mail.gmail.com> (sfid-20110602_144048_875228_73956D6B)
Subject: Re: [RFC][PATCH] b43: use condition for SSB specific ops
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Michael Buesch <mb@bu3sch.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 2 czerwca 2011 13:11 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> Abstracting bus by b43_bus_dev works fine, but there are few places
> where we calls SSB functions in uniq way. That calls happen only once
> in the whole code and so there is not much sense in putting them in
> bus abstraction.
>
> In this situation I have decided to use simple switches. It does not
> make code look lovely, but I do not have any better idea. If anyone
> have - comments are really welcome.

This final code would need to be something like:

switch (dev->dev->bus_type) {
#ifdef CONFIG_B43_BCMA
case B43_BUS_BCMA:
	dma->translation = bcma_dma_translation(dev->dev->bdev);
	break;
#endif
#ifdef CONFIG_B43_SSB
case B43_BUS_SSB:
	dma->translation = ssb_dma_translation(dev->dev->sdev);
	break;
#endif
}

So something nicer would be welcome. But what? :| Putting this in
bus.c? Even if that are once-callers?

-- 
Rafał
