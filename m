Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from walmailout02.yourhostingaccount.com ([65.254.253.155]:53782
	"EHLO walmailout02.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbcF3T5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 15:57:37 -0400
Received: from mailscan08.yourhostingaccount.com ([10.1.15.8] helo=walmailscan08.yourhostingaccount.com)
	by walmailout02.yourhostingaccount.com with esmtp (Exim)
	id 1bIha9-0007T0-TN
	for linux-wireless@vger.kernel.org; Thu, 30 Jun 2016 15:25:01 -0400
Received: from [10.114.3.31] (helo=walimpout11)
	by walmailscan08.yourhostingaccount.com with esmtp (Exim)
	id 1bIha9-0003Bk-MV
	for linux-wireless@vger.kernel.org; Thu, 30 Jun 2016 15:25:01 -0400
Received: from c-98-216-162-149.hsd1.ma.comcast.net ([98.216.162.149]:58060 helo=laptopesk)
	by walauthsmtp09.yourhostingaccount.com with esmtpa (Exim)
	id 1bIha6-0008Ng-H2
	for linux-wireless@vger.kernel.org; Thu, 30 Jun 2016 15:24:58 -0400
From: "Michael Eskowitz" <MichaelE@inventeksys.com>
To: <linux-wireless@vger.kernel.org>
Subject: building brcmfmac driver for iMX6 Ultralite platform
Date: Thu, 30 Jun 2016 15:24:59 -0400
Message-ID: <002601d1d305$183c3070$48b49150$@inventeksys.com> (sfid-20160630_215742_037470_0EBE5A08)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to bring up the brcmfmac driver on an iMX6 Ultralite board.  I
have both a 43341 and 43362 Wi-Fi SDIO module up and running on this
platform already using the standard bcmdhd.  I am told by some Broadcom
folks that the brcmfmac driver should support concurrent connections which
is something the bcmdhd does not do and that is my primary motivation for
getting the fmac driver up and running.

The brcmfmac driver is included in NXP's kernel git and I have successfully
built it and have it on the Ultralite platform running kernel 3.14.38.  When
I attempt to insert the module using the command

	insmod  brcmfmac.ko
firmware_path=ISM4334X_Wifi_FW_6.10.190.49_P.bin
nvram_path=ISM4334X_NVRAM_C1.txt

I receive the following errors:

	brcmfmac: Unknown symbol brcmu_pktq_mlen (err 0)
	brcmfmac: Unknown symbol brcmu_pkt_buf_free_skb (err 0)
	brcmfmac: Unknown symbol brcmu_pktq_init (err 0)
	brcmfmac: Unknown symbol brcmu_pktq_penq_head (err 0)
	brcmfmac: Unknown symbol brcmu_pktq_pdeq (err 0)
	brcmfmac: Unknown symbol brcmu_pktq_peek_tail (err 0)
	brcmfmac: Unknown symbol brcmu_pktq_flush (err 0)
	brcmfmac: Unknown symbol brcmu_pktq_pdeq_match (err 0)
	brcmfmac: Unknown symbol brcmu_pktq_mdeq (err 0)
	brcmfmac: Unknown symbol brcmu_pktq_penq (err 0)
	brcmfmac: Unknown symbol brcmu_pktq_pdeq_tail (err 0)
	brcmfmac: Unknown symbol brcmu_pkt_buf_get_skb (err 0)
	brcmfmac: Unknown symbol brcmu_d11_attach (err 0)
	insmod: ERROR: could not insert module brcmfmac.ko: Unknown symbol
in module

I'm not sure that the firmware_path and nvram_path should be specified in
this manner, but I doubt that is what is causing these errors.  

The module compiled and built just fine so I am assuming that there are some
dependencies that aren't being met.  Is there another module that I need to
load before attempting to load the fmac driver?

Thanks,
-Mike




