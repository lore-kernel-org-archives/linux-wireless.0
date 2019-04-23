Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01CEC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 07:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 927D52077C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 07:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfDWH7y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 03:59:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfDWH7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 03:59:53 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A075C3084021;
        Tue, 23 Apr 2019 07:59:53 +0000 (UTC)
Received: from localhost (unknown [10.40.205.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0565A5D9CA;
        Tue, 23 Apr 2019 07:59:50 +0000 (UTC)
Date:   Tue, 23 Apr 2019 09:59:50 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [RFC 2/3] mt76usb: fix tx/rx stop
Message-ID: <20190423075949.GA5727@redhat.com>
References: <20190416091305.4218-1-sgruszka@redhat.com>
 <20190416091305.4218-3-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416091305.4218-3-sgruszka@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 23 Apr 2019 07:59:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 16, 2019 at 11:13:04AM +0200, Stanislaw Gruszka wrote:
> -EXPORT_SYMBOL_GPL(mt76u_stop_queues);
> +		tasklet_kill(&dev->usb.tx_tasklet);
> +
> +		/* On phisical device removal we do not get tx complete
> +		 * callbacks, need to complete our skb's manually.
> +		 */

FTR: this comment is wrong, we can have queued skb's on device removal,
but not due to not having urb complete callback, but due to kick fail
to submit urb's.

Stanislaw
