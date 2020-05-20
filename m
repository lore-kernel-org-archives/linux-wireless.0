Return-Path: <SRS0=yGod=7C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA91C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 20 May 2020 18:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3648206C3
	for <linux-wireless@archiver.kernel.org>; Wed, 20 May 2020 18:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgETSw5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 May 2020 14:52:57 -0400
Received: from muru.com ([72.249.23.125]:55264 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgETSw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 May 2020 14:52:57 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 7C8A7819C;
        Wed, 20 May 2020 18:53:46 +0000 (UTC)
Date:   Wed, 20 May 2020 11:52:53 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: fix runtime pm imbalance in wl1271_tx_work
Message-ID: <20200520185253.GB37466@atomide.com>
References: <20200520124241.9931-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520124241.9931-1-dinghao.liu@zju.edu.cn>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Dinghao Liu <dinghao.liu@zju.edu.cn> [691231 23:00]:
> There are two error handling paths in this functon. When
> wlcore_tx_work_locked() returns an error code, we should
> decrease the runtime PM usage counter the same way as the
> error handling path beginning from pm_runtime_get_sync().

Acked-by: Tony Lindgren <tony@atomide.com>
