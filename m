Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2381EC64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E91852087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E91852087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbeJHQEy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:04:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbeJHQEy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:04:54 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 42D82C050009;
        Mon,  8 Oct 2018 08:54:16 +0000 (UTC)
Received: from localhost (ovpn-204-38.brq.redhat.com [10.40.204.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A942B1001F5E;
        Mon,  8 Oct 2018 08:54:15 +0000 (UTC)
Date:   Mon, 8 Oct 2018 10:54:14 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: iwlegacy: Add a lock assertion in
 il4965_send_rxon_assoc()
Message-ID: <20181008085413.GA1961@redhat.com>
References: <20181005135546.21011-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005135546.21011-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 08 Oct 2018 08:54:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 05, 2018 at 09:55:46PM +0800, Jia-Ju Bai wrote:
> The variables il->staging.filter_flags, rxon1->filter_flags and 
> rxon2->filter_flags need to be protected by the mutex lock il->mutex.
> This patch adds a lock assertion of il->mutex to check whether 
> this lock is held.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
