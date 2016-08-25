Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751187AbcHYNdH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 09:33:07 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Lobachevskii Vitalii <silverunicorn2011@yandex.ru>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce
References: <321381b3-5dea-f16a-56cb-11120d4a38ef@yandex.ru>
        <72b958e1-0200-cd6f-2012-e04ff6fb74cb@yandex.ru>
Date: Thu, 25 Aug 2016 09:17:54 -0400
In-Reply-To: <72b958e1-0200-cd6f-2012-e04ff6fb74cb@yandex.ru> (Lobachevskii
        Vitalii's message of "Thu, 25 Aug 2016 14:23:12 +0300")
Message-ID: <wrfjmvk1asxp.fsf@redhat.com> (sfid-20160825_153311_135027_CAF0516F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lobachevskii Vitalii <silverunicorn2011@yandex.ru> writes:
> Hello,
>
> The RTL8192CE device seems to work fine without any firmware, so you may
> make it fully optional, removing dependency on FW_LOADER. Of course that
> require some patching, but if I understood the driver internals
> correctly, simple complete(&rtlpriv->firmware_loading_complete); would
> be enough when firmware loading machinery is unavailable, that is, when
> request_firmware_nowait returns -EINVAL (currently that may only happen
> in improperly configured or patched kernels, like Linux-libre; see
> attached messages for more information)
>
> Of course I will try to fix Linux-libre “deblobbing” technique, as it
> should never break anything that may work without a firmware. But
> anyway, if a device and its driver may work without a certain kernel
> feature, that feature should not be selected, I think.

The realtek devices all require firmwere to operate correctly,
including the 8192c series. There are a bunch of commands flying back
and forth between the driver and the firmware.

If your device happens to work without loading the firmware then you
have an old firmware blob loaded.

At least this is the case for the USB version of the device, and I find
it highly unlikely the PCIe version is any different.

Trying to remove the firmware loading error is just plain silly.

Jes
