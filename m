Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223D4C67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A0620870
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:39:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5A0620870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbeLMOjx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:39:53 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:38876 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727618AbeLMOjx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:39:53 -0500
Received: by mail-wm1-f54.google.com with SMTP id m22so2640392wml.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2018 06:39:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=la6qSuI2qqD4dfOPwX04q5JifhDBy1cdJkfAb7s1P/Y=;
        b=opQ/zhuglozEuU8860OwLQL3lTHhOeyLPbP0KpwDhfLPWi0f8C6IA44X1IHvOO4FpR
         AX79xBzdSrDxbDdIy4ZbjFYPZ3BoXbAxSInnm84Bw3EG+6jSUn67vQkXKMhPcgJBXN7p
         NGSTtWST8B54Sbc13+TWozuTUvVYvjC0aYq/9+NY4KxP2ImkvHL31/gWzeOm02BK8SnC
         KhugZvfdIv36wTgQJ5Mc19gHt+AV1L4rIbVe95TEc3Hc4hS29G2Wef+zeiM1ijRT7Tbb
         bhyasNIJf/QRb4DBNIU2TlPA4wtwWTjK9YPdR0kIaiqistBs7p7pBfAq4rqLcziTQgg/
         VLDg==
X-Gm-Message-State: AA+aEWa2yG0lqwi+x9JCBvf56opOAvOL3mcFLFornP0hQe/1jHHGeBqM
        D6MKcQxS7MuMuLBm9kcIHt7I9Q==
X-Google-Smtp-Source: AFSGD/VRqL3MHgkandlN9Z/2ekFIkhzmxq9yY3n47Qzz540RBI1auF3wAfJ/iDv+gMk4Cn71hXKO7g==
X-Received: by 2002:a1c:7ec4:: with SMTP id z187mr10265814wmc.43.1544711991571;
        Thu, 13 Dec 2018 06:39:51 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y34sm5098808wrd.68.2018.12.13.06.39.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Dec 2018 06:39:50 -0800 (PST)
Date:   Thu, 13 Dec 2018 15:39:48 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Sid Hayn <sidhayn@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        sgruszka@redhat.com, linux-mediatek@lists.infradead.org
Subject: Re: mt76x[02]u 802.11w support
Message-ID: <20181213143947.GA11947@localhost.localdomain>
References: <CAM0KTbBUXJsBfO0=hQgeTGVteym6iuObdyNynWumQnnGY0L3wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0KTbBUXJsBfO0=hQgeTGVteym6iuObdyNynWumQnnGY0L3wg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Per a conversation with Lorenzo, it seems that 802.11w for mt76x[02]u
> has only been fixed in 4.20.  As 4.19 is a LTS kernel, I'd like to
> request that work be backported.  While the improvements in 4.20 and
> 4.21 are already fairly obvious, a lot of people will be running 4.19
> for years to come.  This is good hardware, with a working driver
> (thanks team) but in the next few months excitement is going to turn
> toward WPA3 which requires working 802.11w.
> 
> Pretty please backport 802.11w support to 4.19

IIRC the isse is just on mt76x0u, mt76x2u should work

Regards,
Lorenzo

> 
> Thanks,
> Zero
