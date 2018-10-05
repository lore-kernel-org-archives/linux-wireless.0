Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048E2C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 07:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2D5820645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 07:44:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2D5820645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbeJEOl4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 10:41:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbeJEOl4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 10:41:56 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FC5885362;
        Fri,  5 Oct 2018 07:44:26 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71FDD308BDA1;
        Fri,  5 Oct 2018 07:44:25 +0000 (UTC)
Date:   Fri, 5 Oct 2018 09:44:23 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 0/5] rt2800mmio txdone/interrupts/flush rework
Message-ID: <20181005074422.GA1931@redhat.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
 <1538697102-3764-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1538697102-3764-1-git-send-email-pozega.tomislav@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.24
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 05 Oct 2018 07:44:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(adding back removed CCs)

On Fri, Oct 05, 2018 at 01:51:42AM +0200, Tomislav Požega wrote:
> Hi

Hi.

> As suspected this changeset causes throughput regression.

You seems to have prejudice against my work :-)

> Below screenshots show iperf test from MS150N (RF5370) device connected to RT3070 adapter running AP mode:
> 
> This is with standard openwrt build without any rt2x00 changes:
> 
> [url=https://postimg.cc/BtYQLf6r][img]https://i.postimg.cc/BtYQLf6r/shot-2018-10-04_17-23-56.jpg[/img][/url]
> 
> And this printscreen show iperf test with your changes:
> 
> [url=https://postimg.cc/D8Sf1p48][img]https://i.postimg.cc/D8Sf1p48/shot-2018-10-04_17-42-09.jpg[/img][/url]

My experience is that performance between two rt2800 devices vary with
no apparent reason. There are two problems I know that maigh affect
performance at random (and I think there are also some other low level
problems that I'm not aware of that cause performance fluctuations).

First problem is that HW aggregate RATE_PROBE frames with other frames
at different rate, so we can not do rate probing properly for rate
control algorithm.

Second problem: we send BAR when we fail to send a frame and this might
have positive and negative effect, depend what remote hardware do when it
gets BAR. This seems to be problem when two rt2800 devices are connected
and not a problem if rt2800 is connected with ath or iwl devices.

> Atheros card connected to RT3070 iperf test difference was negligible (1Mbps or less) on bodhi system, but
> it started to throw out reorder messages on my standard ubuntu after your changes:
> 
> [url=https://postimg.cc/SjJbP2SP][img]https://i.postimg.cc/SjJbP2SP/Screenshot.png[/img][/url]

Ok, thats seems not right, I will try to reproduce this.

> My advice: stop sending low-quality patches and do some testing before submission.

My advice: stop being arrogant if you want to work with others.

Patches were tested on USB devices. At first I thought they broke
rt2800usb support:
https://bugzilla.kernel.org/show_bug.cgi?id=82751#c17
but then when I wanted to debug that, they start to work;
https://bugzilla.kernel.org/show_bug.cgi?id=82751#c33
I assumed that previous breakage was caused by some different
change not related with those patches. 

Anyway I would appreciate any additional testing of my rt2x00 patches
as well as code review, if anyone would like to do this.

Thanks
Stanislaw
