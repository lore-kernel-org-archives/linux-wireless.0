Return-Path: <SRS0=l33s=O6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEB1C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 09:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BCFB21906
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 09:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbeLUJ7l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Dec 2018 04:59:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729268AbeLUJ7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Dec 2018 04:59:41 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 07EC87E449;
        Fri, 21 Dec 2018 09:59:41 +0000 (UTC)
Received: from localhost (ovpn-204-249.brq.redhat.com [10.40.204.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 527C4277AD;
        Fri, 21 Dec 2018 09:59:40 +0000 (UTC)
Date:   Fri, 21 Dec 2018 10:59:39 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
Message-ID: <20181221095938.GA29536@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 21 Dec 2018 09:59:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Dec 20, 2018 at 06:52:03PM +0100, Tom Psyborg wrote:
> Shouldn't you now also revert the commits from
> https://git.openwrt.org/?p=openwrt/staging/dangole.git;a=commitdiff;h=de1c58a64bd66319e770d2587da07d8c9c90174a
> since they caused throughput regression?

For the record: this is not about currently posted patch and you
reference this:
https://lore.kernel.org/linux-wireless/1538697102-3764-1-git-send-email-pozega.tomislav@gmail.com/

I'm not convinced for reverting. I would rater fix the problem
on top of the patches.

Looking at those images, the performance vary also on "good" case and
there is entry 12.6 Mbits/s there, where the lowest entry on "bad" case
is 32.5 Mbits/s . However, yes, if performance do not drop for unknown
reason, it is 51.4 Mbits/s with patches and 56.6 Mbits/s on good case.

Could you specify after applying which one of those 5 patches
throughput regression starts ?

Thanks
Stanislaw 
