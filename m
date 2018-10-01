Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819A8C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 05:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F56B2083C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 05:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F56B2083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbeJAMSp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 08:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbeJAMSp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 08:18:45 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 453753001778;
        Mon,  1 Oct 2018 05:42:45 +0000 (UTC)
Received: from localhost (ovpn-204-71.brq.redhat.com [10.40.204.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AEC317F37;
        Mon,  1 Oct 2018 05:42:41 +0000 (UTC)
Date:   Mon, 1 Oct 2018 07:42:40 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: pci: add mt76x0e_cleanup routine
Message-ID: <20181001054239.GA22206@redhat.com>
References: <20180929172641.32440-1-lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180929172641.32440-1-lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 01 Oct 2018 05:42:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

On Sat, Sep 29, 2018 at 07:26:41PM +0200, Lorenzo Bianconi wrote:
> Add mt76x0e_cleanup routine to tidy up the device
> during netdevice removal
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> +	mt76_wr(dev, MT_H2M_MAILBOX_CID, ~0);
> +	mt76_wr(dev, MT_H2M_MAILBOX_STATUS, ~0);

I don't think this is needed. Those are legacy communication registers,
most likely not used in new chips and stay in vendor driver, because
it wasn't cleaned up.

Regards
Stanislaw

