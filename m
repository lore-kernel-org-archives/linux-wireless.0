Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33696 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbbLAImU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 03:42:20 -0500
Received: by wmec201 with SMTP id c201so193794693wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 00:42:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADaZW1Eww2TNimciP5JxVam0y+-V4Ez2VfFXdT=_jh14TgOp0g@mail.gmail.com>
References: <loom.20151201T071931-353@post.gmane.org>
	<CALhHN=o4xAhy9oz0Q7sy-Ubji-nBf6pdJ7OSj8xLU0mn86n1qQ@mail.gmail.com>
	<CADaZW1E42rnjaxjnjskW_j83m=moauNBttZ-M=oyWoiXXS2ZiQ@mail.gmail.com>
	<CA+BoTQ=k9NHd6KHt2qzgjs5g3B6Q58fX=hTRB-BvxcvjejmWog@mail.gmail.com>
	<CADaZW1Eww2TNimciP5JxVam0y+-V4Ez2VfFXdT=_jh14TgOp0g@mail.gmail.com>
Date: Tue, 1 Dec 2015 09:42:18 +0100
Message-ID: <CA+BoTQk0Y+djSBNMonhkpZ3Aw8aKuxefdgSa9zUa-vgV9HTL4A@mail.gmail.com> (sfid-20151201_094223_172104_09DD19BC)
Subject: Re: ath10k: device has crashed during init - qca6174 chipset
From: Michal Kazior <michal.kazior@tieto.com>
To: Bartlomiej Grzeskowiak <bartlomiej.grzeskowiak@gmail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 December 2015 at 09:38, Bartlomiej Grzeskowiak
<bartlomiej.grzeskowiak@gmail.com> wrote:
> Hi,
>
> I have already tried with backports 4.2.6 and different combinations
> of firmware.bin / board.bin. With differnt results, but none of them
> works. I will redo the tests and summarize them.
>
> Loading with irq_mode=1 gives me following result:
> [55416.824364] ath10k_pci 0000:01:00.0: limiting irq mode to: 1
> [55416.830102] ath10k_pci 0000:01:00.0: pci irq legacy interrupts 0
> irq_mode 1 reset_mode 0
> [55417.212048] ath10k_pci 0000:01:00.0: could not fetch firmware file
> 'ath10k/QCA6174/hw3.0/firmware-5.bin': -2
> [55424.394422] ath10k_pci 0000:01:00.0: wmi unified ready event not received
> [55424.436023] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
> e082ac60-7c2d-4d14-9c49-fd5b0591c95c)
> [55424.445008] ath10k_pci 0000:01:00.0: qca6174 hw3.2 (0x05030000,

Oh, wait.

You have hw3.2? I haven't noticed that earlier.

If memory serves right it needs a different board.bin (compared to
e.g. hw3.0). I'm not sure if it's available in Kalle's repository.
Wrong board.bin can cause firmware to hang or crash during init.


Michał
