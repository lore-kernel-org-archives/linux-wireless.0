Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E84C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 190F6218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfBIL4c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 06:56:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbfBIL4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 06:56:31 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C027583F3F;
        Sat,  9 Feb 2019 11:56:31 +0000 (UTC)
Received: from localhost (ovpn-204-22.brq.redhat.com [10.40.204.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FFAC61146;
        Sat,  9 Feb 2019 11:56:30 +0000 (UTC)
Date:   Sat, 9 Feb 2019 12:56:29 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
Message-ID: <20190209115628.GA16082@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com>
 <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <20181227102535.GA25885@redhat.com>
 <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
 <20190102081934.GA5300@redhat.com>
 <20190209110259.GA14900@redhat.com>
 <CAKR_QVK7N_NGFR+_2+6fP5iZ0j3dDbvdxJOQt3Yjwn7DMBUfYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVK7N_NGFR+_2+6fP5iZ0j3dDbvdxJOQt3Yjwn7DMBUfYA@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Sat, 09 Feb 2019 11:56:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Feb 09, 2019 at 12:11:03PM +0100, Tom Psyborg wrote:
> Can you reproduce interface freeze with this patch if you enable debug
> options to print all dbg messages?

Haven't tried that, but I expect enabling debug messages will
cause troubles at hardware where printk make CPU hog.

Stanislaw 
