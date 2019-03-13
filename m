Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61070C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 12:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31BD02171F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 12:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfCMMxP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 08:53:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfCMMxO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 08:53:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D2A7030024AB;
        Wed, 13 Mar 2019 12:53:14 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7711E604CE;
        Wed, 13 Mar 2019 12:53:10 +0000 (UTC)
Date:   Wed, 13 Mar 2019 13:53:09 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 05/12] mt76usb: remove mt76u_buf redundant fileds
Message-ID: <20190313125308.GA2003@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
 <1552403166-3821-6-git-send-email-sgruszka@redhat.com>
 <20190312162549.GD2611@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190312162549.GD2611@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 13 Mar 2019 12:53:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 12, 2019 at 05:25:50PM +0100, Lorenzo Bianconi wrote:
> >  	buf = &q->entry[idx].ubuf;
> > -	buf->buf = skb->data;
> > -	buf->len = skb->len;
> > +	if (!dev->usb.sg_en) {
> > +		buf->urb->transfer_buffer = skb->data;
> 
> I think you can move this in mt76u_tx_build_sg or remove the if condition in
> mt76u_tx_build_sg()

I'll rename mt76u_tx_build_sg() to mt76u_tx_setup_bufffers() then,
which will more corresponding the what the function do.

Stanislaw
