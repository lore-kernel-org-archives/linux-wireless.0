Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B496EC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ACE220823
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jiuG3s4e";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aMl88GED"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbfAVQmo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:42:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729031AbfAVQmo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 11:42:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4977F60791; Tue, 22 Jan 2019 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548175363;
        bh=UYSTGJKVyuDQyzIaI3kziFctIGSZWJJz/Bq8MkhebiI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jiuG3s4eVPDVpruuca7b1WCDRVrZ2pKgqUGE/QVE/3tETCn+CUu99Kt9kuunBYEAp
         vYlI34xzeWcqzFZzG7U/0RigSaz1laZifNFWc+Ehx6PYZh1uhvHVdOOhyoTY85VZ2x
         nGUzcTcd2RCOKRRuRDHbFOWphsnQuuF4rGbb+3cQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 667F56028D;
        Tue, 22 Jan 2019 16:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548175362;
        bh=UYSTGJKVyuDQyzIaI3kziFctIGSZWJJz/Bq8MkhebiI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aMl88GEDK/IIxGVuiszDvhql+xL2E4j/QcjvZkIhpSIwYCMebcu7uivoys14uXoqh
         IVXTgDy6BhnFjQdRwTVZxaMH6h3uBSwErzfGnA+J23LH4X5KcSjq3CRreAzaz4TCiM
         BkgZpjuI0ZQesHamhz3V6R7g017aujtE1Z9yzJ/M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 667F56028D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zhiwei Jiang <qq282012236@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath: move spin_lock_bh to spin_lock in tasklet
References: <20190122163033.51095-1-qq282012236@gmail.com>
Date:   Tue, 22 Jan 2019 18:42:39 +0200
In-Reply-To: <20190122163033.51095-1-qq282012236@gmail.com> (Zhiwei Jiang's
        message of "Wed, 23 Jan 2019 00:30:33 +0800")
Message-ID: <87ef94myo0.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Zhiwei Jiang <qq282012236@gmail.com> writes:

> as you are already in a tasklet, it is unnecessary to call
> spin_lock_bh, because softirq already disable BH.
>
> Signed-off-by: Zhiwei Jiang <qq282012236@gmail.com>

If you post a new version you should mark it as "v2":

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

No need to resend now but please keep in mind in the future.

-- 
Kalle Valo
