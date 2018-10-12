Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9332C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6688F20868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:26:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6688F20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbeJLT6q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 15:58:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728213AbeJLT6p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 15:58:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BC4C86674;
        Fri, 12 Oct 2018 12:26:32 +0000 (UTC)
Received: from localhost (unknown [10.40.205.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E37C912A7;
        Fri, 12 Oct 2018 12:26:31 +0000 (UTC)
Date:   Fri, 12 Oct 2018 14:26:30 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
Message-ID: <20181012122630.GB2668@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
 <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com>
 <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com>
 <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 12 Oct 2018 12:26:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 12, 2018 at 02:20:07PM +0200, Tom Psyborg wrote:
> > On upstream tree where this patch is intended
> > additional registers where never programmed as proper branch
> > were never used, because of additional check in RT5390 branch.
> >
> 
> on my hardware additional registers were programmed in regardless of
> redundant check. that why i opened whole thread on forum since i
> couldn't understand how's that happening

I don't understand how that possible either.

> > Patch does only change TX_SW_CFG* regs values for RT6352.
> >
> 
> i'd still prefer that we include CONFIG_RT2800SOC, and if required
> move rest of the registers to that check, because at least on my
> hardware driver would still recognize chip as RT5390 despite the
> RT6352 defines

As I pointed before you should add additional printk's and provide
dmesg to make us see what is going on.

Thanks
Stanislaw
