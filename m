Return-Path: <SRS0=r36G=NP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2075C32789
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 19:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8342081D
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 19:12:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-ipv6.be header.i=@linux-ipv6.be header.b="N+ms1RLj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D8342081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-ipv6.be
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbeKEE2n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 4 Nov 2018 23:28:43 -0500
Received: from mail.tintel.eu ([54.36.12.13]:56402 "EHLO mail.tintel.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbeKEE2n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Nov 2018 23:28:43 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Nov 2018 23:28:40 EST
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 7A54F424DC08
        for <linux-wireless@vger.kernel.org>; Sun,  4 Nov 2018 20:04:46 +0100 (CET)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id EISkRp2msFf9 for <linux-wireless@vger.kernel.org>;
        Sun,  4 Nov 2018 20:04:45 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id BC781424DC0E
        for <linux-wireless@vger.kernel.org>; Sun,  4 Nov 2018 20:04:45 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu BC781424DC0E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1541358285;
        bh=dHrrtA09ffhwZIW4UVSUVjyK4HZFI9I+HV6OS0zOVIk=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=N+ms1RLjNU1WgK5fcxJJtnUV5AJNATOjrLWaq7Zf/1e89ubqAF/ozIC6LCfmoNgnb
         PQSfnZqyf6IopvNkpE3VpzHj5V9Jhf2Qx5xiIiuFKNXP5A6/G9pXrORBAuxZGO3Ppx
         kroEUoaQN6JajdPLMVbBfs6zKUrmKtDv7aZ7OIlY=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id d13KEYr-PSdd for <linux-wireless@vger.kernel.org>;
        Sun,  4 Nov 2018 20:04:45 +0100 (CET)
Received: from [IPv6:2001:67c:21bc:24::adb] (taz.sof.bg.adlevio.net [IPv6:2001:67c:21bc:24::adb])
        (Authenticated sender: stijn@tintel.eu)
        by mail.tintel.eu (Postfix) with ESMTPSA id 68EAD424DC08
        for <linux-wireless@vger.kernel.org>; Sun,  4 Nov 2018 20:04:43 +0100 (CET)
To:     linux-wireless@vger.kernel.org
From:   Stijn Tintel <stijn@linux-ipv6.be>
Subject: 7f9a3e150ec7d breaks brcmfmac with modparam roamoff=1
Openpgp: preference=signencrypt
Message-ID: <109f9a63-55ff-7a39-a710-e78e562950f3@linux-ipv6.be>
Date:   Sun, 4 Nov 2018 21:04:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Commit 7f9a3e150ec7d3596386449c15aefb59904a1266 (nl80211: Update ERP
info using NL80211_CMD_UPDATE_CONNECT_PARAMS) breaks brcmfmac with
modparam roamoff=3D1, which disables WIPHY_FLAG_SUPPORTS_FW_ROAM:

# modprobe brcmfmac roamoff=3D0

[=C2=A0 325.775805] brcmfmac: F1 signature read @0x18000000=3D0x1541a9a6
[=C2=A0 325.783904] brcmfmac: brcmf_fw_alloc_request: using
brcm/brcmfmac43430-sdio for chip BCM43430/1
[=C2=A0 325.975239] brcmfmac: brcmf_fw_alloc_request: using
brcm/brcmfmac43430-sdio for chip BCM43430/1
[=C2=A0 326.004488] brcmfmac mmc1:0001:1: Direct firmware load for
brcm/brcmfmac43430-sdio.clm_blob failed with error -2
[=C2=A0 326.035141] brcmfmac mmc1:0001:1: Falling back to user helper
[=C2=A0 326.083138] firmware brcm!brcmfmac43430-sdio.clm_blob:
firmware_loading_store: map pages failed
[=C2=A0 326.108380] brcmfmac: brcmf_c_process_clm_blob: no clm_blob avail=
able
(err=3D-11), device may have limited channels available
[=C2=A0 326.139047] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM43430/1
wl0: Oct 23 2017 03:55:53 version 7.45.98.38 (r674442 CY) FWID 01-e58d219=
f
[=C2=A0 326.229364] usbcore: registered new interface driver brcmfmac
[=C2=A0 326.311507] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[=C2=A0 327.556310] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes re=
ady

# modprobe brcmfmac roamoff=3D1

[=C2=A0 258.807271] brcmfmac: F1 signature read @0x18000000=3D0x1541a9a6
[=C2=A0 258.815347] brcmfmac: brcmf_fw_alloc_request: using
brcm/brcmfmac43430-sdio for chip BCM43430/1
[=C2=A0 259.006572] brcmfmac: brcmf_fw_alloc_request: using
brcm/brcmfmac43430-sdio for chip BCM43430/1
[=C2=A0 259.035893] brcmfmac mmc1:0001:1: Direct firmware load for
brcm/brcmfmac43430-sdio.clm_blob failed with error -2
[=C2=A0 259.066544] brcmfmac mmc1:0001:1: Falling back to user helper
[=C2=A0 259.114713] firmware brcm!brcmfmac43430-sdio.clm_blob:
firmware_loading_store: map pages failed
[=C2=A0 259.140192] brcmfmac: brcmf_c_process_clm_blob: no clm_blob avail=
able
(err=3D-11), device may have limited channels available
[=C2=A0 259.171226] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM43430/1
wl0: Oct 23 2017 03:55:53 version 7.45.98.38 (r674442 CY) FWID 01-e58d219=
f
[=C2=A0 259.220697] ------------[ cut here ]------------
[=C2=A0 259.240131] WARNING: CPU: 0 PID: 50 at
/home/build/lede/build_dir/target-arm_arm1176jzf-s+vfp_musl_eabi/linux-br=
cm2708_bcm2708/backports-4.19-rc5-1/net/wireless/core.c:736
wiphy_register+0x280/0xa58 [cfg80211]
[=C2=A0 259.274067] Modules linked in: brcmfmac(+) pppoe ppp_async pppox
ppp_generic nf_conntrack_ipv6 lzo iptable_nat ipt_REJECT ipt_MASQUERADE
ftdi_sio cfg80211 xt_time xt_tcpudp xt_state xt_policy xt_nat
xt_multiport xt_mark xt_mac xt_limit xt_esp xt_conntrack xt_comment
xt_TCPMSS xt_REDIRECT xt_LOG wireguard vc4 usbserial usbhid slhc rfcomm
nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4 nf_conntrack_ipv4
nf_nat_ipv4 nf_nat nf_log_ipv4 nf_defrag_ipv6 nf_defrag_ipv4
nf_conntrack_rtcache nf_conntrack lzo_decompress lzo_compress
iptable_mangle iptable_filter ipt_ah ip_tables hidp hid_generic hci_uart
drm_kms_helper crc_ccitt compat cdc_acm btusb btintel brcmutil bnep
bluetooth spi_bcm2835aux spi_bcm2835 tcp_bbr sch_teql em_nbyte sch_codel
sch_prio sch_pie act_ipt em_meta sch_gred sch_dsmark cls_basic
[=C2=A0 259.394694]=C2=A0 em_cmp em_text sch_sfq act_police sch_fq sch_mu=
ltiq
sch_red act_skbedit act_mirred em_u32 cls_u32 cls_tcindex cls_flow
cls_route cls_fw sch_tbf sch_htb sch_hfsc sch_ingress snd_bcm2835 hid
evdev i2c_bcm2835 i2c_bcm2708 dht11 kfifo_buf industrialio i2c_dev
xt_set ip_set_list_set ip_set_hash_netiface ip_set_hash_netport
ip_set_hash_netnet ip_set_hash_net ip_set_hash_netportnet
ip_set_hash_mac ip_set_hash_ipportnet ip_set_hash_ipportip
ip_set_hash_ipport ip_set_hash_ipmark ip_set_hash_ip ip_set_bitmap_port
ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set nfnetlink ip6t_REJECT
nf_reject_ipv6 nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter
ip6_tables x_tables ip6_vti ip_vti ip6_udp_tunnel udp_tunnel ipcomp6
xfrm6_tunnel xfrm6_mode_tunnel xfrm6_mode_transport xfrm6_mode_beet esp6
ah6 ipcomp xfrm4_tunnel xfrm4_mode_tunnel xfrm4_mode_transport
xfrm4_mode_beet esp4 ah4 ip6_tunnel tunnel6 tunnel4 ip_tunnel
snd_compress snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_rawmidi
snd_seq_device snd_hwdep snd soundcore af_key xfrm_user xfrm_ipcomp
xfrm_algo cifs nls_utf8 regmap_spi regmap_i2c ecdh_generic
sha256_generic sha1_generic drbg md5 md4 kpp hmac echainiv ecb
des_generic deflate zlib_inflate zlib_deflate cmac cbc authenc drm
i2c_core dma_shared_buffer vfat fat nls_iso8859_1 nls_cp437 aead
cryptomgr crypto_null [last unloaded: brcmfmac]
[=C2=A0 259.637110] CPU: 0 PID: 50 Comm: kworker/0:2 Tainted: G=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.9.135 #0
[=C2=A0 259.662647] Hardware name: BCM2835
[=C2=A0 259.683981] Workqueue: events request_firmware_work_func
[=C2=A0 259.707357] [<c0016938>] (unwind_backtrace) from [<c0013474>]
(show_stack+0x10/0x14)
[=C2=A0 259.733223] [<c0013474>] (show_stack) from [<c001e810>]
(__warn+0xd0/0xfc)
[=C2=A0 259.758312] [<c001e810>] (__warn) from [<c001e934>]
(warn_slowpath_null+0x20/0x28)
[=C2=A0 259.784151] [<c001e934>] (warn_slowpath_null) from [<bf754ca0>]
(wiphy_register+0x280/0xa58 [cfg80211])
[=C2=A0 259.812011] [<bf754ca0>] (wiphy_register [cfg80211]) from
[<bf8b0bc8>] (brcmf_cfg80211_attach+0x8e8/0xf80 [brcmfmac])
[=C2=A0 259.841249] [<bf8b0bc8>] (brcmf_cfg80211_attach [brcmfmac]) from
[<bf8ba1b8>] (brcmf_attach+0x1c0/0x49c [brcmfmac])
[=C2=A0 259.870194] [<bf8ba1b8>] (brcmf_attach [brcmfmac]) from [<bf8c391=
c>]
(brcmf_sdio_firmware_callback+0x4fc/0xab0 [brcmfmac])
[=C2=A0 259.899691] [<bf8c391c>] (brcmf_sdio_firmware_callback [brcmfmac]=
)
from [<bf8bb028>] (brcmf_fw_request_done+0x23c/0x2dc [brcmfmac])
[=C2=A0 259.929894] [<bf8bb028>] (brcmf_fw_request_done [brcmfmac]) from
[<c0272e60>] (request_firmware_work_func+0x48/0x88)
[=C2=A0 259.958526] [<c0272e60>] (request_firmware_work_func) from
[<c0032ad0>] (process_one_work+0x204/0x398)
[=C2=A0 259.985650] [<c0032ad0>] (process_one_work) from [<c0032f38>]
(worker_thread+0x2d4/0x508)
[=C2=A0 260.011322] [<c0032f38>] (worker_thread) from [<c0037ccc>]
(kthread+0xe0/0xf8)
[=C2=A0 260.035705] [<c0037ccc>] (kthread) from [<c000f8f0>]
(ret_from_fork+0x14/0x24)
[=C2=A0 260.059731] ---[ end trace 35f416b283ba7dba ]---
[=C2=A0 260.080748] brcmfmac: brcmf_cfg80211_attach: Could not register w=
iphy
device (-22)
[=C2=A0 260.104550] brcmfmac: brcmf_bus_started: failed: -12
[=C2=A0 260.125334] brcmfmac: brcmf_attach: dongle is not responding: err=
=3D-12
[=C2=A0 260.151068] brcmfmac: brcmf_sdio_firmware_callback: brcmf_attach =
failed
[=C2=A0 263.922867] usbcore: registered new interface driver brcmfmac

Stijn

