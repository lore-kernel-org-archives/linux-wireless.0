Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB58C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F1521773
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfBILDD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 06:03:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfBILDD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 06:03:03 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E15051F56A;
        Sat,  9 Feb 2019 11:03:02 +0000 (UTC)
Received: from localhost (ovpn-204-22.brq.redhat.com [10.40.204.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8F84101962E;
        Sat,  9 Feb 2019 11:03:01 +0000 (UTC)
Date:   Sat, 9 Feb 2019 12:03:00 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
Message-ID: <20190209110259.GA14900@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com>
 <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <20181227102535.GA25885@redhat.com>
 <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
 <20190102081934.GA5300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190102081934.GA5300@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Sat, 09 Feb 2019 11:03:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 02, 2019 at 09:19:34AM +0100, Stanislaw Gruszka wrote:
> On Fri, Dec 28, 2018 at 01:45:27AM +0100, Tom Psyborg wrote:
> > >
> > > I move prints to debug level for for "arrived at non-free entry" from
> > > "Dropping frame due to full tx queue" . For some users those 5 patches
> > > improve things, they fix problem of router connection hung completely.
> > > Printk problem is connection stall due to CPU being busy, but
> > > is possible to reconnect to AP after that. It's different issue.
> > >
> > yes they fix hung. same hung that does this single patch fix by moving
> > to dbg so they're not printed at all. FYI "Dropping frame due to full
> > tx queue" causes "arrived at non-free entry" eventually that freezes
> > interface so only reboot helps, removing "Dropping frame due to full
> > tx queue" from printing to logs prevents this kind of hung and is
> > better solution than 5 patches.
> 
> I wonder why are you confident about this ? And also why 5 patches
> fixed the hung if there were still "Dropping frame ..." prints ?
> 
> Anyway I'll ask people on the bz for confirmation, if stop printing
> is sufficient to fix the wifi hung.
> 
> > oh and don't forget to add note that
> > rt2x00_err/rt2x00_dbg prints can cause serious bug so you don't
> > acidentally enable them again in a year or two!
> 
> I think I will remember that, for others git changelog should
> be sufficient.
>  
> > > Also 'result in lower throughput' is over-generalized statement. More
> > > precise would be 'it lower throughput on some test cases', but even
> > > in those specific cases, throughput vary randomly with and without
> > > patches.
> > >
> > 
> > 100Mbps TX 70Mbps RX without and 80Mbps TX 55 Mbps RX with 5
> > patches--> EA2750 HT40 CH2 4.14.82+4.19-rc5-1-1
> 
> Ok, this is different case that you presented before on USB devices.
> And I'm more concerned about it, because changes with MMIO ware
> much bigger (for USB only some code was moved and some flush
> changed were done). Please check attached patch, if it fixes
> throughput regression for you ?

So what is the point complaining that I do not provide patches for
testing and when I do, ignore that ?

Anyway I have now MT7620A device and was capable to reproduce the
performance regression. Will provide patches to fix it and still
prevent tx queues hungs.

Stanislaw
