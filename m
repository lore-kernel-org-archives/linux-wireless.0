Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:55999 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaAHJYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 04:24:12 -0500
Received: by mail-vb0-f48.google.com with SMTP id q12so934874vbe.7
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jan 2014 01:24:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52CD12D4.5030008@broadcom.com>
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com>
 <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
 <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com>
 <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com>
 <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com>
 <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com>
 <52BD68BA.3080304@broadcom.com> <CAGb2v67Q=q4vyOftb+BLhAYR-6d04dDP3+kY3b88U8_vCvAmgQ@mail.gmail.com>
 <52CD12D4.5030008@broadcom.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 8 Jan 2014 17:23:50 +0800
Message-ID: <CAGb2v64+5Rgs6JxD0iH3bcwXPOm-xyS_LSmWLfx0qiMQwreOeQ@mail.gmail.com> (sfid-20140108_102418_057282_F1B8B7F3)
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-sunxi <linux-sunxi@googlegroups.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>, benn@cubietech.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 8, 2014 at 4:56 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/27/2013 01:36 PM, Chen-Yu Tsai wrote:
>>>> >> Working tree:
>>>> >>
>>>> >>   https://github.com/wens/linux/tree/wip/sunxi-next-wifi
>>>> >>
>>>> >> Comments welcome :)
>>> >
>>> > No comment, but: Nice work!
>> Thanks. BTW, who should submit the patch? :)
>
> Hi Chen-Yu
>
> I will submit the patch today.

Great!

I added device tree support for brcmfmac SDIO devices,
to be able to specify external out-of-band interrupts.
Unfortunately it's not working. I get the following output:

brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
brcmfmac: brcmf_fil_cmd_data: Failed err=-110
brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -110
brcmfmac: brcmf_bus_start: failed: -110
brcmfmac: brcmf_sdbrcm_probe: dongle is not responding
brcmfmac: brcmf_sdio_probe: device attach failed
brcmfmac: brcmf_ops_sdio_probe: F2 error, probe failed -19...

Should we add device tree support for the brcmf platform driver,
so we can enable power, clocks, etc. before the SDIO driver is probed?

Not sure if this is the right way. Maxime mentioned on IRC that some
mmc host drivers take a vmmc regulator property.

Currently I am using rfkill-gpio to do this. But brcmfmac also
registers an rfkill of its own.

Also, I have bluetooth working. Turns out it was a wrong pinctrl
setting in my dt. For those who want to try:

  Get and compile brcm_patchram_plus from
  http://code.google.com/p/broadcom-bluetooth/

  Run brcm_patchram_plus --patchram bcm20710a1.hcd --no2bytes /dev/ttyS1
  and hciattach /dev/ttyS1

  If brcm_patchram_plus hangs, you may need to reset the controller
  by blocking then unblocking the bluetooth rfkill switch.

I pushed all my work out already. Here's the link again:

  https://github.com/wens/linux/tree/wip/sunxi-next-wifi


Cheers
ChenYu
