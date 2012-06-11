Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57491 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2FKTO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 15:14:27 -0400
Received: by ghrr11 with SMTP id r11so2806923ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 12:14:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <13109287F3F94FB397BD55908527913A@drejoasus>
References: <13109287F3F94FB397BD55908527913A@drejoasus>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 11 Jun 2012 12:14:06 -0700
Message-ID: <CAB=NE6UdsEMJoD8TfxHRZ61zN-urtbM3X51UM0A8apKcu1nQ2A@mail.gmail.com> (sfid-20120611_211432_139720_6393D719)
Subject: Re: compat-wireless for 2.6.12.5
To: Sertac TULLUK <stulluk@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 10, 2012 at 11:49 AM, Sertac TULLUK <stulluk@gmail.com> wrote:
> Dear All;
>
> I have full source of Celestial CSM1203 ( ARM 926 EJ-S core) Kernel ( which
> is modified from 2.6.12.5).
>
> The source and toolchain can be downloaded from here:
> http://www.merihvideo.com.tr/chipbox-source.php
>
> (.config and CSM1203 defconfig can be seen from the source)
>
> I know that compat-wireless support down to 2.6.24 and newer, but may be you
> can help to give support for USB WIFI for RALINK based solutions on my very
> old kernel.

Compat-wireless strives to support at the very least all kernels
listed on kernel.org, these are supported kernels. From a community
perspective it makes no sense to support older kernels as that would
also mean subtly recommending older kernels which we do not and we
cannot given that those are unsupported kernels. If companies / users
wants to take support down to even older kernels that's fine too --
patches are welcomed.

I will say that we have looked at backporting a lot of USB drivers to
older kernels but USB has changed quite a lot since 2.6.12 so even
architecturally its a pain in the ass to try to backport to such an
old kernel. I'd frankly give up and choose at the minimum 2.6.29,
given that we have another USB driver starting to support that kernel
carl9170, but I will note that 2.6.29 is no longer supported (its not
even listed on kernel.org). So -- just upgrade.

> I also need CIFS support for recording streams to windows shares. I hope
> compat team may give some suggestions about implementing CIFS on 2.6.12.5
> too.

If its a module then just throw it on to compat and ensure you can
compile it on older kernels as well using ckmake, if it compiles
chances are high it will load fine. Ozan has patches for to enable
ckmake to be distribution agnostic, otherwise you have to use Ubuntu
for now.

Best of luck.

  Luis
