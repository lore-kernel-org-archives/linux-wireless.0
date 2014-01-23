Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639AbaAWWkQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 17:40:16 -0500
Message-ID: <52E19A27.7000402@redhat.com> (sfid-20140123_234020_254628_4588BA8A)
Date: Thu, 23 Jan 2014 23:39:35 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com, Arend van Spriel <arend@broadcom.com>
CC: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>, benn@cubietech.com
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com> <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com> <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com> <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com> <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com> <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com> <52BD68BA.3080304@broadcom.com> <CAGb2v67Q=q4vyOftb+BLhAYR-6d04dDP3+kY3b88U8_vCvAmgQ@mail.gmail.com> <52CD12D4.5030008@broadcom.com> <CAGb2v64+5Rgs6JxD0iH3bcwXPOm-xyS_LSmWLfx0qiMQwreOeQ@mail.gmail.com>
In-Reply-To: <CAGb2v64+5Rgs6JxD0iH3bcwXPOm-xyS_LSmWLfx0qiMQwreOeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been working on updating sunxi-devel to include more
recent versions if your gmac patches, as well as adding support
for the wifi + bluetooth found on the cubietruck.

Here is my current work on this:

https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-devel

It is close to working, but unfortunately it does not work,
here is what I get in dmesg when I modprove the module:

[   99.700889] brcmfmac_sdio mmc1:0001:1: device tree node not found
[  100.020984] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Apr 22 2013 14:50:00 version 5.90.195.89.6 FWID 01-b30a427d
[  100.260948] brcmfmac: brcmf_fil_cmd_data: Failed err=-23
[  100.281260] brcmfmac: brcmf_fil_cmd_data: Failed err=-23
[  100.322508] usbcore: registered new interface driver brcmfmac
[  160.445215] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning already: status (1)
[  203.445404] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning already: status (1)
[  256.445140] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning already: status (1)
...

This is using the firmware + nvram found here:
http://dl.cubieboard.org/public/Cubieboard/benn/firmware/ap6210/

Wens' can you give my tree a try? And which version of the firmware +
nvram are you using ?

Thanks & Regards,

Hans

