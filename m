Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:41988 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdLNJNb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 04:13:31 -0500
Received: by mail-qt0-f177.google.com with SMTP id g9so7102903qth.9
        for <linux-wireless@vger.kernel.org>; Thu, 14 Dec 2017 01:13:31 -0800 (PST)
Subject: Re: BCM4356 does not initalize after firmware update
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <20171213161257.GB2811@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A3240B9.90007@broadcom.com> (sfid-20171214_101337_675835_21335BB9)
Date: Thu, 14 Dec 2017 10:13:29 +0100
MIME-Version: 1.0
In-Reply-To: <20171213161257.GB2811@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2017 5:12 PM, Stanislaw Gruszka wrote:
> Hi
>
> After firmware update, this device:
>
> [0280]: Broadcom Limited BCM4356 802.11ac Wireless Network Adapter [14e4:43ec] (rev 02)
>
> no longer initialize. With the firmware update I have:
>
> [  272.063814] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
> [  272.529582] brcmfmac 0000:03:00.0: irq 31 for MSI/MSI-X
> [  274.529476] brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> [  274.537356] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -5
> [  274.544881] brcmfmac: brcmf_bus_started: failed: -5
> [  274.549854] brcmfmac: brcmf_pcie_attach_bus: dongle is not responding
>
> and no wlan device is created. With older version of the firmware I have:
>
> [   10.716878] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
> [   11.312875] brcmfmac 0000:03:00.0: irq 31 for MSI/MSI-X
> [   11.314735] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Oct 22 2015 06:16:41 version 7.35.180.119 (r594535) FWID 01-1a5c4016
> [   16.598211] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
> [   16.604416] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlp3s0 type 10 failed: err=-16
>
> and despite P2P errors, device works correctly.

The cur_etheraddr is the first piece of info we try to get from the 
firmware. Could you build the driver with CONFIG_BRCMDBG and load the 
module with 'debug=0x181416'.

Regards,
Arend
