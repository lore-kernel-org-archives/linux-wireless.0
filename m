Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778EAC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F01C2152A
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:59:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F01C2152A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbeI1PWe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 11:22:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbeI1PWd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 11:22:33 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C7D1DC05169D;
        Fri, 28 Sep 2018 08:59:48 +0000 (UTC)
Received: from localhost (ovpn-204-174.brq.redhat.com [10.40.204.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C867260F86;
        Fri, 28 Sep 2018 08:59:45 +0000 (UTC)
Date:   Fri, 28 Sep 2018 10:59:41 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 08/24] mt76: move mt76x2_wait_for_bbp in mt76x02-lib
 module
Message-ID: <20180928085940.GA8323@redhat.com>
References: <20180928064017.26870-9-lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928064017.26870-9-lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 28 Sep 2018 08:59:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Sep 28, 2018 at 08:40:01AM +0200, Lorenzo Bianconi wrote:
> +static inline bool
> +mt76x02_wait_for_txrx_active(struct mt76_dev *dev)
> +{
> +	return __mt76_poll_msec(dev, MT_MAC_STATUS,
> +				MT_MAC_STATUS_TX | MT_MAC_STATUS_RX,
> +				0, 100);
> +}

The name is unfortunate, what we wait for is TX and RX become idle
i.e. hardware do not perform any RX or TX (see for example 
mt76x2_mac_stop() ).

I think this patch should be droped and we should just use
mt76_poll_msec(MT_MAC_STATUS) directly, there is no real benefit
for this function.

Thanks
Stanislaw

