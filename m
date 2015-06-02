Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33265 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbbFBFjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 01:39:22 -0400
Received: by iebgx4 with SMTP id gx4so125238206ieb.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 22:39:21 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 2 Jun 2015 07:39:21 +0200
Message-ID: <CACna6rx7WRhsie6EX8MGrUAAdFGEV4+qtzBhM7BAe-RuLkQBFA@mail.gmail.com> (sfid-20150602_073926_029906_8B5AB1E4)
Subject: brcmfmac: error creating p2p
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: brcm80211 development <brcm80211-dev-list@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think brcmfmac may have some problems with mixing various
interfaces, so just for some test I decided to try p2p interface. I'm
using BCM43602 and it seems to support p2p:
# iw phy phy0 info | tail
        valid interface combinations:
                 * #{ IBSS, managed } <= 1, #{ AP } <= 4, #{
P2P-client, P2P-GO } <= 1, #{ P2P-device } <= 1,
                   total <= 3, #channels <= 1

But I can't create p2p interface:
# iw phy phy0 interface add p2p0 type __p2pdev
brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
brcmfmac: brcmf_add_if: ignore IF event
brcmfmac: brcmf_p2p_set_firmware: failed to update device address ret -52
brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
command failed: Invalid exchange (-52)

-- 
Rafał
