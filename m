Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1870C432BE
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Jul 2021 09:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAC3B60725
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Jul 2021 09:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhGWIqf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Jul 2021 04:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGWIqe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jul 2021 04:46:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF995C061575
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2021 02:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=qPfFaOLBHgpoI6w81CzCXw4FrJ9U3ruhTNXi7T80MFY=;
        t=1627032427; x=1628242027; b=m+M6epuOM9rmad1yA/hWLCDCEpDBGNN2FSDeVhQ4kxAfDQs
        sQmVm0BgmjQLXOgjaFa0y0cRxYgloHrinYKRa4aA5UcRFjTK9mq/28EDmyZzNDRAeWyUHhFy4pfjt
        7YA+R5m+Bo5Z+sHTIqZ1c4LBEaAq6badpys7cFmTXneA0Ucsr83XFERpupZxhF9pB059/ICcY0EX9
        OjejrBKOrVUMqKN8Bw3Ulm6J8om6l0PySBXZbCpFESI7M7SHiaCKN0YgpnMg5Z6pwsNI4B1/i7XIc
        c3NzWCKiAr1QLaEmidSngQKe11+da3AJ3bzsDfK/BXXOw+VnWEth5XOF2tvRLyHQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m6rPs-000U4a-OA; Fri, 23 Jul 2021 11:27:03 +0200
Message-ID: <4647af4472b14452347a0817c25c3f61d174bf5e.camel@sipsolutions.net>
Subject: Re: [PATCH 5/9] cfg80211: save power spectral density(psd) of
 regulatory rule
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Wen Gong <wgong@codeaurora.org>, ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 23 Jul 2021 11:27:02 +0200
In-Reply-To: <20210517201932.8860-6-wgong@codeaurora.org> (sfid-20210517_222029_223410_9F039F8A)
References: <20210517201932.8860-1-wgong@codeaurora.org>
         <20210517201932.8860-6-wgong@codeaurora.org>
         (sfid-20210517_222029_223410_9F039F8A)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2021-05-17 at 16:19 -0400, Wen Gong wrote:
> The power spectral density(psd) of regulatory rule should be take
> effect to the channels. This patch is to save the values to the
> channel which has psd value.

It seems to me you should also add provisions to allow regdb file from
userspace to have the PSD value?

johannes

