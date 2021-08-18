Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC65C43216
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Aug 2021 08:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C08F561058
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Aug 2021 08:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhHRItp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Aug 2021 04:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhHRItg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Aug 2021 04:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8899261053;
        Wed, 18 Aug 2021 08:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629276541;
        bh=GGkX2P/e53YC5Y3E87DrwesFOzn/RDad8enFDtE/Rqk=;
        h=Date:From:To:Cc:Subject:From;
        b=ddE0AGJdx9UT7KmrCG/fXVY6E81BAJ1uT81hIjp8QES14+M0BQQn4z1RbxGAuk/lP
         4hH5mb7ssm9PIHsR2k+8ujCc8S9AHVd0eK9WeFSC7KV/G6Y0KsxKdV0PpODKovrfyc
         TwnTLlERxYKLJCjlc4TwK6/reOz8QvCAWtiPYenY76XKBAA7Get+DJlQ8IsCA7S37Z
         vtNPWTQlKXKtpx79tioMc1LofibKJBwqXnRgUFUmh4FONkFLYZmly9sX0bSGiBHosR
         FYvKNfEErU7AtvU+fAL68ox/qS20wjJwz/y3+sHdOVsVZdiAktjNFCeF3RamLtgl9Z
         m4fgnfwJlEmcw==
Received: by pali.im (Postfix)
        id 2BABD68A; Wed, 18 Aug 2021 10:48:59 +0200 (CEST)
Date:   Wed, 18 Aug 2021 10:48:59 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     stable@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <20210818084859.vcs4vs3yd6zetmyt@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello! I would like to request for backporting following ath9k commits
which are fixing CVE-2020-3702 issue.

56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardware")
d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key entry")
ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ frames reference it")

See also:
https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.org/

This CVE-2020-3702 issue affects ath9k driver in stable kernel versions.
And due to this issue Qualcomm suggests to not use open source ath9k
driver and instead to use their proprietary driver which do not have
this issue.

Details about CVE-2020-3702 are described on the ESET blog post:
https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/

Two months ago ESET tested above mentioned commits applied on top of
4.14 stable tree and confirmed that issue cannot be reproduced anymore
with those patches. Commits were applied cleanly on top of 4.14 stable
tree without need to do any modification.
