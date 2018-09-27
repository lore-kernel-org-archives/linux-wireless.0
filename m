Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FF4C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 18:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A876F21708
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 18:21:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YKQAs5Ui";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GDppN34P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A876F21708
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbeI1Akg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:40:36 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57988 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727621AbeI1Akg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 20:40:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 85013609A8; Thu, 27 Sep 2018 18:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538072464;
        bh=DaEGgy9Na5zhawu1RHOfdJiHTEGGQbyTvfjDIZS9020=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YKQAs5UixHamj4H2qIycGHPHxozLnyiOcMU58O3ya+PfG4zZtXVRxz9E2kT4/GIa2
         p22OBQn5AytuNhdiw61oeefTHHKFovJGT0Zns8w24CYkjFK/k982t46bFB2wItYUc1
         v+OX3XfaHj/mk57cHLJfJVH2LYxM6fN4hUqWKPes=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 631FA60274;
        Thu, 27 Sep 2018 18:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538072457;
        bh=DaEGgy9Na5zhawu1RHOfdJiHTEGGQbyTvfjDIZS9020=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=GDppN34PQElgkUifvgt8Fbz5sSUeJmJ90mgIrNGnf1lX4JQBEud3MGHeKvwxLik+E
         OnE7KHqbjGjHZmUUiST5BB771c5XCZGxEuZPoeQv/RxJRaWABC1rtLlM2oQ2R+AVkX
         48wAX7s7TITx7l6mJJhFKqkPqxuL9Wd9qVRtz6NA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 631FA60274
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4.19] iwlwifi: 1000: set the TFD queue size
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180925135653.24094-1-luca@coelho.fi>
References: <20180925135653.24094-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20180927182104.85013609A8@smtp.codeaurora.org>
Date:   Thu, 27 Sep 2018 18:21:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Pavel Machek <pavel@ucw.cz>
> 
> .max_tfd_queue_size was ommited for 1000 card serries leading to oops in
> swiotlb.
> 
> Fixes: 7b3e42ea2ead ("iwlwifi: support multiple tfd queue max sizes for different devices")
> Tested-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

3baafeffa48a iwlwifi: 1000: set the TFD queue size

-- 
https://patchwork.kernel.org/patch/10614047/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

