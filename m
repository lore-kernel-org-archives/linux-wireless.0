Return-Path: <SRS0=DLa0=WQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFC7C3A589
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 11:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77A5C22CF5
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 11:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfHTL1f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbfHTL1f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Aug 2019 07:27:35 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6734818C8905;
        Tue, 20 Aug 2019 11:27:35 +0000 (UTC)
Received: from localhost (unknown [10.43.2.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC1E339C3;
        Tue, 20 Aug 2019 11:27:34 +0000 (UTC)
Date:   Tue, 20 Aug 2019 13:27:31 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Fredrik Noring <noring@nocrew.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Subject: Re: rt2800: Commit 710e6cc1595e breaks ID 148f:3070 RT2870/RT3070
 USB wifi
Message-ID: <20190820112730.GB2227@redhat.com>
References: <20190820112050.GA35458@sx9>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820112050.GA35458@sx9>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 20 Aug 2019 11:27:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Aug 20, 2019 at 01:20:50PM +0200, Fredrik Noring wrote:
> Hi Stanislaw,
> 
> Commit 710e6cc1595e ("rt2800: do not nullify initialization vector data")
> breaks USB device 006: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070
> Wireless Adapter. No particular error messages are produced, but its
> interface becomes unreachable. Reverting this commit in 5.3.0-rc5 solves
> the problem.

Hi, I've recently sent the patch that should fix the problem:
https://lore.kernel.org/linux-wireless/1566213607-6723-1-git-send-email-sgruszka@redhat.com/T/#u

Stanislaw
