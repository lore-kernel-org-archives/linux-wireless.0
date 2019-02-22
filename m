Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A0AC4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC2E1207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfBVNAQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:00:16 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38340 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfBVNAQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 08:00:16 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gxAR1-0003Qd-Gs; Fri, 22 Feb 2019 14:00:11 +0100
Message-ID: <40cf31d7cdd64e27225e959088248924a46ed641.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: reg: Fix use-after-free in call_crda
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yue Haibing <yuehaibing@huawei.com>, davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Fri, 22 Feb 2019 14:00:08 +0100
In-Reply-To: <20190222094233.21556-1-yuehaibing@huawei.com>
References: <20190222094233.21556-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> In function reg_query_database, query_regdb_file call
> request_firmware_nowait to do request_firmware asynchronously,
> which need the caller hold the reference of dev, otherwise it will
> do put_device freeing '&reg_pdev->dev'. After that, call_crda access
> the dev will trigger use-after-free bug.

So ... OK, but how does that then only fix the firmware file loading,
rather than CRDA calling?

> This patch fix this by holding a reference of dev in regulatory_init
> after platform_device_register_simple registered successly, which
> releasing in platform_device_unregister.

This doesn't make sense? You just add a new reference and don't release
it? If there was a bug then just loading & unloading would trigger an
underflow now?

platform_device_register_full() (to which _simple is a wrapper) will
evidently return the pdev with a reference held, because it does
platform_device_put() in the error path?

johannes


