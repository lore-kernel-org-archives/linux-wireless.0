Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from inx.pm.waw.pl ([91.202.125.194]:48869 "EHLO inx.pm.waw.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751502AbeEDT0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 May 2018 15:26:45 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        keescook@chromium.org, josh@joshtriplett.org, teg@jklm.no,
        wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com,
        zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org,
        mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com,
        tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com,
        hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        davem@davemloft.net, maco@android.com, arve@android.com,
        tkjos@android.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/6] firmware_loader: cleanups for v4.18
References: <20180504174356.13227-1-mcgrof@kernel.org>
Date: Fri, 04 May 2018 21:17:08 +0200
In-Reply-To: <20180504174356.13227-1-mcgrof@kernel.org> (Luis R. Rodriguez's
        message of "Fri, 4 May 2018 10:43:49 -0700")
Message-ID: <m3lgczcjt7.fsf@pm.waw.pl> (sfid-20180504_212705_509853_082F401D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

>   * CONFIG_WANXL --> CONFIG_WANXL_BUILD_FIRMWARE
>   * CONFIG_SCSI_AIC79XX --> CONFIG_AIC79XX_BUILD_FIRMWARE
>
> To this day both of these drivers are building driver *firmwares* when
> the option CONFIG_PREVENT_FIRMWARE_BUILD is disabled, and they don't
> even make use of the firmware API at all.

Don't know for sure about Adaptec, but wanXL firmware fits every
definition of "stable". BTW it's a 1997 or so early PCI card, built
around the PLX PCI9060 bus mastering PCI bridge and Motorola 68360
(the original QUICC) processor. Maximum bit rate of 2 Mb/s on each sync
serial port.

It's more about delivering the .S source for the firmware, I guess.
Nobody is expected to build it. The fw is about 2.5 KB and is directly
linked with the driver.
-- 
Krzysztof Halasa
