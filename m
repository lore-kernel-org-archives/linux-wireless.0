Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200DFECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2E8C2064A
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:00:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2E8C2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbeJSRFl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:05:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbeJSRFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 13:05:41 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4BE1C307D843;
        Fri, 19 Oct 2018 09:00:31 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDACF53E28;
        Fri, 19 Oct 2018 09:00:30 +0000 (UTC)
Date:   Fri, 19 Oct 2018 11:00:28 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
Message-ID: <20181019090028.GA7023@redhat.com>
References: <20181012113656.GB2118@redhat.com>
 <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com>
 <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com>
 <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
 <20181016080922.GB4158@redhat.com>
 <CAKR_QVJ9T3EOhMoWPUv3x7-+NS54Y7cCRafM34pqve_4eV-zJQ@mail.gmail.com>
 <20181016154957.GA8730@redhat.com>
 <CAKR_QV+p_BP+xvqc65gHjm8t6fRNwfTRwKixCn7DN9+LjG-n3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QV+p_BP+xvqc65gHjm8t6fRNwfTRwKixCn7DN9+LjG-n3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 19 Oct 2018 09:00:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 17, 2018 at 03:25:58PM +0200, Tom Psyborg wrote:
> On 16/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Tue, Oct 16, 2018 at 01:32:18PM +0200, Tom Psyborg wrote:
> >> I am sending you two builds privately so please check if there are any
> >> differences between the two builds and report back. Thanks.
> >
> > I extracted rt2800lib.ko module from provided images, did disassembly via:
> >
> > ./staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/mipsel-openwrt-linux-objdump
> > \
> >  -d -r --prefix-addresses ~/rt2800lib-BUILDn.ko  > ~/BUILDn.dump.txt
> >
> > command and compered disassembled code. Here is difference:
> >
> > $ diff -up  BUILD1.dump.txt BUILD2.dump.txt
> > --- BUILD1.dump.txt	2018-10-16 16:40:34.834220838 +0200
> > +++ BUILD2.dump.txt	2018-10-16 16:40:40.187219211 +0200
> > @@ -1,5 +1,5 @@
> >
> > -/home/stasiu/rt2800lib-BUILD1.ko:     file format elf32-tradlittlemips
> > +/home/stasiu/rt2800lib-BUILD2.ko:     file format elf32-tradlittlemips
> >
> >
> >  Disassembly of section .text:
> > @@ -9374,7 +9374,7 @@ Disassembly of section .text:
> >  00007f80 <rt2800_clear_beacon+0x224> jalr	v0
> >  00007f84 <rt2800_clear_beacon+0x228> move	a0,s0
> >  00007f88 <rt2800_clear_beacon+0x22c> lhu	v1,732(s0)
> > -00007f8c <rt2800_clear_beacon+0x230> li	v0,21392
> > +00007f8c <rt2800_clear_beacon+0x230> li	v0,25426
> >  00007f90 <rt2800_clear_beacon+0x234> bne	v1,v0,0000810c
> > <rt2800_clear_beacon+0x3b0>
> >  00007f94 <rt2800_clear_beacon+0x238> li	a2,1025
> >  00007f98 <rt2800_clear_beacon+0x23c> lw	v0,4(s0)
> >
> > There is no difference in init_registers (which is inlined in
> > rt2800_enable_radio). The only difference is in some number
> > rt2800_clear_beacon() function.
> >
> > Regards
> > Stanislaw
> >
> 
> i meant you try it on your nexx device. and post dmesg if you can boot them

I tried to do this, but somehow after update BUILD1 image into device
my configuration was wiped out :-( and I have to reconfigure the
device now. Anyway I'm going to test and provide dmesg , but this
will take some time.

Regards
Stanislaw
