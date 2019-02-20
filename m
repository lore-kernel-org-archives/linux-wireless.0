Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9A8C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B902083B
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfBTMBx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:01:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbfBTMBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:01:53 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2D86F811D7;
        Wed, 20 Feb 2019 12:01:53 +0000 (UTC)
Received: from localhost (unknown [10.40.205.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFC9119C72;
        Wed, 20 Feb 2019 12:01:50 +0000 (UTC)
Date:   Wed, 20 Feb 2019 13:01:49 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] mt76usb: allow mt76u_bulk_msg be used for reads
Message-ID: <20190220120148.GA14654@redhat.com>
References: <1550657565-7263-1-git-send-email-sgruszka@redhat.com>
 <20190220112837.GE2626@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220112837.GE2626@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 20 Feb 2019 12:01:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 20, 2019 at 12:28:38PM +0100, Lorenzo Bianconi wrote:
> [    3.476492] mt76x0u: probe of 1-1:1.0 failed with error -12

During rework of patch 3 I made silly mistake in

+       if (usb->mcu.data)
+               return -ENOMEM;

and seems I did not reload modules properly and only tested previous
revision of the set.

Stanislaw
