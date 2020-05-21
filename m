Return-Path: <SRS0=TwMq=7D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBC2C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 21 May 2020 15:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 750D520826
	for <linux-wireless@archiver.kernel.org>; Thu, 21 May 2020 15:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgEUP7Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 May 2020 11:59:25 -0400
Received: from muru.com ([72.249.23.125]:55472 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbgEUP7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 May 2020 11:59:24 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 938BA8107;
        Thu, 21 May 2020 16:00:13 +0000 (UTC)
Date:   Thu, 21 May 2020 08:59:21 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     dinghao.liu@zju.edu.cn
Cc:     kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maital Hahn <maitalm@ti.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] wlcore: fix runtime pm imbalance in wl1271_op_suspend
Message-ID: <20200521155921.GC37466@atomide.com>
References: <20200520125724.12832-1-dinghao.liu@zju.edu.cn>
 <20200520184854.GY37466@atomide.com>
 <62e69631.b9cff.1723592e191.Coremail.dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62e69631.b9cff.1723592e191.Coremail.dinghao.liu@zju.edu.cn>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* dinghao.liu@zju.edu.cn <dinghao.liu@zju.edu.cn> [200521 04:55]:
> There is a check against ret after out_sleep tag. If wl1271_configure_suspend_ap()
> returns an error code, ret will be caught by this check and a warning will be issued.

OK thanks for checking. In that case this one too:

Acked-by: Tony Lindgren <tony@atomide.com>
