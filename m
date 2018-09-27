Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6BBC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 408FE21571
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:10:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 408FE21571
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbeI0Q1l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbeI0Q1l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:27:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 49939308AA15;
        Thu, 27 Sep 2018 10:10:10 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAA7F5DD6B;
        Thu, 27 Sep 2018 10:10:07 +0000 (UTC)
Date:   Thu, 27 Sep 2018 12:10:02 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/26] mt76: move mt76x2_wait_for_bbp in mt76x02-lib
 module
Message-ID: <20180927101001.GB19941@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <abcc5b975da9d834067c45420397db4e3ff11e3b.1538036134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abcc5b975da9d834067c45420397db4e3ff11e3b.1538036134.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 27 Sep 2018 10:10:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 27, 2018 at 11:01:37AM +0200, Lorenzo Bianconi wrote:
> Move mt76x2_wait_for_bbp utility routine in mt76x02_util.h
> in order to be resued by mt76x0 driver
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
> +static inline bool mt76x02_wait_for_bbp(struct mt76_dev *dev)
> +{
> +	return __mt76_poll_msec(dev, MT_MAC_STATUS,
> +				MT_MAC_STATUS_TX | MT_MAC_STATUS_RX,
> +				0, 100);
> +}

I think this should be renamed to 

mt76x02_wait_for_txrx_busy()

or similar name, to avoid confusion and should be also used
in mt76x0 to replace:

        if (!mt76_poll_msec(dev, MT_MAC_STATUS,
                            MT_MAC_STATUS_TX | MT_MAC_STATUS_RX, 0, 1000))


Regards
Stanislaw

