Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81027C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 05:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E18920652
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 05:11:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bCBHna6d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E18920652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbeJXNiI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 09:38:08 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43625 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbeJXNiI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 09:38:08 -0400
Received: by mail-qk1-f195.google.com with SMTP id m17-v6so2376639qkk.10
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2018 22:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=vvyqHrxNhpMFM3HJN+748SICU38JuNJgYbKyDsfYaik=;
        b=bCBHna6dxqWnjxpR+2p3+THq2LraOIN09n/EP4EgbbR/29mu5pIIFx8qSJQc/DDgJb
         eZ802k4+PcfnkQmMRwOXgklT5/c+nBMUDFlV5goIruCfmtWrhns9Bst/VqDkuAyi4Nxa
         W7HjZ8wKq5ZZDWT0IKSpwVH6SAdjsH/EIUBU6FD/NKpkG4zmxA/z5fHpG8nV2xhVtrT1
         m+RxdZL9VKxPET8NlFuaM+nxVhyse/SICK30dN48KMoLR5ItuK6uMXsE3cPcayKvw45W
         QYRkBCJjkJwGD9wqWdksBGg5nwCkuUmeGdhse9E6BNhRvAmQznur6k3oryJrfExIgY5Y
         jmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=vvyqHrxNhpMFM3HJN+748SICU38JuNJgYbKyDsfYaik=;
        b=kZhk9Bpr19uc81cy4xgA4meIAo9aQC9b1PSg5v+IXLQCdYPZJy83vwolk+fkdeqOcP
         aC11pEvuqClmDaGQugHt1axP8SFAjw5/RKexVkinj/JQjfSpx6Qnt/RxuWmuuFvrmmmq
         QHG6YENrpqyNF3eVSRIi4gdcpDTVwVi+QvglW6iDVpCQv6P3yW+YB4BcxLi5uO+hITuv
         3xDtpYXzrbaiRwJn8ZAOz0D+YFcF4pO4LS+pyiQS8dzZLM56AL/H/ssFI9qinVJSY2Kn
         i2WXVZGjHyzi1+SWIPHipUGMfcgsbiVy91IsNcRM5mggRLqZ2FVR25oAf9pZ06m/GQJ4
         Ux3A==
X-Gm-Message-State: AGRZ1gJBmr1H850p0Wg5HllYZ3bKummykKUOMb5XRoRtHHKZRLj8i4g9
        LDdvhHR79GInTGq4E2ak+uuX2rdo
X-Google-Smtp-Source: AJdET5fp/S85lUi5LdHqL6WAs53o2M5INMQgb8Pv1awbU05ySy30t/+b9Doz+lPzNrXL4TW0TNhK2Q==
X-Received: by 2002:a37:5906:: with SMTP id n6-v6mr973495qkb.73.1540357898469;
        Tue, 23 Oct 2018 22:11:38 -0700 (PDT)
Received: from ?IPv6:2001:470:1d:7b6::245? ([2001:470:1d:7b6::245])
        by smtp.googlemail.com with ESMTPSA id q51-v6sm5328850qtq.6.2018.10.23.22.11.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Oct 2018 22:11:37 -0700 (PDT)
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
From:   Ellie Revves <ellierevves@gmail.com>
Subject: ath9k driver may be broken on ARM64 ?
Message-ID: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
Date:   Wed, 24 Oct 2018 01:13:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
for the context part:

I've got a marvell espressobin board, to which I attached a mini-PCIE 
wireless card, atheros AR9565 aka. QCB335. I am using both archlinux-arm 
and a custom OS made with buildroot, and both have this problem.

Problem:

When the system boots up, the kernel recognizes the card, and then the 
ath9k driver gets loaded. From what someone on the irc channel of 
#linux-wireless determined, the driver ends up doing a sigbus while 
attempting to read from a specific address in memory, which of course 
makes it crash. We did check the page tables, and the memory seems to be 
mapped fine. So we're still clueless as to why it is not possible to 
read from that particular memory address, and why the driver would do 
so. Here I attach the kernel page tables, along with the dmesg output. 
The problematic line in the trace is x19.

I'd appreciate any help in fixing this issue which I think might be 
related to ARM64.

Note that I am no programmer, all the info I gathered so far were with 
someone else's help. But if you need some more debug output, files or 
anything else, just let me know. I can also apply patches to test 
things, or modify the code if I know exactly in what way, i.e: what to 
copy and past.

Dmesg:

http://ix.io/1pTK

kernel page tables -- from a later kernel build, but do notice that the 
memory is still mapped correctly even if the register changed:

http://ix.io/1pQh

Thanks a lot :)
