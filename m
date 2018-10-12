Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2FCC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D1B220868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D1B220868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbeJLQWS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbeJLQWS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:22:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 025D080F93;
        Fri, 12 Oct 2018 08:50:55 +0000 (UTC)
Received: from localhost (unknown [10.40.205.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E85860BE8;
        Fri, 12 Oct 2018 08:50:54 +0000 (UTC)
Date:   Fri, 12 Oct 2018 10:50:53 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3 4/4] rt2800: fix registers init for MT7620
Message-ID: <20181012085051.GA9768@redhat.com>
References: <1539086170-32528-4-git-send-email-sgruszka@redhat.com>
 <CAKR_QV+0z-5ee=sbEawFSnEF2ngvJSUPpNUoY_oPK1Cfk9P0iA@mail.gmail.com>
 <20181010071451.GA9140@redhat.com>
 <20181010120657.GA1185@makrotopia.org>
 <20181010124508.GA22330@redhat.com>
 <CAKR_QVJbtzpu6v4bZEz2UegWiAy1Ohooy-TciZcOeR_p+Z+yYg@mail.gmail.com>
 <20181010154054.GA27779@redhat.com>
 <CAKR_QVLjFyGtzikLTiQKhrVBSyUoPmDn2tMJqto8dyBDjoFJOQ@mail.gmail.com>
 <20181011100524.GA20794@redhat.com>
 <CAKR_QVJJJKgtip3386yM1EW+3UV8e=DvFf-qtmw7vRFggS1FHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVJJJKgtip3386yM1EW+3UV8e=DvFf-qtmw7vRFggS1FHg@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 12 Oct 2018 08:50:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 11, 2018 at 02:39:25PM +0200, Tom Psyborg wrote:
> so this is RX test where I assume your 7265 card is sending data. is
> that HT20 or HT40 mode and do you get regression on TX too?
> 
> can you try same case 2 test but with registers set to:
> 
> TX_SW_CFG0, 0x00000401
> TX_SW_CFG1, 0x000C0000
> TX_SW_CFG2, 0x00000000 (or 0x000C0408)
> 
> did you ever notice any tx power difference between nexx fw and openwrt fw?

Changing only TX_SW_CFG* does not make any diffrence on my router,
but this patch also start to configure other registers i.e.
MIMO_PS_CFG and that coused performance regression. I'll repost
without additional register programming.

Thanks
Stanislaw
