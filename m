Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5C4C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 10:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59E7B20659
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 10:37:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59E7B20659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbeLEKhp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:37:45 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:39352 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbeLEKhp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 05:37:45 -0500
Received: by mail-io1-f66.google.com with SMTP id k7so16260129iob.6
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2018 02:37:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qT6RCgxdTZEnh30z+lvbSkLfgtwC4tYgKLJ0dqs04vk=;
        b=n36Gftl5771xyHJhx/0QOIYzW9Mnj5hIPwrsQC7abBKC1hrxaOkPA8oAI6FUAmH2fj
         GjTKpupjnKnqzCFnkkYBg1VX+aIM5IrQw9NIUsj7lhPs7zwhDlMvCtOk85rpLnk4kw4M
         OVJuulc/bHpilKhPd8A1mRSG97ekxOlb02eXyL21ZJKW+sTLn4fvasZhwUuxvKolDp7L
         PJCIdjF+xl6Z/BT82BPC+R4OJYwRT3DwLBeJYWXu/yHJRumVkPtIMN+egSOnb4qMmK9u
         5cvCeYCUHqWokqvFY2AWGPGpJ6ZjLWM1qS72xrJSrhU7QJWuu1+F70hFFeKDlDqhg10b
         nJ8A==
X-Gm-Message-State: AA+aEWarO//b3S3vtv6dze8WN5diWUZKmBhhKF1mw0cxEGt8oW1hyvHm
        PCTVybIPqFG+2bmF6htQTef5gGcCnj2YzmV7emIZI6OoeVI=
X-Google-Smtp-Source: AFSGD/UT2RWNcRF1y0jiN4XDRdonoTetedVCGQTD20tW5ansHBYH58ne7bKAVl9mZi6JpoEvU2mjZtFby9ZJlj3xA8g=
X-Received: by 2002:a5d:9813:: with SMTP id a19mr3809692iol.181.1544006264250;
 Wed, 05 Dec 2018 02:37:44 -0800 (PST)
MIME-Version: 1.0
References: <cover.1543846816.git.lorenzo.bianconi@redhat.com> <8c05c03018ca9f98047ff961028f09da2e1565d0.1543846816.git.lorenzo.bianconi@redhat.com>
In-Reply-To: <8c05c03018ca9f98047ff961028f09da2e1565d0.1543846816.git.lorenzo.bianconi@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Wed, 5 Dec 2018 11:37:33 +0100
Message-ID: <CAJ0CqmWJHo8a_ffVguONBfYg0w4rm8QK99wqWBHY8-146YZogA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mt76: dma: add rx buffer recycle support
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Add support for recycling rx buffers if they are not forwarded
> to network stack instead of reallocate them from scratch
>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---

Felix,

could you please drop this patch since it does not help to reduce pressure
on page_frag_cache.

Regards,
Lorenzo
