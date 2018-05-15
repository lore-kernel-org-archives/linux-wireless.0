Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54303 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752614AbeEOJE2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:04:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 52801224FA
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 05:04:28 -0400 (EDT)
Message-Id: <1526375068.3635953.1372486632.0BF16E64@webmail.messagingengine.com> (sfid-20180515_110504_737280_398D432C)
From: Bruno Bischofberger <bischofberger@fastmail.com>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Date: Tue, 15 May 2018 11:04:28 +0200
Subject: BCM4356 still does not initalize after firmware update
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list 

I'm still having trouble with bcm4356 on a Lenovo L460 previously reported here [1] (a Arch Linux bug report including the responsible git commit can also be found here [2]). The last working firmware version was 20170907. With all newer including the latest 20180507 I get

[    6.170608] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
[    6.195769] brcmfmac 0000:03:00.0: Direct firmware load for brcm/brcmfmac4356-pcie.txt failed with error -2
...
[    8.800086] brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
[    8.800239] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -5
[    8.800368] brcmfmac: brcmf_bus_started: failed: -5
[    8.800467] brcmfmac: brcmf_pcie_attach_bus: dongle is not responding



Including the proposed nvram-File in [1] doesn't help. With this file I get

[    4.860528] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
...
[    7.620082] brcmfmac: brcmf_pcie_download_fw_nvram: FW failed to initialize



Here is my "cat /sys/kernel/debug/brcmfmac/0000:03:00.0/revinfo"

vendorid: 0x14e4
deviceid: 0x43ec
radiorev: 0.41.32.105
chipnum: 17238 (4356)
chiprev: 2
chippkg: 2
corerev: 48
boardid: 0x0777
boardvendor: 0x14e4
boardrev: P307
driverrev: 7.35.180.119
ucoderev: 0
bus: 0
phytype: 11
phyrev: 17
anarev: 0
nvramrev: 00000000
clmver: API: 12.1
Data: 7.10.16
Compiler: 1.21.1
ClmImport: 1.21.1
Creation: 2014-02-13 17:00:38
Inc Data: 9.4.0
Inc Compiler: 1.27.1
Inc ClmImport: 1.29.22
Creation: 2015-10-22 06:04:56


Thanks for any help.

Bruno





[1] https://marc.info/?l=linux-wireless&m=151318162616627&w=2
[2] https://bugs.archlinux.org/task/56719?project=1&pagenum=3
