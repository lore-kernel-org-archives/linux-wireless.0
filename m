Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932171AbeCJOTJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:19:09 -0500
MIME-Version: 1.0
In-Reply-To: <20180309221243.15489-1-andresx7@gmail.com>
References: <20180309221243.15489-1-andresx7@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Sat, 10 Mar 2018 06:18:47 -0800
Message-ID: <CAB=NE6US0qwDVeGvcng1zjN37N0PsibU5vP1sMoGb_F4LR5h=g@mail.gmail.com> (sfid-20180310_151926_513400_3888E0DA)
Subject: Re: [RFC 0/1] Loading optional firmware
To: Andres Rodriguez <andresx7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 9, 2018 at 2:12 PM, Andres Rodriguez <andresx7@gmail.com> wrote:
> Hi Everyone,
>
> Wanted to inquire your opinions about the following matter.
>
> We are experiencing some end user confusion regarding the following messages
> being printed to dmesg:
>
> [    0.571324] amdgpu 0000:01:00.0: Direct firmware load for amdgpu/polaris10_pfp_2.bin failed with error -2
> [    0.571338] amdgpu 0000:01:00.0: Direct firmware load for amdgpu/polaris10_me_2.bin failed with error -2
> [    0.571348] amdgpu 0000:01:00.0: Direct firmware load for amdgpu/polaris10_ce_2.bin failed with error -2
> [    0.571366] amdgpu 0000:01:00.0: Direct firmware load for amdgpu/polaris10_mec_2.bin failed with error -2
> [    0.571404] amdgpu 0000:01:00.0: Direct firmware load for amdgpu/polaris10_mec2_2.bin failed with error -2
>
> These firmware blobs are optional. If they aren't available, the graphics card
> can still function normally. But having these messages causes the user to think
> their current problems are related to missing firmware.
>
> It would be great if we could have a mechanism that enabled us to load a
> firmware blob without any dmesg spew in case of file not found errors.Currently
> request_firmware_direct() implements this functionality, but as a drawback it
> forfeits the usermodehelper fallback path.

Yeah, this is a common enough reported type of feature request that I
think it makes sense to add now. I'll reply to your patch with a bit
more details.

 Luis
