Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:33923 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbbFPO0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 10:26:32 -0400
Message-ID: <55803214.2030204@broadcom.com> (sfid-20150616_162636_221958_F9B3097D)
Date: Tue, 16 Jun 2015 16:26:28 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cmcgS3JhdXNl?= <joerg.krause@embedded.rocks>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac: Failed to create interface p2p-dev-p2p0: -28 (No space
 left on device)
References: <1433766944.28058.16.camel@embedded.rocks>			 <55758D7E.3000603@broadcom.com>	 <1433771289.28058.24.camel@embedded.rocks>	 <5575C6FA.6030104@broadcom.com>	 <1433794640.28058.26.camel@embedded.rocks> <557605CC.6070907@broadcom.com> <1434448766.21949.9.camel@embedded.rocks>
In-Reply-To: <1434448766.21949.9.camel@embedded.rocks>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/16/15 11:59, Jörg Krause wrote:
> Hi Arend,
>
> as I wrote in my previous mail ("brcmfmac: brcmf_p2p_create_p2pdev:
> timeout occurred") I get a p2p0 interface when loading the brcmfmac
> module with p2pon=1 (Linux kernel 4.0.5, BCM43362).
>
> Unfortunatly, if I try to use the p2p0 interface with wpa_supplicant
> 2.4 I get an error:
>
>      Failed to create interface p2p-dev-p2p0: -28 (No space left on
>      device)
>      nl80211: Failed to create a P2P Device interface p2p-dev-p2p0
>      P2P: Failed to enable P2P Device interface

Using p2pon=1 is old-school p2p, ie. it creates a regular netdev for 
doing p2p management stuff. Problem is that brcmfmac also indicates p2p 
device support. We can remove p2pon parameter or not indicate p2p dev 
support when p2pon=1.

Can you patch brcmfmac and give it a try. Need to start wpa_supplicant 
for two interface and if I recall correctly p2p0 must be specified first.

Regards,
Arend

> The command:
>
>      wpa_supplicant -Dnl80211 -ip2p0 -c /etc/p2p_supplicant.conf -N
>      -Dnl80211 -iwlan0 -c /etc/wpa_supplicant.conf -ddt&
>
> The P2P config file:
>      # cat /etc/p2p_supplicant.conf
>      ctrl_interface=/var/run/p2p_supplicant
>
>      device_name=P2P Test
>      device_type=1-0050F204-1
>
> I attached the log output from wpa_supplicant.
>
> Best regards
> Jörg Krause

