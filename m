Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33547 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbdE0K6l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 May 2017 06:58:41 -0400
Received: by mail-wm0-f43.google.com with SMTP id m7so9898995wmg.0
        for <linux-wireless@vger.kernel.org>; Sat, 27 May 2017 03:57:54 -0700 (PDT)
Subject: Re: BCM4350 not working properly under Debian 9 RC3, Dell XPS 13 9350
To: Graziano D'Innocenzo <graziano.dinnocenzo@adaptcentre.ie>
References: <CAC7DkBhn=yzeT6gfyt2XFcvH2S=9P0XTmjKXsBk7QqGMN+0mbw@mail.gmail.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <420c805d-0669-e852-28f2-71a944b156e3@broadcom.com> (sfid-20170527_125846_372593_6FBA3A6B)
Date: Sat, 27 May 2017 12:57:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAC7DkBhn=yzeT6gfyt2XFcvH2S=9P0XTmjKXsBk7QqGMN+0mbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

On 27-05-17 11:33, Graziano D'Innocenzo wrote:
> Hello,
> 
> I found this email address on:
> https://wireless.wiki.kernel.org/en/users/Drivers/brcm80211
> 
> We have a laptop "Dell XPS 13 9350" and we have been unable to make
> its wireless work properly: signal is extremely weak and it frequently
> disconnects.
> We are currently running Debian 9 RC3 but exactly the same issue
> happened with NixOS 17.3.
> 
> $ lspci  |grep BCM
> 3a:00.0 Network controller: Broadcom Limited BCM4350 802.11ac Wireless
> Network Adapter (rev 08)
> 
> We have the following in dmesg:
> # dmesg |grep brcmf
> [    8.505203] usbcore: registered new interface driver brcmfmac
> [    8.613239] brcmfmac 0000:3a:00.0: firmware: direct-loading
> firmware brcm/brcmfmac4350-pcie.bin
> [    8.613251] brcmfmac 0000:3a:00.0: firmware: failed to load
> brcm/brcmfmac4350-pcie.txt (-2)
> [    8.613251] brcmfmac 0000:3a:00.0: Direct firmware load for
> brcm/brcmfmac4350-pcie.txt failed with error -2

This does not matter. That file is optional and not needed for this
specific device (if not mistaken).

> [    9.045202] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
> wl0: Oct 22 2015 06:16:26 version 7.35.180.119 (r594535) FWID
> 01-e791c176
> [    9.078535] brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166
> code (0x30 0x30)
> [    9.084339] brcmfmac 0000:3a:00.0 wlp58s0: renamed from wlan0
> [   10.551106] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
> [   10.551120] brcmfmac: brcmf_cfg80211_add_iface: add iface
> p2p-dev-wlp58s0 type 10 failed: err=-16

Seems you have wpa_supplicant version that implicitly created the
so-called p2p-device interface. You can try putting 'p2p_disabled=1' in
wpa_supplicant.conf. I assume you are using NetworkManager. I am not
sure if there is a GUI option for it.

> When booting with EFI we have many files under:
> /sys/firmware/efi/efivars/
> but we do not have:
> nvram-74b00bd9-805a-4d61-b51f-43268123d113

Not needed.

> If you could please provide any help we would be grateful. This issue
> has been driving us crazy for a week now, if this fails the next step
> would be buying a usb wifi adaptor.

So for the weak signal and disconnects could you please provide details.
What channel is your AP on? How occupied is that channel? Is bluetooth
enabled? What signal levels do you read?

Regards,
Arend
