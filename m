Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A10C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 15:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60CAB2081B
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 15:28:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60CAB2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbeLDP2o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 10:28:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44617 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbeLDP2o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 10:28:44 -0500
Received: from mail-yb1-f197.google.com ([209.85.219.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gUCcs-0004iI-3N
        for linux-wireless@vger.kernel.org; Tue, 04 Dec 2018 15:28:42 +0000
Received: by mail-yb1-f197.google.com with SMTP id p82-v6so8207913ybc.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2018 07:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4OtVK7sWyorMO5ZPZLtOpEWo/k4K2fQ0xrcEC++i9Bo=;
        b=RWdtly5RJC8htG1eHQ8eoCn3Orms4CUClMHQzkIjkpcfpLiMJiBHbW79XKC9NCsWZY
         YQgzoHiOroMEm1/mclKsytd1N0nOfbhMZ2qL7Aw1NopzXIlCVXjud0eD1Hfx99NBIObg
         vEuUhlLM1RAeUUYgw/Tu4PTyr7Kir5Y09go5nQ/n8i55TekW3nR7/lJd49q2b+rJlqhO
         5WPd6F0eZNJKO5Crum3Eimrz9sJe4rx4TVZ25nydULjv0w+UOul3AjIbma7YfdXNK06C
         007Z1muhekTCFDzoAWoHHXTf1Nzg5o+yrDjEdvuvFSBrlMYKVlfBjbx8QuROD8csJ+xM
         JKlA==
X-Gm-Message-State: AA+aEWZOVmlfI90EYItA3KwHm038Yk3/JzAON20TiBLNzLYrJ5rkCfVa
        E/U749+CNS+GiXhxNxt5g6qOr0EzG1kuVK0Nqr1gqhucd/M0LVA2q00C9EtvXEcRr9dXEbnb7IE
        qg9QtylpHEw6YyAA4bIhQZHOczld5M8nYb6inboElA1B6
X-Received: by 2002:a25:3502:: with SMTP id c2-v6mr19983143yba.410.1543937321052;
        Tue, 04 Dec 2018 07:28:41 -0800 (PST)
X-Google-Smtp-Source: AFSGD/UD8S0nPlRqfJADBY1IwyLdGcIVHaCo3w0VUDXiJ33/p8IEJoGv++93kbPezfEblA2RxoAclg==
X-Received: by 2002:a25:3502:: with SMTP id c2-v6mr19983112yba.410.1543937320716;
        Tue, 04 Dec 2018 07:28:40 -0800 (PST)
Received: from localhost ([2605:a601:ac7:2a20:fd7f:ef6f:b5d3:349a])
        by smtp.gmail.com with ESMTPSA id i21sm12943499ywg.5.2018.12.04.07.28.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Dec 2018 07:28:39 -0800 (PST)
Date:   Tue, 4 Dec 2018 09:28:38 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     Sven Eckelmann <sven.eckelmann@openmesh.com>,
        WIRELESS ML <linux-wireless@vger.kernel.org>,
        REGDB ML <wireless-regdb@lists.infradead.org>
Subject: Re: [PATCH] wireless-regdb: delete outdated comment for DE
Message-ID: <20181204152838.GD27074@ubuntu-xps13>
References: <20181109102420.3539-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109102420.3539-1-xose.vazquez@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 09, 2018 at 11:24:20AM +0100, Xose Vazquez Perez wrote:
> d46d731c made it obsolete.
> 
> Cc: Sven Eckelmann <sven.eckelmann@openmesh.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: WIRELESS ML <linux-wireless@vger.kernel.org>
> Cc: REGDB ML <wireless-regdb@lists.infradead.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Applied, thanks!
