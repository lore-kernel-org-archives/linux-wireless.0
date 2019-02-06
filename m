Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014A5C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 15:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE4382175B
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 15:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfBFPAF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:00:05 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33207 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfBFPAE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 10:00:04 -0500
Received: by mail-wr1-f67.google.com with SMTP id a16so7949219wrv.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2019 07:00:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B/u7XItHR2lP3uSuJPdtvPd3F2YZy5/LG8lT3ZsCgpc=;
        b=aNMB9LH1083Ejd6DEJcaez9NnJLzbi0ITRN4b6e2sqYU+ezLEXNuuIoxPUPctlvp6t
         MJqyFCroWyNq51MaFRrEONjUOP21WoqA+r1VGdXN6DZo+L4y/81rC0Al72H7cI5Phm4l
         e0R/cos+tC0LxKHs7q4kpCxomo+5BoPhDU96S8hNMPW3KV9r3mj9vjXHe3LF5mLB2L7+
         QlYkD4aCn+9I8qd8TGW3+ybvLWUdOd1a6nUL0m9Uui27R2WxI5VtEksnEGcl9+rRYZs6
         UoPtoJzmxOmnpqLinMJkRSgjHYWDHQTYy1ZhN6uFuEbDUGl19icaXGaap1ybWQfhvBFv
         LtTg==
X-Gm-Message-State: AHQUAubLGvCJgYaPTbqjonzUSHkY+mhIdsRWsYiPCTFnvojWNufW88u9
        9UWt7qZM4VrZURbaSevrC4nkNg==
X-Google-Smtp-Source: AHgI3IbwHLiZpImQvA2LYeI5GRZmrqw22q2hDiI5HnSL6y+RTzutkkISHW/AVPvNMqSNPscpdeITow==
X-Received: by 2002:adf:ecc8:: with SMTP id s8mr8041941wro.208.1549465202647;
        Wed, 06 Feb 2019 07:00:02 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id g10sm11802791wrq.81.2019.02.06.07.00.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Feb 2019 07:00:02 -0800 (PST)
Date:   Wed, 6 Feb 2019 15:59:59 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: Re: [PATCH] mt76: move mt76_tx_queue_mcu in mt76-core module
Message-ID: <20190206145958.GA15380@localhost.localdomain>
References: <cover.1549444343.git.lorenzo.bianconi@redhat.com>
 <1d76867dab000720e648c68b4e1b90e81564f366.1549444343.git.lorenzo.bianconi@redhat.com>
 <5a00fd0c-3177-e057-de1a-d49c6a3b1af0@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a00fd0c-3177-e057-de1a-d49c6a3b1af0@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On 2019-02-06 10:15, Lorenzo Bianconi wrote:
> > Move mt76_tx_queue_mcu routine in dma.c and remove duplicated code.
> > mt76_tx_queue_mcu will be reused adding support for mt7603 driver
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> I think we should rename this function, since it's going to be used for
> more than just MCU commands.
> Maybe mt76_dma_tx_queue_skb_raw (and add corresponding queue_op instead
> of direct calls)?
> While you're at it, maybe you could also remove mt76_queue_add_buf and
> the corresponding queue op.

ack, will fix it in v2

Regards,
Lorenzo

> 
> - Felix
