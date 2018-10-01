Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374BFC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 05:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC58F2083C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 05:44:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC58F2083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbeJAMUB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 08:20:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbeJAMUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 08:20:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B258081DE1;
        Mon,  1 Oct 2018 05:44:00 +0000 (UTC)
Received: from localhost (ovpn-204-71.brq.redhat.com [10.40.204.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30ADA705A2;
        Mon,  1 Oct 2018 05:43:57 +0000 (UTC)
Date:   Mon, 1 Oct 2018 07:43:56 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: init: intrduce MT_H2M_* definitions
Message-ID: <20181001054355.GB22206@redhat.com>
References: <20180929173032.32747-1-lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180929173032.32747-1-lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 01 Oct 2018 05:44:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Sep 29, 2018 at 07:30:32PM +0200, Lorenzo Bianconi wrote:
> Add MT_H2M_BBP_AGENT, MT_H2M_MAILBOX_CSR and MT_H2M_INT_SRC and
> remove magic numbers
> 
>  
>  	/* TODO: Probably not needed */
> -	mt76_wr(dev, 0x7028, 0);
> -	mt76_wr(dev, 0x7010, 0);
> -	mt76_wr(dev, 0x7024, 0);
> -	msleep(10);
> +	mt76_wr(dev, MT_H2M_BBP_AGENT, 0);
> +	mt76_wr(dev, MT_H2M_MAILBOX_CSR, 0);
> +	mt76_wr(dev, MT_H2M_INT_SRC, 0);

The same here, I think this should be just removed.

> +	usleep_range(10000, 20000);

Why this change ?

Thanks
Stanislaw
