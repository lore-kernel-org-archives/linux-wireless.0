Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49060 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbbFHMe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 08:34:56 -0400
Message-ID: <1433766944.28058.16.camel@embedded.rocks> (sfid-20150608_143459_288599_D061EA91)
Subject: brcmfmac: brcmf_p2p_create_p2pdev: timeout occurred
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Date: Mon, 08 Jun 2015 14:35:44 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've trouble creating the p2p interface on a BCM43362 wifi device
running Linux kernel 4.0.4:

    # dmesg | grep brcmfmac
    [    7.010870] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
    wl0: Apr 22 2013 14:50:00 version 5.90.195.89.6 FWID 01-b30a427d
    [    7.158905] brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166
    code
    [   11.007164] brcmfmac: brcmf_p2p_create_p2pdev: timeout occurred

Trying to add the p2p interface manually:

    # iw phy0 interface add p2p0 type __p2pdev
    [  372.042704] brcmfmac: brcmf_link_down: WLC_DISASSOC failed (-52)
    [  373.637263] brcmfmac: brcmf_p2p_create_p2pdev: timeout occurred
    [  373.679377] brcmfmac: brcmf_cfg80211_del_key: invalid key index (4)
    [  373.685733] brcmfmac: brcmf_cfg80211_del_key: invalid key index (5)

Any idea?

Best regards
Jörg Krause
