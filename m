Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:36130 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdCPJ5C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 05:57:02 -0400
MIME-Version: 1.0
In-Reply-To: <20170223183018.16704-1-zajec5@gmail.com>
References: <20170221094754.15406-1-zajec5@gmail.com> <20170223183018.16704-1-zajec5@gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 16 Mar 2017 10:57:00 +0100
Message-ID: <CACna6rzK29VSR2YNQPMhVri3M_DzbFSvFfZ1=RVnkT2P+ohTFw@mail.gmail.com> (sfid-20170316_105728_654197_C5FF05C7)
Subject: Re: [PATCH V4 1/2] firmware: add more flexible request_firmware_async function
To: Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 February 2017 at 19:30, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> So far we got only one function for loading firmware asynchronously:
> request_firmware_nowait. It didn't allow much customization of firmware
> loading process - there is only one bool uevent argument. Moreover this
> bool also controls user helper in an unclear way.
>
> Resolve this problem by adding one internally shared  function that
> allows specifying any flags manually.
>
> This implementation:
> 1) Allows keeping old request_firmware_nowait API unchanged
> 2) Doesn't require adjusting / rewriting current drivers
> 3) Minimizes risk of regressions
> 4) Adds new function for drivers that need more control over loading a
>    firmware.
>
> The new function takes options struct pointer as an argument to make
> further improvements possible (without any big reworks).
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> V3: Don't expose all FW_OPT_* flags.
>     As Luis noted we want a struct so add struct firmware_opts for real
>     flexibility.
>     Thank you Luis for your review!
>
> Ming/Luis/Greg: assuming this gets a positive review, could someone of yo=
u pick
> this patchset?

Ping. I hope it's relatively simple and non-intrusive change with a
proper design now.

Is there some who could pick this small patchset?
