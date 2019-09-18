Return-Path: <SRS0=jiSJ=XN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403B2C4CEC4
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Sep 2019 14:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13E0620665
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Sep 2019 14:03:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DAMnkgK9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cPaFNWjv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbfIRODW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Sep 2019 10:03:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfIRODS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Sep 2019 10:03:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3F60560850; Wed, 18 Sep 2019 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568815397;
        bh=GI8g7BdcEpF2wvGvgxsUXnHFIMMx79kllp6rnPF+YEE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DAMnkgK9yktfhC6LpBzpzRf3ErTSGwtdXaHtu9iwR99fuYwhVzPu4vbGmRe3H2j2Y
         jV8TnVxzGPlTs1UwYl1KY4iNX5rov8FdENNkC/hj829cVAP4LVPGzp88nRSoLcGY4P
         9mZzoR0E2zT1WDIj7kDevJD5aQQTmMiPmQbBXPaE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8EDF0613A8;
        Wed, 18 Sep 2019 14:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568815396;
        bh=GI8g7BdcEpF2wvGvgxsUXnHFIMMx79kllp6rnPF+YEE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cPaFNWjv4igEjoXIw8leq53V6QydcyLRBRrA+UdRXV4uehhDiki/4NgnJLb6nW+57
         4/gFaz9oNUtiXFXn3XbHjM6pxcIZBm40fSnTqCBa4mkVn4iB1HLbYBkI8ZzxkJixYR
         3fs5g85v1J+uU3VCw3RBcPtfLLWXFfl7DSEYU01o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8EDF0613A8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Wen Gong <wgong@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN feature
References: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
        <20181114225910.GA220599@google.com>
        <CA+ASDXMh7vdfkA5jtJqWEU-g-4Ta5Xvy046zujyASZcESCGhAQ@mail.gmail.com>
Date:   Wed, 18 Sep 2019 17:03:12 +0300
In-Reply-To: <CA+ASDXMh7vdfkA5jtJqWEU-g-4Ta5Xvy046zujyASZcESCGhAQ@mail.gmail.com>
        (Brian Norris's message of "Tue, 17 Sep 2019 09:32:52 -0700")
Message-ID: <87woe5aehr.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> Since Wen has once again suggested I use this patch in other forums,
> I'll ping here to note:
>
> On Wed, Nov 14, 2018 at 2:59 PM Brian Norris <briannorris@chromium.org> wrote:
>> You've introduced a regression in 4.20-rc1:
>
> This regression still survives in the latest tree. Is it fair to just
> submit a revert?

Your description about the problem from an earlier email:

  "It seems like youre enabling SCHED_SCAN support? But you're not
   adding the NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR feature flag.
   So it puts us in a tough place on using randomization -- we either
   can't trust the FEATURE flags, or else we can't use both SCHED_SCAN
   and scan randomization."

So essentially the problem is that with firmwares supporting both
WMI_SERVICE_NLO and WMI_SERVICE_SPOOF_MAC_SUPPORT ath10k enables
NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR, but
NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR is not enabled which is
inconsistent from user space point of view. Is my understanding correct?

Wen, can you enable NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR? Does firmware
support that?

If that's not possible, one workaround might to be to not enable
NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR if firmware supports
WMI_SERVICE_NLO, but of course that would suck big time.

Here's the full context in case someone is interested:

https://patchwork.kernel.org/patch/10567005/

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
