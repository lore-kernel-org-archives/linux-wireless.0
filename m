Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ssl.serverraum.org ([88.198.40.39]:35044 "EHLO
	ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbbA3DYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 22:24:01 -0500
Message-ID: <54CAF946.4010202@m-labs.hk> (sfid-20150130_042408_677592_00D1AF33)
Date: Fri, 30 Jan 2015 11:23:50 +0800
From: Sebastien Bourdeauducq <sb@m-labs.hk>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: "brcmfmac: brcmf_sdio_htclk: HT Avail timeout" on Thinkpad Tablet
 10
References: <54C88C7D.707@m-labs.hk> <54CA8DE3.7050106@broadcom.com>
In-Reply-To: <54CA8DE3.7050106@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Friday, January 30, 2015 03:45 AM, Arend van Spriel wrote:
> If you can send a log with
> brcmfmac loaded with parameter 'debug=0x1416' that may give me some more
> clues.

Here it is:
[ 2360.049440] brcmfmac: brcmf_sdiod_sgtable_alloc nents=35
[ 2360.049464] brcmfmac: brcmf_sdio_probe Enter
[ 2360.054792] brcmfmac: F1 signature read @0x18000000=0x16864324
[ 2360.056741] brcmfmac: brcmf_bus_change_state 0 -> 2
[ 2360.062095] brcmfmac: brcmf_chip_recognition found AXI chip: BCM4324, 
rev=6
[ 2360.174030] brcmfmac: brcmf_chip_cores_check  [1 ] core 0x800:42 base 
0x18000000 wrap 0x18100000
[ 2360.174054] brcmfmac: brcmf_chip_cores_check  [2 ] core 0x812:36 base 
0x18001000 wrap 0x18101000
[ 2360.174060] brcmfmac: brcmf_chip_cores_check  [3 ] core 0x829:18 base 
0x18002000 wrap 0x18102000
[ 2360.174065] brcmfmac: brcmf_chip_cores_check  [4 ] core 0x82a:7  base 
0x18003000 wrap 0x18103000
[ 2360.174070] brcmfmac: brcmf_chip_cores_check  [5 ] core 0x80e:20 base 
0x18004000 wrap 0x18104000
[ 2360.174075] brcmfmac: brcmf_chip_cores_check  [6 ] core 0x81a:16 base 
0x18005000 wrap 0x18105000
[ 2360.174080] brcmfmac: brcmf_chip_cores_check  [7 ] core 0x135:0  base 
0x1810a000 wrap 0x18107000
[ 2360.179471] brcmfmac: brcmf_chip_setup ccrev=42, pmurev=17, 
pmucaps=0x298c5f11
[ 2360.185890] brcmfmac: brcmf_sdio_kso_init Enter
[ 2360.186677] brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive 
strength init done for chip 4324 rev 6 pmurev 17
[ 2360.194797] brcmfmac: brcmf_attach Enter
[ 2360.194839] brcmfmac: brcmf_proto_attach Enter
[ 2360.198000] brcmfmac: brcmf_sdio_probe completed!!
[ 2360.198010] brcmfmac: brcmf_fw_get_firmwares enter: dev=mmc1:0001:1
[ 2360.198132] usbcore: registered new interface driver brcmfmac
[ 2360.198544] brcmfmac: brcmf_fw_request_code_done enter: dev=mmc1:0001:1
[ 2360.198617] brcmfmac: brcmf_fw_request_nvram_done enter: dev=mmc1:0001:1
[ 2360.198680] brcmfmac: brcmf_sdio_firmware_callback Enter: dev=mmc1:0001:1
[ 2360.199953] brcmfmac: brcmf_chip_enter_download Enter
[ 2360.216692] brcmfmac: brcmf_sdio_download_code_file Enter
[ 2362.872129] brcmfmac: brcmf_sdio_verifymemory Compare RAM dl & ul at 
0x00000000; size=403855
[ 2366.982029] brcmfmac: brcmf_sdio_download_nvram Enter
[ 2367.003592] brcmfmac: brcmf_sdio_verifymemory Compare RAM dl & ul at 
0x0008f85c; size=1956
[ 2367.025285] brcmfmac: brcmf_chip_exit_download Enter
[ 2367.043627] brcmfmac: brcmf_bus_change_state 2 -> 3
[ 2368.055540] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): 
clkctl 0x50
[ 2368.055552] brcmfmac: brcmf_sdio_firmware_callback failed: 
dev=mmc1:0001:1, err=0
[ 2368.055571] brcmfmac: brcmf_sdio_remove Enter
[ 2368.058820] brcmfmac: brcmf_detach Enter
[ 2368.058830] brcmfmac: brcmf_bus_change_state 3 -> 2
[ 2368.058834] brcmfmac: brcmf_bus_detach Enter
[ 2368.058838] brcmfmac: brcmf_sdio_bus_stop Enter
[ 2369.066333] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): 
clkctl 0x50
[ 2369.076908] brcmfmac: brcmf_proto_detach Enter
[ 2370.091185] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): 
clkctl 0x50
[ 2370.112802] brcmfmac: brcmf_chip_enter_download Enter
[ 2370.141772] brcmfmac: brcmf_sdio_remove Disconnected

Thanks,
Sebastien
