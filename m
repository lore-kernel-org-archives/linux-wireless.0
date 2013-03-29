Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:56790 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757059Ab3C2VeV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 17:34:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "mfuzzey@parkeon.com" <mfuzzey@parkeon.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 29 Mar 2013 14:32:06 -0700
Subject: RE: Firmware problems with Lesswire Wibear  11n module using mwifiex
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DCBF173@SC-VEXCH1.marvell.com> (sfid-20130329_223429_171857_CDF6CE72)
References: <5155BF92.2020704@parkeon.com>
In-Reply-To: <5155BF92.2020704@parkeon.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

> [ 2210.066680] mwifiex_sdio mmc1:0001:1: WLAN FW is active
> [ 2220.083880] mwifiex_sdio mmc1:0001:1: mwifiex_cmd_timeout_func:
> Timeout cmd id (1584563353.27844) = 0xa9, act = 0x0
> 
> This shows that there is no reply to the first command sent in
> mwifiex_sta_init_cmd()

There is a possibility that the firmware has responded to this command but the SDIO interrupt gets stuck somewhere.

Are you able to hook up an oscilloscope to check whether SDIO DAT1 pin stays low or not?

Thanks,
Bing

