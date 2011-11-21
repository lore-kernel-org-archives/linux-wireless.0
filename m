Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55691 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab1KUVeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 16:34:25 -0500
Received: by vbbfc21 with SMTP id fc21so3040191vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 13:34:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADrAYBndEsNz5nypirSxQPObpSV5BWARWOQzwmBTmzg+tgUbBA@mail.gmail.com>
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
	<4ECA8908.7070304@broadcom.com>
	<4ECA98DB.4030608@broadcom.com>
	<CADrAYBk7_fsVJUAYNqEZpdBPKOTGUai_UhPT9LMHaEyY+Zm24w@mail.gmail.com>
	<4ECAAD6C.4080103@broadcom.com>
	<CADrAYBndEsNz5nypirSxQPObpSV5BWARWOQzwmBTmzg+tgUbBA@mail.gmail.com>
Date: Mon, 21 Nov 2011 22:34:25 +0100
Message-ID: <CADrAYB=wDwrzCFEi4-PFepLiLMbPLAGxoaNGtXBaPZPR1onokA@mail.gmail.com> (sfid-20111121_223428_196597_C5B976FA)
Subject: Re: brcm80211 (with bcm4329-chip)
From: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Howard Harte <hharte@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 10:13 PM, Thomas Langås
<thomas.langas@fxitech.com> wrote:
> Hmm, doing that, and loading this as a module instead of compiling it into the
> kernel seemed to work.
>
> Is there a reason for this not working when being compiled into the kernel? Is
> it possible that I need to change the order of  some of the units
> being initialized
> in my machine-description / init?

Ok, so I get the device listed as a wlan0-device, and I see the driver
being able to communicate
with the chip, sort of (it can read registers at least), but then I
start seeing errors like this (from
the previously attached log):
[  463.030000] brcmf_sdioh_request_word: Failed to write word, Err: 0xffffffac
[  463.030000] brcmf_sdcard_reg_write: error writing 0x00000000 to
addr 0x8058 size 4
[  463.030000] brcmf_sdcard_reg_write: fun = 1, addr = 0x1800005c,
uint32data = 0x0
[  463.030000] brcmf_sdioh_request_word: rw=1, func=1, addr=0x0805c, nbytes=4
[  463.030000] brcmf_sdioh_request_word: Failed to write word, Err: 0xffffffac
[  463.030000] brcmf_sdcard_reg_write: error writing 0x00000000 to
addr 0x805c size 4
[  463.030000] brcmf_sdioh_request_byte: rw=1, func=0, addr=0x00002
[  463.040000] brcmf_sdcard_cfg_write: fun = 0, addr = 0x2, u8data = 0x2
[  463.040000] brcmf_sdioh_request_byte: rw=0, func=1, addr=0x00000
[  463.040000] brcmf_sdcard_cfg_read: fun = 1, addr = 0x0, u8data = 0x29
[  463.040000] brcmf_sdioh_request_byte: rw=1, func=1, addr=0x1000e
[  463.040000] brcmf_sdcard_cfg_write: fun = 1, addr = 0x1000e, u8data = 0x0
[  463.040000] brcmf_sdbrcm_sdiod_drive_strength_init: No SDIO Drive
strength init done for chip 4329 rev 3 pmurev 6
...
[  463.040000] brcmf_sdcard_reg_write: fun = 1, addr = 0x18011000,
uint32data = 0x2
[  463.040000] brcmf_sdioh_request_word: rw=1, func=1, addr=0x09000, nbytes=4
[  463.040000] brcmf_sdioh_request_word: Failed to write word, Err: 0xffffffac
[  463.040000] brcmf_sdcard_reg_write: error writing 0x00000002 to
addr 0x9000 size 4
[  463.040000] brcmf_attach: Enter
...
[  463.050000] brcmf_sdbrcm_probe: completed!!
...
[  463.055000] brcmf_sdbrcm_isr: Enter
[  463.055000] brcmf_sdbrcm_isr: bus is down. we have nothing to do
...
(and the list goes on)

Any pointers on what I should start looking for?  :)


Regards,
Thomas
