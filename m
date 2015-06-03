Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:28956 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbbFCLqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 07:46:22 -0400
Message-ID: <556EE90A.9000607@broadcom.com> (sfid-20150603_134756_017754_BD78C7DB)
Date: Wed, 3 Jun 2015 13:46:18 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac: error creating p2p
References: <CACna6rx7WRhsie6EX8MGrUAAdFGEV4+qtzBhM7BAe-RuLkQBFA@mail.gmail.com>
In-Reply-To: <CACna6rx7WRhsie6EX8MGrUAAdFGEV4+qtzBhM7BAe-RuLkQBFA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02/15 07:39, Rafał Miłecki wrote:
> Hi,
>
> I think brcmfmac may have some problems with mixing various
> interfaces, so just for some test I decided to try p2p interface. I'm
> using BCM43602 and it seems to support p2p:
> # iw phy phy0 info | tail
>          valid interface combinations:
>                   * #{ IBSS, managed }<= 1, #{ AP }<= 4, #{
> P2P-client, P2P-GO }<= 1, #{ P2P-device }<= 1,
>                     total<= 3, #channels<= 1
>
> But I can't create p2p interface:
> # iw phy phy0 interface add p2p0 type __p2pdev
> brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
> brcmfmac: brcmf_add_if: ignore IF event
> brcmfmac: brcmf_p2p_set_firmware: failed to update device address ret -52
> brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
> command failed: Invalid exchange (-52)

This looked familiar so digging the log I think you need the following 
commit:

commit f48556e1b6a60f1b394a6c4b0a7b8cacba3eb107
Author: Arend van Spriel <arend@broadcom.com>
Date:   Tue Sep 30 10:23:16 2014 +0200

     brcmfmac: assure P2P discovery is disabled when setting P2P_DEVICE 
mac addre

     In order to provision the P2P_DEVICE mac address using 
p2p_da_override iovar
     the discovery interface must be disabled. On some targets setting 
the mac
     address failed so disable the discovery interface to be certain.

     Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
     Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
     Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
     Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
     Signed-off-by: Arend van Spriel <arend@broadcom.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Not sure what kernel and/or brcmfmac you are seeing this so hopefully 
this commit will help.

Regards,
Arend

