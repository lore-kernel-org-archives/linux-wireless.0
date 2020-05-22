Return-Path: <SRS0=4wL/=7E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B86C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 May 2020 17:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 061D720756
	for <linux-wireless@archiver.kernel.org>; Fri, 22 May 2020 17:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgEVR55 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 May 2020 13:57:57 -0400
Received: from muru.com ([72.249.23.125]:55554 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730702AbgEVR55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 May 2020 13:57:57 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id E722F8087;
        Fri, 22 May 2020 17:58:45 +0000 (UTC)
Date:   Fri, 22 May 2020 10:57:53 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Guy Mishol <guym@ti.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: fix runtime pm imbalance in wlcore_irq_locked
Message-ID: <20200522175753.GD37466@atomide.com>
References: <20200522044906.29564-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522044906.29564-1-dinghao.liu@zju.edu.cn>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Dinghao Liu <dinghao.liu@zju.edu.cn> [200522 04:50]:
> When wlcore_fw_status() returns an error code, a pairing
> runtime PM usage counter decrement is needed to keep the
> counter balanced. It's the same for all error paths after
> wlcore_fw_status().

Acked-by: Tony Lindgren <tony@atomide.com>
