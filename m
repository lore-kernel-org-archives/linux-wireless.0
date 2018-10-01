Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7150C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6D75204FD
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:00:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6D75204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbeJAWjT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:39:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725735AbeJAWjS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:39:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 84748C05D3F6;
        Mon,  1 Oct 2018 16:00:50 +0000 (UTC)
Received: from localhost (ovpn-204-27.brq.redhat.com [10.40.204.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED5DA70BA5;
        Mon,  1 Oct 2018 16:00:33 +0000 (UTC)
Date:   Mon, 1 Oct 2018 18:00:32 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/5] mt76: move mt76x02_mac_write_txwi in mt76x02-lib module
Message-ID: <20181001160031.GA23008@redhat.com>
References: <20180929174456.995-5-lorenzo.bianconi@redhat.com>
 <20181001054838.GC22206@redhat.com>
 <20181001100656.GC3055@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001100656.GC3055@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 01 Oct 2018 16:00:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 01, 2018 at 12:06:56PM +0200, Lorenzo Bianconi wrote:
> > All above looks mt76x2 specific, maybe would be beter to place this in 
> > in setup_txwi() calback i.e:
> > 
> > 	if (dev->drv->setup_txwi)
> > 		drv->drv->setup_txwi(...)
> > 
> > or maybe you plan to implement get_tx_txpwr_adj() for mt76x0 as well,
> > is this feature supported by the MT76x0 chips ?
> 
> For the moment tpc is supported just for mt76x2 chipsets but tx power subfield
> is present in mt76x0_txwi as well. Moreover merging mt76x2_dev and mt76x0_dev
> in mt76x02_dev allows us to move mt76x2_get_tx_txpwr_adj() in mt76x02-lib
> module, remove get_tx_txpwr_adj callback and just make tpc disabled for mt76x0
> for the moment.
> As suggested by Felix, we can take into account chainmask for txstream
> configuration and remove is_mt76x2() check.
> Agree?

Yes, sounds reasonable.

Regards
Stanislaw
