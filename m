Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:63199 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbbFHMlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 08:41:36 -0400
Message-ID: <55758D7E.3000603@broadcom.com> (sfid-20150608_144139_731016_E538EF53)
Date: Mon, 8 Jun 2015 14:41:34 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cmcgS3JhdXNl?= <joerg.krause@embedded.rocks>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac: brcmf_p2p_create_p2pdev: timeout occurred
References: <1433766944.28058.16.camel@embedded.rocks>
In-Reply-To: <1433766944.28058.16.camel@embedded.rocks>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/15 14:35, Jörg Krause wrote:
> Hi,
>
> I've trouble creating the p2p interface on a BCM43362 wifi device
> running Linux kernel 4.0.4:
>
>      # dmesg | grep brcmfmac
>      [    7.010870] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
>      wl0: Apr 22 2013 14:50:00 version 5.90.195.89.6 FWID 01-b30a427d
>      [    7.158905] brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166
>      code
>      [   11.007164] brcmfmac: brcmf_p2p_create_p2pdev: timeout occurred
>
> Trying to add the p2p interface manually:
>
>      # iw phy0 interface add p2p0 type __p2pdev
>      [  372.042704] brcmfmac: brcmf_link_down: WLC_DISASSOC failed (-52)
>      [  373.637263] brcmfmac: brcmf_p2p_create_p2pdev: timeout occurred
>      [  373.679377] brcmfmac: brcmf_cfg80211_del_key: invalid key index (4)
>      [  373.685733] brcmfmac: brcmf_cfg80211_del_key: invalid key index (5)
>
> Any idea?

Wondering whether it is similar to what Rafal reported. Can you do a 
hexdump, ie. hexdump -C brcmfmac43362-sdio.bin | tail -30

Regards,
Arend

> Best regards
> Jörg Krause

