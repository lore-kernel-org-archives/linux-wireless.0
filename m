Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59ECC04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 15:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A70E3208E4
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 15:50:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A70E3208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbeJPXlC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:41:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbeJPXlC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 19:41:02 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5A55285B1;
        Tue, 16 Oct 2018 15:49:59 +0000 (UTC)
Received: from localhost (ovpn-204-101.brq.redhat.com [10.40.204.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19A195DA62;
        Tue, 16 Oct 2018 15:49:58 +0000 (UTC)
Date:   Tue, 16 Oct 2018 17:49:58 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
Message-ID: <20181016154957.GA8730@redhat.com>
References: <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com>
 <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com>
 <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com>
 <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
 <20181016080922.GB4158@redhat.com>
 <CAKR_QVJ9T3EOhMoWPUv3x7-+NS54Y7cCRafM34pqve_4eV-zJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVJ9T3EOhMoWPUv3x7-+NS54Y7cCRafM34pqve_4eV-zJQ@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 16 Oct 2018 15:50:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello

On Tue, Oct 16, 2018 at 01:32:18PM +0200, Tom Psyborg wrote:
> I am sending you two builds privately so please check if there are any
> differences between the two builds and report back. Thanks.

I extracted rt2800lib.ko module from provided images, did disassembly via:

./staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/mipsel-openwrt-linux-objdump \
 -d -r --prefix-addresses ~/rt2800lib-BUILDn.ko  > ~/BUILDn.dump.txt

command and compered disassembled code. Here is difference:

$ diff -up  BUILD1.dump.txt BUILD2.dump.txt 
--- BUILD1.dump.txt	2018-10-16 16:40:34.834220838 +0200
+++ BUILD2.dump.txt	2018-10-16 16:40:40.187219211 +0200
@@ -1,5 +1,5 @@
 
-/home/stasiu/rt2800lib-BUILD1.ko:     file format elf32-tradlittlemips
+/home/stasiu/rt2800lib-BUILD2.ko:     file format elf32-tradlittlemips
 
 
 Disassembly of section .text:
@@ -9374,7 +9374,7 @@ Disassembly of section .text:
 00007f80 <rt2800_clear_beacon+0x224> jalr	v0
 00007f84 <rt2800_clear_beacon+0x228> move	a0,s0
 00007f88 <rt2800_clear_beacon+0x22c> lhu	v1,732(s0)
-00007f8c <rt2800_clear_beacon+0x230> li	v0,21392
+00007f8c <rt2800_clear_beacon+0x230> li	v0,25426
 00007f90 <rt2800_clear_beacon+0x234> bne	v1,v0,0000810c <rt2800_clear_beacon+0x3b0>
 00007f94 <rt2800_clear_beacon+0x238> li	a2,1025
 00007f98 <rt2800_clear_beacon+0x23c> lw	v0,4(s0)

There is no difference in init_registers (which is inlined in
rt2800_enable_radio). The only difference is in some number
rt2800_clear_beacon() function.

Regards
Stanislaw
