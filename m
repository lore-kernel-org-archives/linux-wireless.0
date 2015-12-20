Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from client-94-155-49-84.ip.daticum.com ([94.155.49.84]:60734 "EHLO
	client-94-155-49-84.ip.daticum.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbbLTUlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 15:41:52 -0500
Received: from [192.168.1.4] ([50.39.160.87]:52188)
	by client-94-155-49-84.ip.daticum.com with [XMail 1.27 ESMTP Server]
	id <S12134> for <linux-wireless@vger.kernel.org> from <martin@sigmadrone.org>;
	Sun, 20 Dec 2015 22:32:42 +0200
To: linux-wireless@vger.kernel.org
From: Martin Stoilov <martin@sigmadrone.org>
Subject: Broadcom AP failure
Message-ID: <5677109E.1000209@sigmadrone.org> (sfid-20151220_214225_605743_E5C7912D)
Date: Sun, 20 Dec 2015 12:33:34 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am running AP with Broadcom 4330. Occasionally, I am getting failures with the following stack trace. Any idea what the problem might be here?

Best Regards,
-Martin

------------[ cut here ]------------
WARNING: CPU: 0 PID: 550 at /home/mstoilov/workspace-yocto/fsl-community-bsp/build-colibri-lsb/tmp/work-shared/colibri/kernel-source/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:1076 brcmf_netdev_wait_pend8021x+0xe8/0xfc [brcmfmac]()
Modules linked in: bnep mxc_v4l2_capture ipu_bg_overlay_sdc ipu_still ipu_prp_enc ipu_csi_enc ipu_fg_overlay_sdc ov5640_camera_mipi v4l2_int_device fusion_ts brcmfmac brcmutil galcore(O)
CPU: 0 PID: 550 Comm: hostapd Tainted: G           O 3.14.28-1.0.0-colibri+g9432ee0 #1
[<800149dc>] (unwind_backtrace) from [<800116c0>] (show_stack+0x10/0x14)
[<800116c0>] (show_stack) from [<806bc6e0>] (dump_stack+0x7c/0xbc)
[<806bc6e0>] (dump_stack) from [<8002ee28>] (warn_slowpath_common+0x6c/0x88)
[<8002ee28>] (warn_slowpath_common) from [<8002eee0>] (warn_slowpath_null+0x1c/0x24)
[<8002eee0>] (warn_slowpath_null) from [<7f062810>] (brcmf_netdev_wait_pend8021x+0xe8/0xfc [brcmfmac])
[<7f062810>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<7f051528>] (send_key_to_dongle+0x78/0xc0 [brcmfmac])
[<7f051528>] (send_key_to_dongle [brcmfmac]) from [<7f053f70>] (brcmf_cfg80211_add_key+0x13c/0x2d8 [brcmfmac])
[<7f053f70>] (brcmf_cfg80211_add_key [brcmfmac]) from [<80673390>] (nl80211_new_key+0x100/0x180)
[<80673390>] (nl80211_new_key) from [<80576c3c>] (genl_rcv_msg+0x234/0x3a8)
[<80576c3c>] (genl_rcv_msg) from [<805761e0>] (netlink_rcv_skb+0xb4/0xd8)
[<805761e0>] (netlink_rcv_skb) from [<805769f8>] (genl_rcv+0x24/0x34)
[<805769f8>] (genl_rcv) from [<80575b3c>] (netlink_unicast+0x150/0x1f8)
[<80575b3c>] (netlink_unicast) from [<80575f54>] (netlink_sendmsg+0x2a8/0x380)
[<80575f54>] (netlink_sendmsg) from [<8053b900>] (sock_sendmsg+0x70/0x94)
[<8053b900>] (sock_sendmsg) from [<8053c928>] (___sys_sendmsg.part.6+0x280/0x294)
[<8053c928>] (___sys_sendmsg.part.6) from [<8053db84>] (__sys_sendmsg+0x4c/0x78)
[<8053db84>] (__sys_sendmsg) from [<8000e420>] (ret_fast_syscall+0x0/0x30)
---[ end trace 7f13e345ab132bc9 ]---

