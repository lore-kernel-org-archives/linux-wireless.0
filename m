Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0540C433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Dec 2020 18:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 687A8224D2
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Dec 2020 18:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgL1S71 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Dec 2020 13:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgL1S71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Dec 2020 13:59:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84407224D2;
        Mon, 28 Dec 2020 18:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609181926;
        bh=PsFW1wLrURYDXeuFrLZtdtQy1yKSZIOnpfA+4J7PMs8=;
        h=Date:From:To:Cc:Subject:From;
        b=cHsSbuJoUWqpVo3wQjXQErKaK6mgEMXb0uqe3M0tgx6m61z371DNJzuwvCHyoYEVP
         ZPt1DbdKFrzj5KFUP/jOMboG9h/Vv5UDJmYypM6Lx3CBDUKsNCFoPhp+kZr65JrUU6
         1vDKnryjb59MOVL2ShbWJ2A8aHyYdch1zNguB0eM1hSYMrtDb1wb+omE4rB2lrM2Bz
         D1P7n+3MiuRBlIvTLmyh9Wjq+bCcm1hLCLL5ytQNVbhc2kL9XZx1idP8CnLCeYRvxK
         yGBB95NrmK6tSbwnZFZ8oJrC5RzocUKtIeFQ5uhL9v+uMJxWh+YK+H+UJ+bA9O46x8
         TE+CsFkZSZeuA==
Date:   Mon, 28 Dec 2020 10:58:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Subject: ath6k del interface locking
Message-ID: <20201228105845.75cc4a77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

I've been looking at various issues around netdev registration and I
run across the code in ath6kl_cfg80211_del_iface().

AFAIU nl80211 already holds the rtnl lock, because the op has NEED_RTNL:

	{
		.cmd = NL80211_CMD_DEL_INTERFACE,
		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
		.doit = nl80211_del_interface,
		.flags = GENL_UNS_ADMIN_PERM,
		.internal_flags = NL80211_FLAG_NEED_WDEV |
				  NL80211_FLAG_NEED_RTNL,
	},

So how come ath6kl_cfg80211_del_iface() takes the lock again?
