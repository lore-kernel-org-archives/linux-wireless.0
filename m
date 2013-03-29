Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta1.parkeon.com ([91.121.43.66]:60835 "EHLO mta1.parkeon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab3C2REf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 13:04:35 -0400
Received: from ip71.parkeon.com ([213.152.31.71] helo=mta2.parkeon.com)
	by mta1.parkeon.com with esmtp (Exim 4.76)
	(envelope-from <mfuzzey@parkeon.com>)
	id 1ULc3e-0006fq-LJ
	for linux-wireless@vger.kernel.org; Fri, 29 Mar 2013 17:21:38 +0100
Received: from [10.32.16.23] (helo=mail.besancon.parkeon.com)
	by mta2.parkeon.com with esmtp (Exim 4.77)
	(envelope-from <mfuzzey@parkeon.com>)
	id 1ULc3b-0003JS-MT
	for linux-wireless@vger.kernel.org; Fri, 29 Mar 2013 17:21:35 +0100
Received: from [10.32.51.221] (port=56960)
	by mail.besancon.parkeon.com with esmtp (Exim 4.71)
	(envelope-from <mfuzzey@parkeon.com>)
	id 1ULc3e-0004W7-GP
	for linux-wireless@vger.kernel.org; Fri, 29 Mar 2013 17:21:38 +0100
Message-ID: <5155BF92.2020704@parkeon.com> (sfid-20130329_180440_640197_34663CA0)
Date: Fri, 29 Mar 2013 17:21:38 +0100
From: Martin Fuzzey <mfuzzey@parkeon.com>
Reply-To: mfuzzey@parkeon.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Firmware problems with Lesswire Wibear  11n module using mwifiex
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have a Lesswire Wibear 11n combined wifi / bluetooth module with SDIO 
interface.
This has a Marvell 8787 chipset and is recognized by the mainline 
(3.9-rc4) kernel.

It detects the module and asks for the  sd8787_uapsta.bin firmware.

I got that from the Marvell git repo at 
git://git.marvell.com/mwifiex-firmware.git
Using this latest commit:

commit dd7193bc187a5182a6236cb6337699d2229c54b0
Author: Bing Zhao <bzhao@marvell.com>
Date:   Thu Aug 30 12:42:05 2012 -0700

     linux-firmware: update Marvell SD8787 firmware image

     Version 14.66.9.p96

     Signed-off-by: Bing Zhao <bzhao@marvell.com>
     Signed-off-by: Frank Huang <frankh@marvell.com>


The firmware is loaded OK but then a timeout occurs on the first command 
sent to the module.

Here are the logs on module insertion (with a few extra logs of my own 
@MF@ added):

[ 2209.048302] mmc1: new high speed SDIO card at address 0001
[ 2209.059313] mwifiex_sdio: info: vendor=0x02DF device=0x9119 class=0 
function=1
[ 2209.061188] mwifiex_sdio: info: SDIO FUNC1 IO port: 0x10000
[ 2209.069929] mwifiex_sdio mmc1:0001:1: @MF@ mwifiex_fw_dpc (null)
[ 2209.184008] mwifiex_sdio mmc1:0001:1: @MF@ checks ok
[ 2209.189008] mwifiex_sdio mmc1:0001:1: @MF@ do prog_fw
[ 2209.194150] mwifiex_sdio mmc1:0001:1: info: downloading FW image 
(447384 bytes)
[ 2209.865231] mwifiex_sdio mmc1:0001:1: info: FW download over, size 
447384 bytes
[ 2210.066680] mwifiex_sdio mmc1:0001:1: WLAN FW is active
[ 2210.072069] mwifiex_sdio mmc1:0001:1: cmd: QUEUE_CMD: cmd=0xa9 is queued
[ 2210.072095] mwifiex_sdio mmc1:0001:1: cmd pending
[ 2210.072167] mwifiex_sdio mmc1:0001:1: cmd: DNLD_CMD: 
(1584563343.16158): 0xa9, act 0x0, len 8, seqno 0x1
[ 2210.072192] mwifiex_sdio mmc1:0001:1: info: 
mwifiex_host_to_card_mp_aggr: tx aggregation disabled
[ 2210.072208] mwifiex_sdio mmc1:0001:1: data: 
mwifiex_host_to_card_mp_aggr: send current buffer 0
[ 2220.083880] mwifiex_sdio mmc1:0001:1: mwifiex_cmd_timeout_func: 
Timeout cmd id (1584563353.27844) = 0xa9, act = 0x0
[ 2220.094397] mwifiex_sdio mmc1:0001:1: num_data_h2c_failure = 0
[ 2220.100244] mwifiex_sdio mmc1:0001:1: num_cmd_h2c_failure = 0
[ 2220.106033] mwifiex_sdio mmc1:0001:1: num_cmd_timeout = 1
[ 2220.111442] mwifiex_sdio mmc1:0001:1: num_tx_timeout = 0
[ 2220.116790] mwifiex_sdio mmc1:0001:1: last_cmd_index = 1
[ 2220.122114] mwifiex_sdio mmc1:0001:1: last_cmd_id: 00 00 a9 00 00 00 
00 00 00 00
[ 2220.129552] mwifiex_sdio mmc1:0001:1: last_cmd_act: 00 00 00 00 00 00 
00 00 00 00
[ 2220.137075] mwifiex_sdio mmc1:0001:1: last_cmd_resp_index = 0
[ 2220.142831] mwifiex_sdio mmc1:0001:1: last_cmd_resp_id: 00 00 00 00 
00 00 00 00 00 00
[ 2220.150693] mwifiex_sdio mmc1:0001:1: last_event_index = 0
[ 2220.156211] mwifiex_sdio mmc1:0001:1: last_event: 00 00 00 00 00 00 
00 00 00 00
[ 2220.163531] mwifiex_sdio mmc1:0001:1: data_sent=1 cmd_sent=1
[ 2220.169222] mwifiex_sdio mmc1:0001:1: ps_mode=0 ps_state=0
[ 2220.174754] mwifiex_sdio mmc1:0001:1: cmd completed: status=-110
[ 2220.174771] mwifiex_sdio mmc1:0001:1: cmd timeout
[ 2220.180621] mwifiex_sdio mmc1:0001:1: @MF@ mwifiex_send_cmd_sync B 
failed -1
[ 2220.187794] mwifiex_sdio mmc1:0001:1: @MF@ mwifiex_sta_init_cmd failed
[ 2220.194391] mwifiex_sdio mmc1:0001:1: @MF@ mwifiex_init_fw ret=-1

This shows that there is no reply to the first command sent in 
mwifiex_sta_init_cmd()

         ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_FUNC_INIT,
                         HostCmd_ACT_GEN_SET, 0, NULL);
         if (ret) {
             dev_info(priv->adapter->dev, "@MF@ mwifiex_send_cmd_sync B 
failed %d\n", ret);
             return -1;
         }

I've also tried the other two versions (14.66.9.p80 and 14.57.5.p44) int 
the git repo mentionned above with the same results

Any ideas?

Regards

Martin

