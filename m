Return-Path: <SRS0=yGod=7C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C38C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 20 May 2020 18:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A0E206C3
	for <linux-wireless@archiver.kernel.org>; Wed, 20 May 2020 18:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgETSva (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 May 2020 14:51:30 -0400
Received: from muru.com ([72.249.23.125]:55238 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgETSv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 May 2020 14:51:29 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 012AE819C;
        Wed, 20 May 2020 18:52:17 +0000 (UTC)
Date:   Wed, 20 May 2020 11:51:25 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Maital Hahn <maitalm@ti.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: fix runtime pm imbalance in
 wlcore_regdomain_config
Message-ID: <20200520185125.GA37466@atomide.com>
References: <20200520124649.10848-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520124649.10848-1-dinghao.liu@zju.edu.cn>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Dinghao Liu <dinghao.liu@zju.edu.cn> [200520 12:47]:
> pm_runtime_get_sync() increments the runtime PM usage counter even
> the call returns an error code. Thus a pairing decrement is needed
> on the error handling path to keep the counter balanced.

Acked-by: Tony Lindgren <tony@atomide.com>
