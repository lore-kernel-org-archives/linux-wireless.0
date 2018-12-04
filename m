Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FA9C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 15:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 262612081B
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 15:29:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 262612081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbeLDP3F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 10:29:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44632 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbeLDP3F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 10:29:05 -0500
Received: from mail-yw1-f72.google.com ([209.85.161.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gUCdD-0004jw-8w
        for linux-wireless@vger.kernel.org; Tue, 04 Dec 2018 15:29:03 +0000
Received: by mail-yw1-f72.google.com with SMTP id v7so12116713ywv.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2018 07:29:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IsN7oZC2cLZDCeY4f436v2CWe+CewZLUn+O/VVTV7wg=;
        b=KbvGKQ8G72mKoPrPyGpvz8rV0PGbt0J7dez+eXZQmPeyD2trriOvfcdk2pvt3bqlWt
         7FjlVJX4F+GASdrXur4qjDWIUagAaZEjM03nb7wKBKRzMFi5VaDLmmD8j9qFdjcDeY90
         yEH5CeFt8JP6LCM3OXdybrU6TrS9Rvh0rk+HAvS0vcwPCGglCeV4BK8ucFh/lnnpqsb0
         A5X6dR569uWsmmglVKwiiovUOddM8Ii2QpmfrFMnFNgNgTSc1c5Gm3bYxnBTOlokMqIi
         73VqCI9SGcufjPpvzUuSsHGPVCqfcSVzfMUcHdbR1DFJtCDmqbfQRFYRqaQHV4LaLivG
         FNjQ==
X-Gm-Message-State: AA+aEWbC7BgG+mORGnyJvvJYkr+1w5gp7eHuiBvM6UatT4Le0659yb9u
        xnuLfP37JwDxMj7jMIrr07O4ZJllkxrK33cEdXO5DXgZ5fQeB6xrsT4b8ah3W7/TYvNB1jd4P+Z
        GXunqfAIiqJIak8iMspByyNc23BejaNv+4oULwrnHSYOD
X-Received: by 2002:a25:b990:: with SMTP id r16-v6mr19419211ybg.74.1543937342300;
        Tue, 04 Dec 2018 07:29:02 -0800 (PST)
X-Google-Smtp-Source: AFSGD/XfWCJU/PvkqmEaeT5GZt4HgVBKmpfL2b1yfqdll4EUnqp8K4JKrJkJXhYPRm3SxGdyKjlxvg==
X-Received: by 2002:a25:b990:: with SMTP id r16-v6mr19419181ybg.74.1543937341893;
        Tue, 04 Dec 2018 07:29:01 -0800 (PST)
Received: from localhost ([2605:a601:ac7:2a20:fd7f:ef6f:b5d3:349a])
        by smtp.gmail.com with ESMTPSA id p3sm5319621ywc.14.2018.12.04.07.29.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Dec 2018 07:29:01 -0800 (PST)
Date:   Tue, 4 Dec 2018 09:29:00 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     WIRELESS ML <linux-wireless@vger.kernel.org>,
        REGDB ML <wireless-regdb@lists.infradead.org>
Subject: Re: [PATCH] wireless-regdb: add URLs in README
Message-ID: <20181204152900.GE27074@ubuntu-xps13>
References: <20181109171003.27069-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109171003.27069-1-xose.vazquez@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 09, 2018 at 06:10:03PM +0100, Xose Vazquez Perez wrote:
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: WIRELESS ML <linux-wireless@vger.kernel.org>
> Cc: REGDB ML <wireless-regdb@lists.infradead.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Applied, thanks!
