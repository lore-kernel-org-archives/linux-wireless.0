Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36780 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756013AbcKKJQ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 04:16:57 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: RE: Problems getting mwifiex with sd8887 to work
Date: Fri, 11 Nov 2016 09:16:51 +0000
Message-ID: <507fff29bd2048c2b2295beb451943b5@SC-EXCH04.marvell.com> (sfid-20161111_101704_474815_2D21F204)
References: <20161110175915.GB1585@katana>
In-Reply-To: <20161110175915.GB1585@katana>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Wolfram Sang [mailto:wsa@the-dreams.de]
> Sent: Thursday, November 10, 2016 11:29 PM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Nishant Sarmukadam; Kalle Valo
> Subject: Problems getting mwifiex with sd8887 to work
> 
> Hi,
> 
> I am trying to get a SD8887 based SDIO card to work with my Renesas H3
> Salvator-X board. The card is either a u-blox emmy-w1-evk or a ZComax
> AC-180M, I am evaluating both. I really prefer to run the upstream
> driver instead of the paperwork protected and surprisingly old custom
> ones.
> 
> However, for both cards, I run into an error I cannot parse:
> 
> [    4.028588] mwifiex_sdio mmc2:0001:1: mwifiex_process_cmdresp: cmd
> 0x242 failed during	initialization
> 
> I use a v4.9-rc2 based tree called 'renesas-drives' [1] which has a few
> Renesas specific patches on top but nothing mwifiex related AFAICT. I
> use the firmware from the linux-firmware tree.
> 
> Any further use of the interface mlan0 or reading eeprom via debugfs
> will result in a timeout.
> 
> [   18.146710] mwifiex_sdio mmc2:0001:1: mwifiex_cmd_timeout_func:
> Timeout cmd id = 0x10, act = 0x1
> 
> I assume this is a follow-up problem so I skip the logs for these
> timeouts (can easily send them, of course, in case they are
> interesting). I'll attach a full debug output from mwifiex from
> insertion until the initial 0x242 error.
> 
> For full disclaimer, I am the maintainer of the underlying Renesas SD
> driver and I want to use this setup to create a test scenario for SDIO
> with UHS speeds. So, if there is something wrong in the SD part, I'll
> happily hack on that.
> 
> But for now, I simply would need a starting point :) 0x242 is
> "HostCmd_CMD_CHAN_REGION_CFG". Could this mean it cannot load
> configuration data? I did search around but couldn't find anything
> useful.


0x242 command failure is expected for sd8887, as It's not supported. Driver shouldn't abort initialization in this case. You can try below change. I will prepare a patch to send this command based on firmware version/capability.

-------
@ -2304,8 +2304,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
                                return -1;
                }

-               mwifiex_send_cmd(priv, HostCmd_CMD_CHAN_REGION_CFG,
-                                HostCmd_ACT_GEN_GET, 0, NULL, true);
+//             mwifiex_send_cmd(priv, HostCmd_CMD_CHAN_REGION_CFG,
+//                              HostCmd_ACT_GEN_GET, 0, NULL, true);
        }
---------

Regards,
Amitkumar
