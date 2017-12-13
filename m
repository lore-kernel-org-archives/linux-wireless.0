Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753144AbdLMQNm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 11:13:42 -0500
Date: Wed, 13 Dec 2017 17:12:57 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: BCM4356 does not initalize after firmware update
Message-ID: <20171213161257.GB2811@redhat.com> (sfid-20171213_171401_471060_7D1B423F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

After firmware update, this device:

[0280]: Broadcom Limited BCM4356 802.11ac Wireless Network Adapter [14e4:43ec] (rev 02)

no longer initialize. With the firmware update I have:

[  272.063814] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
[  272.529582] brcmfmac 0000:03:00.0: irq 31 for MSI/MSI-X
[  274.529476] brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
[  274.537356] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -5
[  274.544881] brcmfmac: brcmf_bus_started: failed: -5
[  274.549854] brcmfmac: brcmf_pcie_attach_bus: dongle is not responding

and no wlan device is created. With older version of the firmware I have:

[   10.716878] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
[   11.312875] brcmfmac 0000:03:00.0: irq 31 for MSI/MSI-X
[   11.314735] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Oct 22 2015 06:16:41 version 7.35.180.119 (r594535) FWID 01-1a5c4016
[   16.598211] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
[   16.604416] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlp3s0 type 10 failed: err=-16

and despite P2P errors, device works correctly.

Regards
Stanislaw
