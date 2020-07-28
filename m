Return-Path: <SRS0=wFPv=BH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33687C433F1
	for <linux-wireless@archiver.kernel.org>; Tue, 28 Jul 2020 12:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 122E620759
	for <linux-wireless@archiver.kernel.org>; Tue, 28 Jul 2020 12:41:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="haoCqu+L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbgG1MlU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 Jul 2020 08:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgG1MlT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Jul 2020 08:41:19 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E090C061794;
        Tue, 28 Jul 2020 05:41:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id c6so4923912pje.1;
        Tue, 28 Jul 2020 05:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fie8IAXWZ8a1f4IBdyXwUsTRAo2+ebUYgUxfo3SFpeA=;
        b=haoCqu+L8GW/U4OWwDQnTgb9GtXYeSPf/3t+tetw4UjMKCpOcKW9zEnJX+SwLZ17LL
         BW2HDc1XLMcKdoK0p3xutk4REkdxx/RTEqfmqaPQZ6gd3tprs77Fsbv56tzrXJUsfN8H
         2HN8kNTWkCQ0guBjpN74s+oAf3YAehWjQrxT/F3jAFnj7TumR4+r70BFy9ku8o+lHHuk
         MB6HNeuF3yOVbLRmGdHmyRVIVCPQmsygQFILPj9+DOJdZSPJszFKZXjHo/NjsSx2m/we
         i5dvQMD8HdIGLmKHCWiBQPVC/OBk+W+iYpVUP4hifZQHXqgZrgyxzdv3UA0qX6eyLxIV
         7y8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fie8IAXWZ8a1f4IBdyXwUsTRAo2+ebUYgUxfo3SFpeA=;
        b=kn8lnjWZHjP95pJob9GeXkSKPMI2cnb9rUQhuhEEeVLqnLKLLXuU9NzXM+Sl9Lo8V5
         8GBST4a4ivMb+5ZSUQY2L1/UN9/mqAONqYQBNucvGx0Kxw9mHft6MWCsd3jcD4mn3dbI
         W9LI48/PrwNl4D2trwd5BKUaP8DF7RkVJzEkq+9c45W/CPKJoY5IzK3A1jDkhKYbbBje
         DKuOA3X+z1E9+X5k12ffBm935Ln4yLOfPi3aO6/AKFRb+xbIap70xdoUVoxry3WmRn0t
         VNpIcQwyxVbD1juBYXV1z3wVXTQ0nXa1np582MnzqUr1ywez8HU8camqUWocd9JbaDwm
         xBbQ==
X-Gm-Message-State: AOAM530yeZVYiVK6jQCwhDDUSoK2/bNjEV2D6vUDidtFTwkmIVKJmjBI
        xa5U+8abadlOQAlr2XanRVE=
X-Google-Smtp-Source: ABdhPJyOrg3NwW9cQWlvOe1YfodJHn7NnaR+jSpc77kZqqqtD5XzGFf31FbitFJd5NZAB025aWtEhw==
X-Received: by 2002:a17:90a:ba92:: with SMTP id t18mr4267672pjr.121.1595940079182;
        Tue, 28 Jul 2020 05:41:19 -0700 (PDT)
Received: from gmail.com ([2401:4900:2eef:ca92:3545:4a68:f406:d612])
        by smtp.gmail.com with ESMTPSA id m4sm11387168pgh.9.2020.07.28.05.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 05:41:18 -0700 (PDT)
Date:   Tue, 28 Jul 2020 18:09:48 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v1] wireless: airo: use generic power management
Message-ID: <20200728123948.GE1331847@gmail.com>
References: <20200728114128.1218310-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200728114128.1218310-1-vaibhavgupta40@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch is compile-tested only.

Thanks
Vaibhav Gupta
