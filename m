Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40594 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdK0M5o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 07:57:44 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Build regressions/improvements in v4.15-rc1
References: <1511776877-11130-1-git-send-email-geert@linux-m68k.org>
        <CAMuHMdX6XpKbLYuwkdCK0YhYGaV5Sg8+v0DrUV9y6R3Qozf-qQ@mail.gmail.com>
Date: Mon, 27 Nov 2017 14:57:37 +0200
In-Reply-To: <CAMuHMdX6XpKbLYuwkdCK0YhYGaV5Sg8+v0DrUV9y6R3Qozf-qQ@mail.gmail.com>
        (Geert Uytterhoeven's message of "Mon, 27 Nov 2017 11:11:17 +0100")
Message-ID: <87lgirx4ji.fsf@purkki.adurom.net> (sfid-20171127_135822_011264_4117D092)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Mon, Nov 27, 2017 at 11:01 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> Below is the list of build error/warning regressions/improvements in
>> v4.15-rc1[1] compared to v4.14[2].
>>
>> Summarized:
>>   - build errors: +2/-5
>
>> [1] http://kisskb.ellerman.id.au/kisskb/head/4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323/ (all 271 configs)
>> [2] http://kisskb.ellerman.id.au/kisskb/head/bebc6082da0a9f5d47a1ea2edc099bf671058bd4/ (270 out of 271 configs)
>
>> 2 error regressions:
>>   + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_csr.c: error: 'si' may be used uninitialized in this function [-Werror=uninitialized]:  => 204:3
>
> x86_64-randconfig
>
>>   + /home/kisskb/slave/src/include/linux/bcma/bcma_driver_pci.h: error: field 'pci_controller' has incomplete type:  => 218:24

The last "real" change to that file was from 2015 so I guess something
else changed to trigger this? But anyway, I guess the reason is missing
struct pci_controller forward declaration? Or missing include
<asm/pci-bridge.h? Not sure.

-- 
Kalle Valo
