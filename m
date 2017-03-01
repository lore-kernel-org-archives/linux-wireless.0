Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp2.bon.at ([213.33.87.16]:45351 "EHLO bsmtp2.bon.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752342AbdCAUN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 15:13:58 -0500
Received: from bsmtp.bon.at (unknown [192.168.181.106])
        by bsmtp2.bon.at (Postfix) with ESMTPS id 3vYQDK6fmxz5vV8
        for <linux-wireless@vger.kernel.org>; Wed,  1 Mar 2017 20:16:49 +0100 (CET)
To: linux-wireless@vger.kernel.org, akarwar@marvell.com
From: Martin Pietryka <martin.pietryka@streamunlimited.com>
Subject: [mwifiex] seemingly random crashes on 8897
Message-ID: <15c5b4b1-3c06-a115-9cf5-a66cc90d6ebc@streamunlimited.com> (sfid-20170301_211401_472282_89A7BB45)
Date: Wed, 1 Mar 2017 20:15:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

we are running a 4.1 kernel and we have some instabilities using the 
8897 over PCIe on an imx7 cpu.

We have observed crashes which look like the logs at the end. I'm not 
sure if they are all somehow related.

As already mentioned we are using the 4.1 kernel from NXP with some 
patches for the mwifiex driver backported from a more recent kernel,
these additional patches are the following:
   * mwifiex: enable MSI interrupt support in pcie
   * mwifiex: using right tid for addressing ra_list
   * mwifiex: do not short circuit exit from mwifiex_set_mgmt_ies

I know that in the a more recent drivers there were some changes to the 
interrupt handling, etc. So maybe there is an issue here. Especially 
with MSI enabled.

Anybody got an idea?


Best regards,

Martin


Sometimes we see lots of these messages, WiFi continues to work:
[ 4108.037449] mwifiex_pcie 0000:01:00.0: CMD_RESP: invalid cmd resp
[ 4108.398976] mwifiex_pcie 0000:01:00.0: There is no command but got cmdrsp
[ 4119.549181] mwifiex_pcie 0000:01:00.0: CMD_RESP: invalid cmd resp
[ 4119.899053] mwifiex_pcie 0000:01:00.0: There is no command but got cmdrsp
[ 4193.769062] mwifiex_pcie 0000:01:00.0: CMD_RESP: invalid cmd resp
[ 4194.141753] mwifiex_pcie 0000:01:00.0: There is no command but got cmdrsp
[ 4413.821362] mwifiex_pcie 0000:01:00.0: CMD_RESP: invalid cmd resp
[ 4414.491489] mwifiex_pcie 0000:01:00.0: There is no command but got cmdrsp
[ 4490.359042] mwifiex_pcie 0000:01:00.0: CMD_RESP: invalid cmd resp
[ 4490.705755] mwifiex_pcie 0000:01:00.0: There is no command but got cmdrsp
[ 4587.521240] mwifiex_pcie 0000:01:00.0: CMD_RESP: invalid cmd resp
[ 4587.877673] mwifiex_pcie 0000:01:00.0: There is no command but got cmdrsp
[ 4601.168747] mwifiex_pcie 0000:01:00.0: CMD_RESP: invalid cmd resp
[ 4601.680754] mwifiex_pcie 0000:01:00.0: There is no command but got cmdrsp

One of the crashes
[  123.004165] mwifiex_pcie 0000:01:00.0: mwifiex_cmd_timeout_func: 
Timeout cmd id = 0x10, act = 0x1
[  123.013072] mwifiex_pcie 0000:01:00.0: num_data_h2c_failure = 0
[  123.019026] mwifiex_pcie 0000:01:00.0: num_cmd_h2c_failure = 0
[  123.024886] mwifiex_pcie 0000:01:00.0: is_cmd_timedout = 1
[  123.030378] mwifiex_pcie 0000:01:00.0: num_tx_timeout = 0
[  123.035798] mwifiex_pcie 0000:01:00.0: last_cmd_index = 0
[  123.041205] mwifiex_pcie 0000:01:00.0: last_cmd_id: 10 00 07 01 07 01 
07 01 cf 00
[  123.048709] mwifiex_pcie 0000:01:00.0: last_cmd_act: 01 00 00 00 00 
00 00 00 00 34
[  123.056301] mwifiex_pcie 0000:01:00.0: last_cmd_resp_index = 4
[  123.062142] mwifiex_pcie 0000:01:00.0: last_cmd_resp_id: 07 81 07 81 
07 01 07 01 07 81
[  123.070078] mwifiex_pcie 0000:01:00.0: last_event_index = 1
[  123.075672] mwifiex_pcie 0000:01:00.0: last_event: 33 00 0a 00 33 00 
33 00 33 00
[  123.083075] mwifiex_pcie 0000:01:00.0: data_sent=0 cmd_sent=1
[  123.088841] mwifiex_pcie 0000:01:00.0: ps_mode=1 ps_state=0
[  123.094470] mwifiex_pcie 0000:01:00.0: == mwifiex firmware dump start ==
[  123.102229] mwifiex_pcie 0000:01:00.0: ITCM_SIZE=0x10000
[  123.107778] mwifiex_pcie 0000:01:00.0: Start ITCM output, please wait...
[  125.579854] mwifiex_pcie 0000:01:00.0: ITCM done: size=0x10000
[  125.586025] mwifiex_pcie 0000:01:00.0: DTCM_SIZE=0x8000
[  125.591300] mwifiex_pcie 0000:01:00.0: Start DTCM output, please wait...
[  126.842731] mwifiex_pcie 0000:01:00.0: DTCM done: size=0x8000
[  126.848813] mwifiex_pcie 0000:01:00.0: SQRAM_SIZE=0xa0000
[  126.854653] mwifiex_pcie 0000:01:00.0: Start SQRAM output, please wait...
[  151.729030] mwifiex_pcie 0000:01:00.0: SQRAM done: size=0xa0000
[  151.735299] mwifiex_pcie 0000:01:00.0: IRAM_SIZE=0x58000
[  151.740729] mwifiex_pcie 0000:01:00.0: Start IRAM output, please wait...
[  165.469182] mwifiex_pcie 0000:01:00.0: IRAM done: size=0x58000
[  165.475357] mwifiex_pcie 0000:01:00.0: APU_SIZE=0x350
[  165.480449] mwifiex_pcie 0000:01:00.0: Start APU output, please wait...
[  165.519799] mwifiex_pcie 0000:01:00.0: APU done: size=0x350
[  165.525712] mwifiex_pcie 0000:01:00.0: CIU_SIZE=0x1000
[  165.530873] mwifiex_pcie 0000:01:00.0: Start CIU output, please wait...
[  165.692101] mwifiex_pcie 0000:01:00.0: CIU done: size=0x1000
[  165.698105] mwifiex_pcie 0000:01:00.0: ICU_SIZE=0x110
[  165.703175] mwifiex_pcie 0000:01:00.0: Start ICU output, please wait...
[  165.720419] mwifiex_pcie 0000:01:00.0: ICU done: size=0x110
[  165.726270] mwifiex_pcie 0000:01:00.0: MAC_SIZE=0x1dc0
[  165.731432] mwifiex_pcie 0000:01:00.0: Start MAC output, please wait...
[  166.027001] mwifiex_pcie 0000:01:00.0: MAC done: size=0x1dc0
[  166.032971] mwifiex_pcie 0000:01:00.0: Firmware dump Finished!
[  166.039021] mwifiex_pcie 0000:01:00.0: == mwifiex firmware dump end ==

Another crash with a differenc cmd id:
[   66.523837] mwifiex_pcie 0000:01:00.0: mwifiex_cmd_timeout_func: 
Timeout cmd id = 0x107, act = 0x0
[   66.532817] mwifiex_pcie 0000:01:00.0: num_data_h2c_failure = 0
[   66.538762] mwifiex_pcie 0000:01:00.0: num_cmd_h2c_failure = 0
[   66.544624] mwifiex_pcie 0000:01:00.0: is_cmd_timedout = 1
[   66.550122] mwifiex_pcie 0000:01:00.0: num_tx_timeout = 0
[   66.555546] mwifiex_pcie 0000:01:00.0: last_cmd_index = 1
[   66.560953] mwifiex_pcie 0000:01:00.0: last_cmd_id: 07 01 07 01 07 01 
10 00 ce 00
[   66.568464] mwifiex_pcie 0000:01:00.0: last_cmd_act: 00 00 00 00 00 
00 01 00 00 10
[   66.576056] mwifiex_pcie 0000:01:00.0: last_cmd_resp_index = 0
[   66.581895] mwifiex_pcie 0000:01:00.0: last_cmd_resp_id: 07 01 07 81 
07 81 07 01 07 01
[   66.589834] mwifiex_pcie 0000:01:00.0: last_event_index = 0
[   66.595431] mwifiex_pcie 0000:01:00.0: last_event: 0a 00 58 00 58 00 
58 00 0a 00
[   66.602833] mwifiex_pcie 0000:01:00.0: data_sent=0 cmd_sent=1
[   66.608612] mwifiex_pcie 0000:01:00.0: ps_mode=1 ps_state=0
[   66.614209] mwifiex_pcie 0000:01:00.0: cmd timeout
[   66.619045] mwifiex_pcie 0000:01:00.0: == mwifiex firmware dump start ==
[   66.635674] mwifiex_pcie 0000:01:00.0: ITCM_SIZE=0x10000
[   66.641046] mwifiex_pcie 0000:01:00.0: Start ITCM output, please wait...
[   68.915215] mwifiex_pcie 0000:01:00.0: ITCM done: size=0x10000
[   68.921358] mwifiex_pcie 0000:01:00.0: DTCM_SIZE=0x8000
[   68.926963] mwifiex_pcie 0000:01:00.0: Start DTCM output, please wait...
[   70.059221] mwifiex_pcie 0000:01:00.0: DTCM done: size=0x8000
[   70.065312] mwifiex_pcie 0000:01:00.0: SQRAM_SIZE=0xa0000
[   70.070855] mwifiex_pcie 0000:01:00.0: Start SQRAM output, please wait...
[   92.691599] mwifiex_pcie 0000:01:00.0: SQRAM done: size=0xa0000
[   92.697994] mwifiex_pcie 0000:01:00.0: IRAM_SIZE=0x58000
[   92.703405] mwifiex_pcie 0000:01:00.0: Start IRAM output, please wait...
[  105.157862] mwifiex_pcie 0000:01:00.0: IRAM done: size=0x58000
[  105.164083] mwifiex_pcie 0000:01:00.0: APU_SIZE=0x350
[  105.169228] mwifiex_pcie 0000:01:00.0: Start APU output, please wait...
[  105.204942] mwifiex_pcie 0000:01:00.0: APU done: size=0x350
[  105.210823] mwifiex_pcie 0000:01:00.0: CIU_SIZE=0x1000
[  105.216002] mwifiex_pcie 0000:01:00.0: Start CIU output, please wait...
[  105.364402] mwifiex_pcie 0000:01:00.0: CIU done: size=0x1000
[  105.370432] mwifiex_pcie 0000:01:00.0: ICU_SIZE=0x110
[  105.375544] mwifiex_pcie 0000:01:00.0: Start ICU output, please wait...
[  105.391618] mwifiex_pcie 0000:01:00.0: ICU done: size=0x110
[  105.397459] mwifiex_pcie 0000:01:00.0: MAC_SIZE=0x1dc0
[  105.402614] mwifiex_pcie 0000:01:00.0: Start MAC output, please wait...
[  105.670126] mwifiex_pcie 0000:01:00.0: MAC done: size=0x1dc0
[  105.676154] mwifiex_pcie 0000:01:00.0: Firmware dump Finished!
[  105.681995] mwifiex_pcie 0000:01:00.0: == mwifiex firmware dump end ==
