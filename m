Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D16C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5885121B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gXAd8yfj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438401AbfBNWaR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:30:17 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37170 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393758AbfBNWaQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:30:16 -0500
Received: by mail-lj1-f194.google.com with SMTP id r10-v6so6688734ljj.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=JrpvhXLBXIYL6KNroGAkYKTuKo2eFShH15fQggeGYRs=;
        b=gXAd8yfjf6bal6TH8VqH/N0m6Ng71Ena/Em0O7tid6vpt/7qi2UV48CGqbwNjPXqw/
         NLcIpswYjUIBwykh2rb2DHYNQz8LMacwGtqaq8SKl7JkkcIHkUD4v+42hK0jIrAxvXJ+
         LXJvq1p5mpXJgShGYEN114ci4YWuJ3RuyK1uQVGm2jar2NXY15IHWIzkbYyykDf4k0Tb
         932MJsR6JW4vUwYjOANOZ3N5zJCC+nPdTnD3oG+l0lpz4fdhNL0co7LpTJ28b1nxTIf2
         1xjNQxiqPq+VMXUHwE6Rtf9pCdXzfeTNufQd4JWvjMDHs3jWEnrdRrf1ewM1ZMTFJfSV
         7JcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=JrpvhXLBXIYL6KNroGAkYKTuKo2eFShH15fQggeGYRs=;
        b=sJDnrKw9Pj52464e4+ckqgsVPgJKzr61eQ6YktA1nAAX630akNKzwKxxwkoN+QP39C
         nJHBYqLTNkGtMZIbeW8TPJR9QbO9J3A//8XTGsSQAsFuilqX2MmYZFU4DXMVod/bL12E
         Qx25hMTlU5/Z1yqw0vNhQwLYbdbKejRfhB32IN1/jVdgPoUIRLNX1x9aB3tOIpspw5fv
         0vCMebNCRekXSm2+vO6cDGDIcdcYyH0UPPnBCPXs1TIwP5jVx17TRU/EcKyEY9nfCHtv
         NBEDwl8C2554D/WMPgsvsHjQZpzUOFaAtXM8iTPy8reA4EgUO2zoWK7vA6MdhWZ/Un+i
         DgOw==
X-Gm-Message-State: AHQUAuY6ACXB7OsyC14KoxT+hM1ANMvDRwH+5a17QyMfIKU6UmF9fBqq
        hPZ4s2Dg6gHZLvnjIBCFeyK1PnRpDrQ=
X-Google-Smtp-Source: AHgI3IZvRV/PALqTKqdqo1Ac5IwkeJK2ObLIbBDJyEFpwKjMbM77Koh4YhiofiD6xCc2+R92H3geFw==
X-Received: by 2002:a2e:9983:: with SMTP id w3mr2604287lji.71.1550183414243;
        Thu, 14 Feb 2019 14:30:14 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id k2-v6sm675443lje.86.2019.02.14.14.30.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:30:13 -0800 (PST)
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: brcmfmac: NULL pointer dereference during brcmf_detach() after
 firmware crash
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Cc:     Aaron Blair <aaron@aaronpb.me>
Message-ID: <b519e746-ddfd-421f-d897-7620d229e4b2@gmail.com>
Date:   Thu, 14 Feb 2019 23:30:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I've just found a well reproducible brcmfmac crash (NULL pointer dereference).

Steps:
1. Wait for or trigger a FullMAC firmware crash
2. Wait for some skb to get queued on a flowring
3. Call rmmod brcmfmac

Problem:
There is a NULL pointer dereference in one of the brcmf_detach() calls.

Explanation:
brcmf_detach() first frees all "ifp"s and then deletes flowrings. If any
flowring has a skb it results in calling brcmf_txfinalize() which tries
to access "ifp" (struct brcmf_if) which is a NULL.

Pseudo-code forward-trace:
brcmf_detach
     foreach
         brcmf_remove_interface
             brcmf_del_if
                 brcmf_net_detach
                     unregister_netdev(ice)
     brcmf_proto_detach
         brcmf_proto_msgbuf_detach
             brcmf_flowring_detach
                 foreach
                     brcmf_msgbuf_delete_flowring
                         brcmf_msgbuf_remove_flowring
                             brcmf_flowring_delete
                                 brcmf_txfinalize

[ 2608.673022] brcmfmac: brcmf_msgbuf_delete_flowring: Failed to submit RING_DELETE, flowring will be removed
[ 2608.682938] Unable to handle kernel NULL pointer dereference at virtual address 00000020
[ 2608.691066] pgd = c4d2c000
[ 2608.693807] [00000020] *pgd=05337831, *pte=00000000, *ppte=00000000
[ 2608.700115] Internal error: Oops: 17 [#1] SMP ARM
[ 2608.704828] Modules linked in: pppoe ppp_async l2tp_ppp iptable_nat brcmfmac(-) pptp pppox ppp_mppe ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_tcpmss xt_statistic xt_state xt_recent xt_policy xtc
[ 2608.889523] CPU: 1 PID: 4798 Comm: rmmod Not tainted 4.4.167 #0
[ 2608.895453] Hardware name: BCM5301X
[ 2608.898946] task: c4d44000 ti: c4d06000 task.ti: c4d06000
[ 2608.904380] PC is at brcmf_txfinalize+0x7c/0x90 [brcmfmac]
[ 2608.909886] LR is at brcmf_flowring_delete+0xa4/0xb4 [brcmfmac]
[ 2608.915814] pc : [<bf54410c>]    lr : [<bf548600>]    psr: 60000013
[ 2608.915814] sp : c4d07d28  ip : c4d07d48  fp : c4d07d44
[ 2608.927319] r10: 00000000  r9 : c58ec080  r8 : 00000000
[ 2608.932551] r7 : c58ed080  r6 : 00000000  r5 : c5386b00  r4 : 00000000
[ 2608.939088] r3 : 00000806  r2 : 0000888e  r1 : c5386b00  r0 : c5386b00
[ 2608.945626] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[ 2608.952770] Control: 10c5387d  Table: 04d2c04a  DAC: 00000051
[ 2608.958523] Process rmmod (pid: 4798, stack limit = 0xc4d06190)
[ 2608.964451] Stack: (0xc4d07d28 to 0xc4d08000)
[ 2608.968814] 7d20:                   c4c91708 c4c91700 00000000 c58ed080 c4d07d6c c4d07d48
[ 2608.977014] 7d40: bf548600 bf54409c c66e4e00 00000000 c7af2ae8 c0019b8c cc486000 05348000
[ 2608.985213] 7d60: c4d07d9c c4d07d70 bf548dcc bf548568 00000000 c4d07d98 00000000 c6420000
[ 2608.993412] 7d80: fffffffb c66e4e00 c5954000 c4d06000 c4d07dc4 c4d07da0 bf54a48c bf548d14
[ 2609.001611] 7da0: 00000000 c0032794 c58ec080 c58ed080 c58ed4cc 00000000 c4d07dec c4d07dc8
[ 2609.009810] 7dc0: bf548718 bf54a3cc c66e4e00 c66e4ea4 c5954000 00000100 c00098c4 c4d06000
[ 2609.018010] 7de0: c4d07e1c c4d07df0 bf54a9d0 bf5486d0 c4d07e1c c51b0000 c5954000 c6708300
[ 2609.026209] 7e00: c5954098 c5954098 c00098c4 c4d06000 c4d07e34 c4d07e20 bf5425cc bf54a944
[ 2609.034409] 7e20: c5954000 c6708300 c4d07e54 c4d07e38 bf544fcc bf542580 c5917380 c6708300
[ 2609.042608] 7e40: c7af2a80 00000081 c4d07e74 c4d07e58 bf54d318 bf544f04 c7af2ae8 c7af2a80
[ 2609.050807] 7e60: c7af2b1c 00000081 c4d07e8c c4d07e78 c01d71cc bf54d2cc c7af2ae8 bf5599c8
[ 2609.059006] 7e80: c4d07ea4 c4d07e90 c01ff0b4 c01d71a4 c7af2ae8 bf5599c8 c4d07ec4 c4d07ea8
[ 2609.067205] 7ea0: c01ff20c c01ff03c bf5599c8 c04e03c8 b6f25c00 00000081 c4d07edc c4d07ec8
[ 2609.075404] 7ec0: c01fe694 c01ff16c bf5599c8 c04e03c8 c4d07ef4 c4d07ee0 c01ff65c c01fe634
[ 2609.083603] 7ee0: bf559994 c04e03c8 c4d07f14 c4d07ef8 c01d6b38 c01ff624 bf559c80 c04e03c8
[ 2609.091802] 7f00: b6f25c00 00000081 c4d07f24 c4d07f18 bf54ea34 c01d6b2c c4d07f34 c4d07f28
[ 2609.100001] 7f20: bf54edfc bf54ea1c c4d07f44 c4d07f38 bf54edb4 bf54edec c4d07fa4 c4d07f48
[ 2609.108200] 7f40: c0078234 bf54edb0 6d637262 63616d66 00000000 c4d07f60 c00c63cc c00c61c4
[ 2609.116400] 7f60: c4d07f8c c4d07f70 c003805c c000f0c8 c00098c4 c4d06010 c4d07fb0 c4d06000
[ 2609.124599] 7f80: 00d07fac dc8ba6a7 c0015ba0 00010034 1fbe3c7e 0002302c 00000000 c4d07fa8
[ 2609.132797] 7fa0: c0009700 c0078134 00010034 1fbe3c7e b6f25c00 00000000 00000000 00000000
[ 2609.140988] 7fc0: 00010034 1fbe3c7e 0002302c 00000081 bed23e74 00000000 00000001 00000000
[ 2609.149187] 7fe0: bed23d94 bed23d78 00010e98 b6f5e6e4 a0000010 b6f25c00 00000000 00000000
[ 2609.157374] Backtrace:
[ 2609.159854] [<bf544090>] (brcmf_txfinalize [brcmfmac]) from [<bf548600>] (brcmf_flowring_delete+0xa4/0xb4 [brcmfmac])
[ 2609.170482]  r7:c58ed080 r6:00000000 r5:c4c91700 r4:c4c91708
[ 2609.176202] [<bf54855c>] (brcmf_flowring_delete [brcmfmac]) from [<bf548dcc>] (brcmf_msgbuf_rxreorder+0x3d4/0x84c [brcmfmac])
[ 2609.187525]  r9:05348000 r8:cc486000 r7:c0019b8c r6:c7af2ae8 r5:00000000 r4:c66e4e00
[ 2609.195342] [<bf548d08>] (brcmf_msgbuf_rxreorder [brcmfmac]) from [<bf54a48c>] (brcmf_msgbuf_delete_flowring+0xcc/0xe4 [brcmfmac])
[ 2609.207100]  r9:c4d06000 r8:c5954000 r7:c66e4e00 r6:fffffffb r5:c6420000 r4:00000000
[ 2609.214917] [<bf54a3c0>] (brcmf_msgbuf_delete_flowring [brcmfmac]) from [<bf548718>] (brcmf_flowring_detach+0x54/0x8c [brcmfmac])
[ 2609.226589]  r7:00000000 r6:c58ed4cc r5:c58ed080 r4:c58ec080
[ 2609.232311] [<bf5486c4>] (brcmf_flowring_detach [brcmfmac]) from [<bf54a9d0>] (brcmf_proto_msgbuf_detach+0x98/0x25c [brcmfmac])
[ 2609.243813]  r9:c4d06000 r8:c00098c4 r7:00000100 r6:c5954000 r5:c66e4ea4 r4:c66e4e00
[ 2609.251631] [<bf54a938>] (brcmf_proto_msgbuf_detach [brcmfmac]) from [<bf5425cc>] (brcmf_proto_detach+0x58/0x74 [brcmfmac])
[ 2609.262780]  r9:c4d06000 r8:c00098c4 r7:c5954098 r6:c5954098 r5:c6708300 r4:c5954000
[ 2609.270597] [<bf542574>] (brcmf_proto_detach [brcmfmac]) from [<bf544fcc>] (brcmf_detach+0xd4/0xf8 [brcmfmac])
[ 2609.280614]  r5:c6708300 r4:c5954000
[ 2609.284227] [<bf544ef8>] (brcmf_detach [brcmfmac]) from [<bf54d318>] (brcmf_pcie_remove+0x58/0x15c [brcmfmac])
[ 2609.294245]  r7:00000081 r6:c7af2a80 r5:c6708300 r4:c5917380
[ 2609.299973] [<bf54d2c0>] (brcmf_pcie_remove [brcmfmac]) from [<c01d71cc>] (pci_device_remove+0x34/0x64)
[ 2609.309381]  r7:00000081 r6:c7af2b1c r5:c7af2a80 r4:c7af2ae8
[ 2609.315098] [<c01d7198>] (pci_device_remove) from [<c01ff0b4>] (__device_release_driver+0x84/0xe8)
[ 2609.324073]  r5:bf5599c8 r4:c7af2ae8
[ 2609.327673] [<c01ff030>] (__device_release_driver) from [<c01ff20c>] (driver_detach+0xac/0xd4)
[ 2609.336303]  r5:bf5599c8 r4:c7af2ae8
[ 2609.339902] [<c01ff160>] (driver_detach) from [<c01fe694>] (bus_remove_driver+0x6c/0x94)
[ 2609.348009]  r7:00000081 r6:b6f25c00 r5:c04e03c8 r4:bf5599c8
[ 2609.353716] [<c01fe628>] (bus_remove_driver) from [<c01ff65c>] (driver_unregister+0x44/0x50)
[ 2609.362170]  r5:c04e03c8 r4:bf5599c8
[ 2609.365771] [<c01ff618>] (driver_unregister) from [<c01d6b38>] (pci_unregister_driver+0x18/0x7c)
[ 2609.374574]  r5:c04e03c8 r4:bf559994
[ 2609.378191] [<c01d6b20>] (pci_unregister_driver) from [<bf54ea34>] (brcmf_pcie_exit+0x24/0x34 [brcmfmac])
[ 2609.387778]  r7:00000081 r6:b6f25c00 r5:c04e03c8 r4:bf559c80
[ 2609.393498] [<bf54ea10>] (brcmf_pcie_exit [brcmfmac]) from [<bf54edfc>] (brcmf_core_exit+0x1c/0x24 [brcmfmac])
[ 2609.403532] [<bf54ede0>] (brcmf_core_exit [brcmfmac]) from [<bf54edb4>] (cleanup_module+0x10/0x3c [brcmfmac])
[ 2609.413488] [<bf54eda4>] (cleanup_module [brcmfmac]) from [<c0078234>] (SyS_delete_module+0x10c/0x1e0)
[ 2609.422819] [<c0078128>] (SyS_delete_module) from [<c0009700>] (ret_fast_syscall+0x0/0x48)
[ 2609.431097]  r6:0002302c r5:1fbe3c7e r4:00010034
[ 2609.435751] Code: e3a01003 eb2c2eb0 e3560000 e1a00005 (05943020)
[ 2609.441910] ---[ end trace a3c7ce1328ed101a ]---
