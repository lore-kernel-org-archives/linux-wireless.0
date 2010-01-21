Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:55781 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab0AUSWQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 13:22:16 -0500
Message-ID: <4B5897C8.2080006@irobot.com>
Date: Thu, 21 Jan 2010 10:07:04 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Subject: Re: FYI - new compat-wireless based on 2.6.33-rc4
References: <43e72e891001201213x6a2c203dl7121f2dde6d61fb9@mail.gmail.com>
In-Reply-To: <43e72e891001201213x6a2c203dl7121f2dde6d61fb9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat-wireless-2010-01-20.tar.bz2 does not compile cleanly on ARM 
architectures.
Commenting out line 9 of compat-2.6.32.h (#include <asm/compat.h>) fixes 
the issue.
There is no arch/arm/include/asm/compat.h
I suspect there are several other architectures which have similar issues.

Luis R. Rodriguez wrote:
> The compat_firmware_class was having some issues which should now be
> hopefully addressed:
>
>   * Use a different subsystem name for sysfs registration, now compat_firmware
>   * The new subsystem name change required a new udev rule to be added
>
> The new compat-wireless for 2.6.33-rc4 has been pushed out with the
> new changes. Unfortunately 2.6.33-rc5 hasn't been pushed out yet so I
> just overwrote the old rc4 package (next time I'll just add an extra
> extra version when this happens). The new sha1sum for this release is:
>
> c007d7c8649d6149f415ea87dc7a34d4ee808766  compat-wireless-2.6.33-rc4.tar.bz2
>
> Just kicked out a bleeding edge release with the same fixes:
>
> 65bb3cd6565f1788a2c63bfe8ccfdd8dfc1fb368  compat-wireless-2010-01-20.tar.bz2
>
> Please let us know if there are any issues. I should note that the new
> compat_firmware_class will be used *every time* compat-wireless is
> used firmware needs to be uploaded, not just for the new
> request_firmware_nowait().
>
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

