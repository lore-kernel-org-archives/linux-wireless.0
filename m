Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail02.raumopol.de ([89.238.79.3]:59829 "EHLO
	mail02.raumopol.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab3IKUtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 16:49:35 -0400
Received: from mail03.raumopol.de (mail03.localnet.raumopol.de [192.168.1.10])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail02.raumopol.de (Postfix) with ESMTPS id 1653C214C2CB
	for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 22:35:25 +0200 (CEST)
Received: from authenticated_user
	by mail03.raumopol.de (Postfix) with ESMTPSA id E78803832001
	for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 22:35:24 +0200 (CEST)
Message-ID: <5230D40B.20704@janno-kaiser.de> (sfid-20130911_224938_673783_AC240265)
Date: Wed, 11 Sep 2013 22:35:23 +0200
From: Jan-Oliver Kaiser <mail@janno-kaiser.de>
Reply-To: mail@janno-kaiser.de
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: brcmfmac, BCM43241
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to get a BCM43241 card running on a 3.11-amd64 kernel.
[1] lists the device as supported but gives no instructions on how to
install it. I managed to extract the firmware from the git binary patch
contained in [2].

I copied the firmware to /lib/firmware/brcm/brcmfmac-sdio.bin and copied
the content of /dev/nvram to /lib/firmware/brcm/brcmfmac-sdio.txt.

Previously, `dmesg` would list error that indicated missing files.
Currently, the output is as follows:

[12865.299503] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO
Drive strength init done for chip 4324 rev 5 pmurev 17
[12866.393551] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
clkctl 0x50
[12867.402386] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
clkctl 0x50
[12867.409143] brcmfmac: brcmf_proto_cdc_query_dcmd: brcmf_proto_cdc_msg
failed w/status -5
[12867.409149] brcmfmac: brcmf_fil_cmd_data: Failed err=-5
[12867.409153] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr
failed, -5
[12867.409157] brcmfmac: brcmf_bus_start: failed: -5
[12867.409167] brcmfmac: brcmf_sdbrcm_probe: dongle is not responding
[12868.416890] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
clkctl 0x50
[12869.426308] brcmfmac: brcmf_sdbrcm_htclk: HT Avail timeout (1000000):
clkctl 0x50

I have not been able to find anything to help with debugging this.

There was some discussion in response to [2] that I don't understand. Is
there something wrong with the firmware itself?

I would be very grateful for any help. I can provide all additional
information if something is missing from this report. (I can also be
reached via IRC, 'Eruquen' on freenode)

Thanks in advance,
Jan-Oliver

[1] http://wireless.kernel.org/en/users/Drivers/brcm80211
[2] http://www.spinics.net/lists/linux-wireless/msg107754.html
