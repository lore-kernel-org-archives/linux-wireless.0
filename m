Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009C4C433FE
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Dec 2020 19:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A632E22C9C
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Dec 2020 19:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgLDTR6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Dec 2020 14:17:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgLDTR5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Dec 2020 14:17:57 -0500
Date:   Fri, 4 Dec 2020 11:17:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607109437;
        bh=NUB3I6y84JcFun3Phd5ZK6snE2Pq+CMZwL7y53m1FQM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=X63CTzr+FsYpAxflf2nIWc32fUv0mVyV+YP+0QJI4BdZoPkQqRKErgJNrLQ/LflaU
         VTY8pcWQKwB5JrQYp66dkJIOaCIUS87lv84C2Eu5qWM88S8Grkmq/04kfJ4jxv+Cpl
         WdGlrqVzAaLapwvk950fd6D4/GQUrnMwQtVRD6moobZprf2lnK6Nv8WI0Pf0+ojlvy
         IcIzLHMLPxQZ57ULvmP7qZKomMSn01ekLNXWtvSdhDCh57gWL8m5r6stGJoIqFmUmP
         tUECaPKt7fIvLgSAvG/8Elczt/2LBpOYPgZO7DLmwc6PG7Gt/pLnqPcjT92qtUnx7H
         kpouWQVvsmNcw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2020-12-03
Message-ID: <20201204111715.04d5b198@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
References: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu,  3 Dec 2020 18:57:32 +0000 (UTC) Kalle Valo wrote:
> wireless-drivers-next patches for v5.11
> 
> First set of patches for v5.11. rtw88 getting improvements to work
> better with Bluetooth and other driver also getting some new features.
> mhi-ath11k-immutable branch was pulled from mhi tree to avoid
> conflicts with mhi tree.

Pulled, but there are a lot of fixes in here which look like they
should have been part of the other PR, if you ask me. There's also 
a patch which looks like it renames a module parameter. Module
parameters are considered uAPI.
