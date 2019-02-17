Return-Path: <SRS0=gO0h=QY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F36C10F06
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 10:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFEBE2173C
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 10:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfBQKz7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Feb 2019 05:55:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36203 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbfBQKz6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Feb 2019 05:55:58 -0500
Received: from mail-ed1-f72.google.com ([209.85.208.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gvK72-0005Ym-Ni
        for linux-wireless@vger.kernel.org; Sun, 17 Feb 2019 10:55:56 +0000
Received: by mail-ed1-f72.google.com with SMTP id x47so5793008eda.8
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2019 02:55:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uT631aO6NiInK2Yu6novw/Arfcw6/Fug3W4a4+ZUT+4=;
        b=qCe24eMCg3w0pPczMWLlRTkEH2LbfU6OLFIPJLFhEsgh1u6YPY6f+6R2C8FUk8SFDk
         58t7Emmt5A6xKbsQJeu8PfEf11lkueqHtBuqsVDPFuRUAoYoA6hh9JaBzFZGG5ZIwEZH
         YxYCKhNnbRQ7oJfQmnyc9t3GUbuybe0c1+nSyI49UEd9YQCGpD7V8atnhabcvDnLJybW
         zvQaGh1drUXQ8V1RUNqImfpg4XKN0gdwa9Esvkz2wCPjCsLFxOx90u4NBk/HGSpmGILO
         N2d9ST/1y0g+MPmEKMTP27+Xxu7rC+NnlHF7up6l22Ac6NZjs84Q+8Uk1bx8Rj/r6ZaB
         U6GA==
X-Gm-Message-State: AHQUAuYUuPJgV3RVW8SfL4WhwLkMVHfpJKM/nuN+v3Ps5gVUKuRIjo5J
        v2DqWtzKH5V3ofEvPMnZlc+WB4X4bSa3D+7FLjH6+mLjqJ9PsyMLDQkIIJSD14ujZLf7nhPrsbO
        2IYXS2dgELA15rTWY1vKnLitHPxepanj4SoiCY+qa9q+Z
X-Received: by 2002:a50:eb0d:: with SMTP id y13mr14428520edp.167.1550400956286;
        Sun, 17 Feb 2019 02:55:56 -0800 (PST)
X-Google-Smtp-Source: AHgI3IYp53S1JQVihIKS+EE+8cNpyh3aXpRNCE+Dg5pUzfz17LG5YNvxUwtdM5Wkkj6cUbBOS6nVWw==
X-Received: by 2002:a50:eb0d:: with SMTP id y13mr14428501edp.167.1550400955955;
        Sun, 17 Feb 2019 02:55:55 -0800 (PST)
Received: from localhost ([88.128.80.113])
        by smtp.gmail.com with ESMTPSA id e2sm2773981edk.87.2019.02.17.02.55.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Feb 2019 02:55:55 -0800 (PST)
Date:   Sun, 17 Feb 2019 11:55:54 +0100
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Felix Fietkau <felix@wiowireless.com>,
        wireless-regdb@lists.infradead.org
Subject: Re: [PATCH v2] wireless-regdb: Sync IN with G.S.R. 1048(E), October
 2018
Message-ID: <20190217105554.GC22074@ubuntu-xps13>
References: <20190209101947.4876-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190209101947.4876-1-nbd@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Feb 09, 2019 at 11:19:47AM +0100, Felix Fietkau wrote:
> From: Felix Fietkau <felix@wiowireless.com>
> 
> Add new frequency ranges, increase power, as documented in:
> http://wpc.dot.gov.in/WriteReadData/userfiles/License%20Exemption%20in%205%20GHz%20G_S_R_1048(E)%20dated%2022nd%20October,%202018.pdf
> 
> Signed-off-by: Felix Fietkau <felix@wiowireless.com>

Please also include wireless-regdb@lists.infradead.org on wireless-regdb
patches.

Applied, thanks!
