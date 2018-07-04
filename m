Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753248AbeGDNFh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 09:05:37 -0400
Date: Wed, 4 Jul 2018 16:04:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Frank A. Cancio Bello" <frank@generalsoftwareinc.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        devel@driverdev.osuosl.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] staging: r8822be: RTL8822be can't find any wireless AP
Message-ID: <20180704130448.pta7t5joj5qrxlpq@mwanda> (sfid-20180704_150554_986487_6472FFC3)
References: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 04, 2018 at 04:03:33PM +0800, Jian-Hong Pan wrote:
> Hi,
> 
> We have an ASUS X530UN (Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz)
> laptop equipped with Realtek rtl8822be wireless which cannot find any
> access point after WiFi is launched.
> 
> Realtek rtl8822be wireless' information:
> dev@endless:~/linux-eos$ sudo lspci -nnvs 02:00.0
> 02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
> Device [10ec:b822] (rev ff) (prog-if ff)
> !!! Unknown header type 7f
> Kernel driver in use: r8822be
> Kernel modules: r8822be
> 
> System always hits the error: "halmac_init_hal failed" in dmesg after
> WiFi is launched.
> 
> [ 8.591333] r8822be: module is from the staging directory, the quality
> is unknown, you have been warned.
> [ 8.593122] r8822be 0000:02:00.0: enabling device (0000 -> 0003)
> [ 8.669163] r8822be: Using firmware rtlwifi/rtl8822befw.bin
> [ 9.289939] r8822be: rtlwifi: wireless switch is on
> [ 10.056426] r8822be 0000:02:00.0 wlp2s0: renamed from wlan0
> ...
> [ 11.952534] r8822be: halmac_init_hal failed
> [ 11.955933] r8822be: halmac_init_hal failed
> [ 11.956227] r8822be: halmac_init_hal failed
> [ 22.007942] r8822be: halmac_init_hal failed

I really prefer to see the whole dmesg instead of an edited ... in the
middle.

I agree that it feels like the default aspm setting should be 2 (use
what the chip says).  Although I don't know the device well enough to
say if that will break anyone's system.  Perhaps someone who knows
better will be able to respond.

regards,
dan carpenter
