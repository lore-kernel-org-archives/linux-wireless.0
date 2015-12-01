Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34071 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbbLAI0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 03:26:49 -0500
Received: by wmvv187 with SMTP id v187so194411833wmv.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 00:26:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADaZW1E42rnjaxjnjskW_j83m=moauNBttZ-M=oyWoiXXS2ZiQ@mail.gmail.com>
References: <loom.20151201T071931-353@post.gmane.org>
	<CALhHN=o4xAhy9oz0Q7sy-Ubji-nBf6pdJ7OSj8xLU0mn86n1qQ@mail.gmail.com>
	<CADaZW1E42rnjaxjnjskW_j83m=moauNBttZ-M=oyWoiXXS2ZiQ@mail.gmail.com>
Date: Tue, 1 Dec 2015 09:26:47 +0100
Message-ID: <CA+BoTQ=k9NHd6KHt2qzgjs5g3B6Q58fX=hTRB-BvxcvjejmWog@mail.gmail.com> (sfid-20151201_092652_613443_1CC56D2C)
Subject: Re: ath10k: device has crashed during init - qca6174 chipset
From: Michal Kazior <michal.kazior@tieto.com>
To: Bartlomiej Grzeskowiak <bartlomiej.grzeskowiak@gmail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 December 2015 at 09:13, Bartlomiej Grzeskowiak
<bartlomiej.grzeskowiak@gmail.com> wrote:
> Hi,
>
> Unfortunately I do have this patch in my code (backports-4.4-rc.2-1).
> I have also tested the old reg_address/mask value (0x00009028) but the
> result is the same.

The problem actually looks a little different. The mentioned patch
fixed a problem which would occur during early device init/probing.
Your problem seems to occur while booting and configuring firmware.

Did you try using older backports, firmware and/or board/board-2.bin
files? This could be some sort of regression you're seeing with the
exact combination you're testing.

You could also try loading ath10k_pci with irq_mode=1.


Michal
