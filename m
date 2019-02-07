Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BA0C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 15:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79C0521904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 15:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=agilox-net.20150623.gappssmtp.com header.i=@agilox-net.20150623.gappssmtp.com header.b="a9IIjTSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfBGPE6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:04:58 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:54380 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGPE6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 10:04:58 -0500
Received: by mail-wm1-f46.google.com with SMTP id a62so177324wmh.4
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 07:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=agilox-net.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=JBtsELaGOq2PtBtFHCkmQLRQih6Y//EpJoS2VCQXN9g=;
        b=a9IIjTSoNn8naC1ImKiQD7QhDFVptSsclvf9Kmr2qlFzJR4XaHFRDs3TYHNlya3sIb
         2pp9SdgWpIRX9ojUhOzOr4gXDb0hvZHPLCzVPSw6yWZbvcLkTe08UFgIX+Agr4+uT6TE
         iB7QdvhHKPE2qfea3faD+UaY+RzHfWUWWSqOWHDs86KC1fSKF0JtHuhCMUJj/eSbh3uz
         VPs5SYreqqRhsDpgLuiw4cT1/a8niPaOdy2NrpFIbzVxRtyzCelscs/bCZJ4/a5ikEA0
         +xpHyDWPsj9nhUN04JikHtTe89lY4F441NWuQEvGFgn5Ss68f8I3bK0ETdGfc8Sb8h87
         oLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=JBtsELaGOq2PtBtFHCkmQLRQih6Y//EpJoS2VCQXN9g=;
        b=I97qwZ1NyHMoHmUJ3AwQ7Y3EqgJpSeGVKtxqgwlmvQL8bwk34ZkUQmdKwnoGaK8gbG
         jUByVoTmHxNFUh1Mj8lSLpBx5B4G1nBgA2fYv7lnZWsDQpX301SpatdzX4QdbP2KHK/p
         qtioMt2lFTOk4z+YxdqErLa/nhPed5lKOK/kKqiRZ+/gnDoPxBzs/nBR7Cop8ccA+/tv
         +ONb3+b0EW1ODgmFAoVeFqENAeqfGGkcreT8BfJ07YlCYMC6j1iwhe6ulz0rg0jGPJw8
         hDF+nKH6RgeY9oMYhdA1Fde/Yz7OohOJVgeRMYXFirKNp3w/Td+SdMvIrR/z3xTdjATE
         C8pA==
X-Gm-Message-State: AHQUAuaz4nLax2BM5kc75fIfxiIHLtzdERrZtmJbNPEeNS9NGurYlmLb
        5e+DHu4AWyVhjbc+4ZdmeCJTYQ4DR5E=
X-Google-Smtp-Source: AHgI3IZh9GArvRh9c+3ZfAlOBtDp61A7jN59/9ocWsn+p4myhVunpcIXbTLbIa6+qB/pgA4Q8qgMOA==
X-Received: by 2002:a7b:cb18:: with SMTP id u24mr7462624wmj.138.1549551894755;
        Thu, 07 Feb 2019 07:04:54 -0800 (PST)
Received: from [10.10.55.77] ([31.193.161.162])
        by smtp.gmail.com with ESMTPSA id z26sm1908429wml.44.2019.02.07.07.04.53
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 07:04:53 -0800 (PST)
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Lukas Redlinger <lukas.redlinger@agilox.net>
Subject: [BUG] regular scan timed out
Message-ID: <588b2e78-a2f1-49f7-4a15-baa4f8658cc1@agilox.net>
Date:   Thu, 7 Feb 2019 16:04:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-AT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi there,

Debian 10 testing, Intel 8265, firmware 36.9f0a2d68.0

2 interfaces on 1 phy: 1 managed, 1 AP

background scan configured: bgscan="simple:1:-70:900"

------------

phy#0
     Interface hotspot
         ifindex 11
         wdev 0x4
         addr a0:a4:c5:96:b5:ec
         ssid yyyyyy
         type AP
         channel 1 (2412 MHz), width: 20 MHz (no HT), center1: 2412 MHz
         txpower 22.00 dBm

     Unnamed/non-netdev interface
         wdev 0x2
         addr a0:a4:c5:96:b5:eb
         type P2P-device
         txpower 0.00 dBm

     Interface wlp1s0
         ifindex 7
         wdev 0x1
         addr a0:a4:c5:96:b5:ea
         ssid xxxxxx
         type managed
         channel 36 (5180 MHz), width: 80 MHz, center1: 5210 MHz

----------

[  715.890990] iwlwifi 0000:01:00.0: regular scan timed out
[  715.891047] iwlwifi 0000:01:00.0: Microcode SW error detected. 
Restarting 0x2000000.
[  715.891172] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:

[  715.891175] iwlwifi 0000:01:00.0: Status: 0x00000100, count: 6
[  715.891177] iwlwifi 0000:01:00.0: Loaded firmware version: 36.9f0a2d68.0
[  715.891180] iwlwifi 0000:01:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
[  715.891182] iwlwifi 0000:01:00.0: 0x000002A0 | trm_hw_status0
[  715.891184] iwlwifi 0000:01:00.0: 0x00000000 | trm_hw_status1
[  715.891186] iwlwifi 0000:01:00.0: 0x0002485C | branchlink2
[  715.891188] iwlwifi 0000:01:00.0: 0x0003A7CA | interruptlink1
[  715.891190] iwlwifi 0000:01:00.0: 0x00000868 | interruptlink2
[  715.891192] iwlwifi 0000:01:00.0: 0x00000000 | data1
[  715.891195] iwlwifi 0000:01:00.0: 0x00000080 | data2
[  715.891197] iwlwifi 0000:01:00.0: 0x07830000 | data3
[  715.891199] iwlwifi 0000:01:00.0: 0x34C0F92B | beacon time
[  715.891201] iwlwifi 0000:01:00.0: 0xB72786AB | tsf low
[  715.891203] iwlwifi 0000:01:00.0: 0x000002C5 | tsf hi
[  715.891205] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[  715.891207] iwlwifi 0000:01:00.0: 0x01E94EF8 | time gp2
[  715.891209] iwlwifi 0000:01:00.0: 0x00000001 | uCode revision type
[  715.891211] iwlwifi 0000:01:00.0: 0x00000024 | uCode version major
[  715.891213] iwlwifi 0000:01:00.0: 0x9F0A2D68 | uCode version minor
[  715.891215] iwlwifi 0000:01:00.0: 0x00000230 | hw version
[  715.891217] iwlwifi 0000:01:00.0: 0x00489000 | board version
[  715.891219] iwlwifi 0000:01:00.0: 0x0AA1001C | hcmd
[  715.891221] iwlwifi 0000:01:00.0: 0x00022000 | isr0
[  715.891223] iwlwifi 0000:01:00.0: 0x00800000 | isr1
[  715.891225] iwlwifi 0000:01:00.0: 0x08001802 | isr2
[  715.891227] iwlwifi 0000:01:00.0: 0x00417CC0 | isr3
[  715.891229] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[  715.891231] iwlwifi 0000:01:00.0: 0x0AA1001C | last cmd Id
[  715.891233] iwlwifi 0000:01:00.0: 0x00000000 | wait_event
[  715.891235] iwlwifi 0000:01:00.0: 0x00000080 | l2p_control
[  715.891237] iwlwifi 0000:01:00.0: 0x00018020 | l2p_duration
[  715.891239] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
[  715.891241] iwlwifi 0000:01:00.0: 0x00000080 | l2p_addr_match
[  715.891243] iwlwifi 0000:01:00.0: 0x0000000D | lmpm_pmg_sel
[  715.891245] iwlwifi 0000:01:00.0: 0x04120134 | timestamp
[  715.891247] iwlwifi 0000:01:00.0: 0x003490A0 | flow_handler
[  715.891298] iwlwifi 0000:01:00.0: 0x00000000 | ADVANCED_SYSASSERT
[  715.891300] iwlwifi 0000:01:00.0: 0x00000000 | umac branchlink1
[  715.891302] iwlwifi 0000:01:00.0: 0x00000000 | umac branchlink2
[  715.891304] iwlwifi 0000:01:00.0: 0x00000000 | umac interruptlink1
[  715.891306] iwlwifi 0000:01:00.0: 0x00000000 | umac interruptlink2
[  715.891308] iwlwifi 0000:01:00.0: 0x00000000 | umac data1
[  715.891310] iwlwifi 0000:01:00.0: 0x00000000 | umac data2
[  715.891312] iwlwifi 0000:01:00.0: 0x00000000 | umac data3
[  715.891314] iwlwifi 0000:01:00.0: 0x00000000 | umac major
[  715.891316] iwlwifi 0000:01:00.0: 0x00000000 | umac minor
[  715.891318] iwlwifi 0000:01:00.0: 0x00000000 | frame pointer
[  715.891320] iwlwifi 0000:01:00.0: 0x00000000 | stack pointer
[  715.891322] iwlwifi 0000:01:00.0: 0x00000000 | last host cmd
[  715.891324] iwlwifi 0000:01:00.0: 0x00000000 | isr status reg
[  715.891330] ieee80211 phy1: Hardware restart was requested


Let me know if I should provide any further information.

Thanks,
Lukas

