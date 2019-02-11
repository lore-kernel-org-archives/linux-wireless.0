Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599D3C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 20:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CD3F218D8
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 20:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KSc972Av"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfBKUdY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 15:33:24 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43450 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfBKUdX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 15:33:23 -0500
Received: by mail-lj1-f195.google.com with SMTP id o1-v6so189402ljc.10
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 12:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=SOrbuoPKNqQi8Snk6welDUs8oahR5rFfPml7WhSpVz4=;
        b=KSc972AvwFvs2WuqcAL31JbDL9Youc+AjcsXLy2Xa3AvgsL76XBKU6WQ2yrvYBH5Vo
         5lvTRKMwyXmO3BJYlnJXgdJAEHnqRKsZM+Wb1qLkL16GWb/vcc5cjaQP0jVwr8k2qRAu
         c/cnhDB5oaD6iEd2tOafZhVBGh5JI+xSVegqqreETIF/Si2oE20m4kX3VVIvy9F+KKUx
         Bhj931ncqJPO9f62XKoGGX92MDrvMgVlF+H4bvwxk4+of4KdEGsGPpmdkAMzbK6HIj2p
         ZMcoO2xAvohH+LFjdu0B29M0ZazwaKPtbDHKjIK2Oi/VAxme9y36c2gWOxoh4dKYr5Qj
         DSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=SOrbuoPKNqQi8Snk6welDUs8oahR5rFfPml7WhSpVz4=;
        b=hkNyKSTzws85vWi0NHXxsfLQtxg5Gkqrfsw+4R1/ZhGKw1HB/pMAD620VXvRil6FSO
         zyYO4uQDZvyYYJweAcjKu67OBKmvWwv5vvumBK0efQkR5l+eo9g5jo2wcn1NQ8O0Wo1/
         EB52qXMKTeDeNpaqZbs7Ed1bAMzcQS2X08GibZepayRgOv4jDFSrxB/SecpOz57NAmsY
         MFCcVC6PlczpVvTzAnGRLzwoHZZH8gqXUJTBEqNQfeiYC0mcrKlbnH/AYNWlm1u8q38a
         6zFfyInabek9wVv0MIShK28TFDLIFslMHS8uT4ipFFxBKlZZzBN8j9irLB9rbnuv/JcI
         PWWw==
X-Gm-Message-State: AHQUAuY6GuhBqh1z8YO5/29Ys/s0H2rPfwGJjgvmwZvCfPDeLmxXFwds
        RqQnLSRwse1O7xyiRHB9wQg=
X-Google-Smtp-Source: AHgI3Ib3q009f+x/Qnb7m9wZ5is8VfVQnb22vcPec47Fm7XJIpzxGBUy9k++uVO44J4fQBjlnp1xDg==
X-Received: by 2002:a2e:9b95:: with SMTP id z21-v6mr19001lji.167.1549917200449;
        Mon, 11 Feb 2019 12:33:20 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id v11sm2526186lfb.46.2019.02.11.12.33.19
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 12:33:19 -0800 (PST)
To:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: brcmfmac: race in init path related to the wiphy_register() call
Message-ID: <3a6c98d3-1c4f-a4c9-a054-2fa26fc110f8@gmail.com>
Date:   Mon, 11 Feb 2019 21:33:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

During debugging some potential problems I hit a race bug in the
brcmfmac. It calls wiphy_register() before it's ready to handle all the
cfg80211 callbacks correctly.

In brcmf_cfg80211_attach() there is a wiphy_register() call performed
before setting "config" in the struct brcmf_pub. So if:
1) User tries to create interface *right* after wiphy appears
2) brcmf_cfg80211_add_iface() gets executed quickly enough
3) Firmware sends BRCMF_E_IF event

Then brcmf_notify_vif_event() will crash the kernel:
[   32.071904] [00000300] *pgd=00000000
[   32.075562] Internal error: Oops: 17 [#1] SMP ARM
[   32.080277] Modules linked in: pppoe ppp_async l2tp_ppp iptable_nat brcmfmac pptp pppox ppp_mppe ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_tcpmss xt_statistic xt_state xt_recent xt_policy xt_na0
[   32.178487]  ip_set_hash_ipportip ip_set_hash_ipport ip_set_hash_ipmark ip_set_hash_ip ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set nfnetlink ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter ip6_tables x_tables msc
[   32.274776] CPU: 1 PID: 12 Comm: kworker/1:0 Not tainted 4.4.167 #0
[   32.281054] Hardware name: BCM5301X
[   32.284580] Workqueue: events brcmf_fweh_event_worker [brcmfmac]
[   32.290604] task: c7845980 ti: c7872000 task.ti: c7872000
[   32.296017] PC is at _raw_spin_lock+0x10/0x4c
[   32.300388] LR is at brcmf_notify_vif_event+0x6c/0x1a4 [brcmfmac]
[   32.306489] pc : [<c0012098>]    lr : [<bf5387dc>]    psr: 60000013
[   32.306489] sp : c7873e18  ip : c7873e28  fp : c7873e24
[   32.317995] r10: c7873eaa  r9 : c7873ea4  r8 : c59c8000
[   32.323227] r7 : c535e948  r6 : c4d50480  r5 : 00000000  r4 : 00000300
[   32.329763] r3 : 00000000  r2 : c7873e24  r1 : bf54f7b3  r0 : 00000300
[   32.336301] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   32.343445] Control: 10c5387d  Table: 04cf004a  DAC: 00000051
[   32.349199] Process kworker/1:0 (pid: 12, stack limit = 0xc7872190)
[   32.355474] Stack: (0xc7873e18 to 0xc7874000)
[   32.359836] 3e00:                                                       c7873e54 c7873e28
[   32.368029] 3e20: bf5387dc c0012094 00000000 00000001 00000002 c7873e2c bf538770 c59ca138
[   32.376228] 3e40: c4d50480 00000000 c7873e6c c7873e58 bf53c1e8 bf53877c c535e900 c59ca138
[   32.384426] 3e60: c7873eec c7873e70 bf53c578 bf53c1b8 c7873eaa c7873ea4 00000000 00000001
[   32.392617] 3e80: 72ed795e c04e03c8 00000089 00000002 00000036 00000000 00000000 00000000
[   32.400816] 3ea0: 00000005 6a4e13a4 6c77b80b 00322e30 00000000 00000000 02010000 dc8ba6a7
[   32.409007] 3ec0: c7a2eec0 c78333c0 c6bda300 c59ca138 c78333d8 00000000 c6bdd700 00000008
[   32.417206] 3ee0: c7873f2c c7873ef0 c0034458 bf53c27c c6bda300 c6bda300 c78333d8 00000000
[   32.425405] 3f00: 00000000 c78333c0 c6bda300 c6bda300 c78333d8 c6bda314 00000000 00000008
[   32.433604] 3f20: c7873f5c c7873f30 c0035234 c0034284 c7845980 c7832700 00000000 c78333c0
[   32.441803] 3f40: c0034f40 00000000 00000000 00000000 c7873fac c7873f60 c003984c c0034f4c
[   32.449994] 3f60: 00000000 00000000 00000000 c78333c0 00000000 00000000 c7873f78 c7873f78
[   32.458184] 3f80: 00000000 00000000 c7873f88 c7873f88 c7832700 c003974c 00000000 00000000
[   32.466383] 3fa0: 00000000 c7873fb0 c00097d0 c0039758 00000000 00000000 00000000 00000000
[   32.474573] 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   32.482764] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[   32.490950] Backtrace:
[   32.493420] [<c0012088>] (_raw_spin_lock) from [<bf5387dc>] (brcmf_notify_vif_event+0x6c/0x1a4 [brcmfmac])
[   32.503112] [<bf538770>] (brcmf_notify_vif_event [brcmfmac]) from [<bf53c1e8>] (brcmf_fil_bsscfg_int_get+0x78/0xb0 [brcmfmac])
[   32.514521]  r7:00000000 r6:c4d50480 r5:c59ca138 r4:bf538770
[   32.520240] [<bf53c1ac>] (brcmf_fil_bsscfg_int_get [brcmfmac]) from [<bf53c578>] (brcmf_fweh_event_worker+0x308/0x3d4 [brcmfmac])
[   32.531912]  r5:c59ca138 r4:c535e900
[   32.535524] [<bf53c270>] (brcmf_fweh_event_worker [brcmfmac]) from [<c0034458>] (process_one_work+0x1e0/0x318)
[   32.545543]  r10:00000008 r9:c6bdd700 r8:00000000 r7:c78333d8 r6:c59ca138 r5:c6bda300
[   32.553428]  r4:c78333c0
[   32.555975] [<c0034278>] (process_one_work) from [<c0035234>] (worker_thread+0x2f4/0x448)
[   32.564169]  r10:00000008 r9:00000000 r8:c6bda314 r7:c78333d8 r6:c6bda300 r5:c6bda300
[   32.572055]  r4:c78333c0
[   32.574607] [<c0034f40>] (worker_thread) from [<c003984c>] (kthread+0x100/0x114)
[   32.582012]  r10:00000000 r9:00000000 r8:00000000 r7:c0034f40 r6:c78333c0 r5:00000000
[   32.589898]  r4:c7832700 r3:c7845980
[   32.593499] [<c003974c>] (kthread) from [<c00097d0>] (ret_from_fork+0x14/0x24)
[   32.600735]  r7:00000000 r6:00000000 r5:c003974c r4:c7832700
[   32.606440] Code: e1a0c00d e92dd800 e24cb004 f590f000 (e1902f9f)
[   32.612609] ---[ end trace 68af7a0bd4231f2f ]---

I think it was meant to be avoided by call brcmf_fweh_activate_events()
being executed late enough but it doesn't seem to work. Firmware seems
to generate BRCMF_E_IF even before driver /allows/ it to do so.

I'm not very similiar with all the init path so could someone take a
look at this, please?

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -738,6 +738,7 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
  	struct wireless_dev *wdev;
  	int err;

+	wiphy_info(wiphy, "%s: name:%s\n", __func__, name);
  	/*
  	 * There is a bug with in-firmware BSS management. When adding virtual
  	 * interface brcmfmac first tells firmware to create new BSS and then
@@ -5766,6 +5767,7 @@ static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
  				  const struct brcmf_event_msg *e, void *data)
  {
  	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	BUG_ON(!cfg);
  	struct brcmf_if_event *ifevent = (struct brcmf_if_event *)data;
  	struct brcmf_cfg80211_vif_event *event = &cfg->vif_event;
  	struct brcmf_cfg80211_vif *vif;
@@ -7110,6 +7115,8 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
  		brcmf_err("Could not register wiphy device (%d)\n", err);
  		goto priv_out;
  	}
+	wiphy_warn(wiphy, "wiphy registered - add interface NOW to crash the kernel\n");
+	msleep(30000);

  	err = brcmf_setup_wiphybands(wiphy);
  	if (err) {
