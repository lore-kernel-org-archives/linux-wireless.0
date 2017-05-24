Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35575 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030200AbdEXNNX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:13:23 -0400
Received: by mail-wm0-f54.google.com with SMTP id b84so64714334wmh.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 06:13:22 -0700 (PDT)
Subject: Re: brcmfmac: brcm43430 Invalid mailbox value issue
To: James Hughes <james.hughes@raspberrypi.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com
References: <CAE_XsMKBQJDVbiH1RN_9zvOtToQgA74wbZWmnfXLbDAATua_kA@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8ec01afb-7c9d-2cde-0007-b4d9fd2dbdbd@broadcom.com> (sfid-20170524_151404_497183_3EF9B536)
Date: Wed, 24 May 2017 15:13:21 +0200
MIME-Version: 1.0
In-Reply-To: <CAE_XsMKBQJDVbiH1RN_9zvOtToQgA74wbZWmnfXLbDAATua_kA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24-05-17 14:50, James Hughes wrote:
> We are seeing an issue on Raspberry Pi which uses the bcm43430 chip. It's
> been tested up to 4.9 which still shows the issue (it's been there for some
> time, > 1yr). I'm trying to find someone who can test on 4.11 as I cannot
> replicate  (The latest kernel we have that works on a Pi)
> 
> It exhibits as a log entry, and subsequent death of wireless connectivity.
> 
> "Unknown mailbox data content: 0x40012"
> 
> Look at the driver code, it appears to be checking the return
> value from a mailbox (presumably the one to the chip firmware), which
> has the 0x4 in the top word which shouldn't be there.
> 
> The driver simply adds a log entry, but otherwise ignores the situation.
> However, we see wireless failure from this point.
> 
> Since I believe this value is being returned from the chip, I cannot
> investigate much further. The public datasheet is of no help. We do appear
> to be using the latest firmware file.
> 
> I'm not sure how to proceed on this one. It would be interesting to know
> under what circumstances that value can be returned from the mailbox.
> 
> More details can be found at the end of this github issue.
> 
> https://github.com/raspberrypi/linux/issues/1342

Hi James,

I looked through the issue on github and it seems you are getting -110
(-ETIMEDOUT) on SDIO transfers. This could be a signal integrity issue
of the SDIO bus signals, which may happen if the RPi3 power supply can
not provide enough amps. So you could try to replicate it by
deliberately use a power supply below specs.

I did not get my RPi3 going yet, but I can try next monday or so. Office
closed due to Ascension day. Do you know what SDIO host controller is
used on RPi3? I can check myself, but if you know the answer up front
let me know.

Regards,
Arend
