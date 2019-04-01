Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5EBC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 20:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE1E20857
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 20:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="nWRFDUC8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfDAUqP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 16:46:15 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52703 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfDAUqO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 16:46:14 -0400
Received: by mail-it1-f194.google.com with SMTP id g17so1459640ita.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Apr 2019 13:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FavsM46h4CZKEcsfAQHLvOm2VBMwaDevdw0eQHm/J8Y=;
        b=nWRFDUC84gItK3k53YS9uwvUHGS2rNl8bcP1iR7v4VplPp6+CPxKLlVUfFKVXjzV7u
         lHE6sKjw8tpxb709zRQIxv8x9J8dyYbtahdGeD74kLS9S6AaIZTbGisH0md0mu1zETUc
         FZvyfruAYOGU01u5nPqVLNnGzxdBdQdV+AWVLazFILS/IcD/jSKd2+WdVMOn082UZCUS
         Taiw6u66bYzMIF0SIpX8mmE0GaYBLVbiYhGlFF28cCMVefkQ8qOuC5rHGeUlJ/iEz7Nw
         GbFtiwMe9CA/cpsvxM5NjsaxuAc4JLgc4XZUiFCH0IEJx37PP5FA1jH6Me/F5ocqaPD5
         TJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FavsM46h4CZKEcsfAQHLvOm2VBMwaDevdw0eQHm/J8Y=;
        b=eirP0BSim6eubzTP3G1huBpJo7Ujc0bTppGzP0PXG+R+3dvtZSM3onc4Tq+be8GLPm
         NOWa4UFXNv0mQ2bK078iaRbEcObZf34+H8WDLj2Ki7y4LdrLtXDoo32dc/IweChUrjHG
         BT9ob2+pk0vDpCqW8zBIGlabrlliKYnwZ9VgkKR/qkBUfCZbEJjNltx5w5HZ25DPslqQ
         cJrKSbghf3Whq9UXhdJqqoZJ7z9cTTIMdn1BytRUmfmcjBTIY81MGBavXmIO0oNYiPJ6
         S/rDIXRcFedaxcQJBrp6SmvTgIiuSTNiNPhWf/6Fvn80rQjXhnw8Dz6K0TxZRknx3nQn
         HLRA==
X-Gm-Message-State: APjAAAXYRsk/CUy1ElHnIOtqdB7C1gRtpd2DsvjxFkLxUvFbCxXKtanN
        gIj5iRH2NCc+xymjpKSOIE2ZDg==
X-Google-Smtp-Source: APXvYqxT1xEGPDO7pP4+cMsPmepvpTAVQW+bJ68kz830vHuiDcIcRodjuJ0PG5nQg/kpXcRb3zjS6Q==
X-Received: by 2002:a24:1451:: with SMTP id 78mr1284125itg.51.1554151573921;
        Mon, 01 Apr 2019 13:46:13 -0700 (PDT)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id n124sm5806437itg.2.2019.04.01.13.46.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Apr 2019 13:46:12 -0700 (PDT)
Received: from bob by hash with local (Exim 4.92-RC6)
        (envelope-from <me@bobcopeland.com>)
        id 1hB3oq-0002Q7-2f; Mon, 01 Apr 2019 16:46:12 -0400
Date:   Mon, 1 Apr 2019 16:46:12 -0400
From:   Bob Copeland <me@bobcopeland.com>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Subject: Re: [PATCH v4 1/3] cfg80211: Add support to set tx power for a
 station associated
Message-ID: <20190401204611.GA8910@localhost>
References: <1553856501-21492-1-git-send-email-bpothuno@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553856501-21492-1-git-send-email-bpothuno@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Balaji,

I started playing with these patches a bit -- they could be useful for
my use case, but I had a question:

> + * @power: tx power (in dBm) to be used for sending data traffic. If tx power
> + *	is not provided, the default per-interface tx power setting will be
> + *	overriding. Driver should be picking up the lowest tx power, either tx
> + *	power per-interface or per-station.

Should this really dBm?  It's a bit asymmetric for WIPHY_TX_POWER_LEVEL to
use mBm and this to use dBm, and I might want to adjust in half-dB steps if
supported by hardware.  Also allocating an s16 is a bit much for dBm.

-- 
Bob Copeland %% https://bobcopeland.com/
