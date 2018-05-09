Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934976AbeEINWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:22:13 -0400
Date: Wed, 9 May 2018 10:21:08 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        keescook@chromium.org, josh@joshtriplett.org, maco@android.com,
        andy.gross@linaro.org, david.brown@linaro.org,
        bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org,
        hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com,
        kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com,
        dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        jewalt@lgsinnovations.com, oneukum@suse.com,
        cantabile.desu@gmail.com, ast@fb.com, hare@suse.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl,
        davem@davemloft.net, arve@android.com, tkjos@android.com,
        corbet@lwn.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 13/13] Documentation: clarify firmware_class
 provenance and why we can't rename the module
Message-ID: <20180509102108.7049f7a9@vento.lan> (sfid-20180509_152233_075798_C5B2B08B)
In-Reply-To: <20180508181247.19431-14-mcgrof@kernel.org>
References: <20180508181247.19431-1-mcgrof@kernel.org>
        <20180508181247.19431-14-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Tue,  8 May 2018 11:12:47 -0700
"Luis R. Rodriguez" <mcgrof@kernel.org> escreveu:

> Clarify the provenance of the firmware loader firmware_class module name
> and why we cannot rename the module in the future.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  .../driver-api/firmware/fallback-mechanisms.rst          | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/driver-api/firmware/fallback-mechanisms.rst b/Documentation/driver-api/firmware/fallback-mechanisms.rst
> index a39323ef7d29..a8047be4a96e 100644
> --- a/Documentation/driver-api/firmware/fallback-mechanisms.rst
> +++ b/Documentation/driver-api/firmware/fallback-mechanisms.rst
> @@ -72,9 +72,12 @@ the firmware requested, and establishes it in the device hierarchy by
>  associating the device used to make the request as the device's parent.
>  The sysfs directory's file attributes are defined and controlled through
>  the new device's class (firmware_class) and group (fw_dev_attr_groups).
> -This is actually where the original firmware_class.c file name comes from,
> -as originally the only firmware loading mechanism available was the
> -mechanism we now use as a fallback mechanism.
> +This is actually where the original firmware_class module name came from,
> +given that originally the only firmware loading mechanism available was the
> +mechanism we now use as a fallback mechanism, which which registers a
> +struct class firmware_class. Because the attributes exposed are part of the
> +module name, the module name firmware_class cannot be renamed in the future, to
> +ensure backward compatibilty with old userspace.

Ah, now the explanation makes a lot more sense to me :-)

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

>  
>  To load firmware using the sysfs interface we expose a loading indicator,
>  and a file upload firmware into:



Thanks,
Mauro
