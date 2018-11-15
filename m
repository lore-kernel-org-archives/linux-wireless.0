Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65456C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 15:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CECA2145D
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 15:00:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CzGFQQnM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Yth4ELcr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CECA2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388452AbeKPBI6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 20:08:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387922AbeKPBI6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 20:08:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 581B3609F3; Thu, 15 Nov 2018 15:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542294047;
        bh=+d0vJ78U6J1XsJl8ZVT22PdIxwLe9dpU0J1CflVkBno=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CzGFQQnMPHp6XLaqhPHwaS0yfJ5Yj8i/f5FUK1b2iK5hfqn0EK+l/h1rKrcm+a0MV
         45WGerkAkf1IeFeR48zrdpstthyIoS68wZ9C0cesyywAFBHIi2QMXMk0x5mULNXcv6
         jzNUGWfLK4S1dvjShNsIJ1DLu7Disoi3M7nIyGGM=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4756F60722;
        Thu, 15 Nov 2018 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542294046;
        bh=+d0vJ78U6J1XsJl8ZVT22PdIxwLe9dpU0J1CflVkBno=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Yth4ELcrKWiltuy70MANC2tah1rjloFc6ewRxjyo7v1Ls8/i/7dppMSGGEm5HlWuM
         /Vn88UmPJxyHBQpACqsE8SnCPS6lv9uD1lGl7B/2OkSOXwDbEns6s60djv0Cet7U6W
         0coEx611t4Uv7S3rLltvLZuYrxcqJxBZiU0PCFF0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4756F60722
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-11-11
References: <fa556d1212cd48befec5fe0ea8a1f9ca2efcae89.camel@coelho.fi>
Date:   Thu, 15 Nov 2018 17:00:42 +0200
In-Reply-To: <fa556d1212cd48befec5fe0ea8a1f9ca2efcae89.camel@coelho.fi> (Luca
        Coelho's message of "Sun, 11 Nov 2018 11:12:55 +0200")
Message-ID: <874lci9yhx.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the first batch of patches intended for v4.21.  This includes
> only the last patchset I sent.  Usual development work, new PCI IDs and
> small fixes and cleanups.  More details about the contents in the tag
> description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit bb38177cb6c6dc973ad8b88f219742b29f3002f1:
>
>   Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2018-11-09 17:15:25 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-11-11
>
> for you to fetch changes up to 56b657f7f9c07421a4f910b7e2b382184f1ddbc8:
>
>   iwlwifi: fw: use helper to determine whether to dump paging (2018-11-11 11:06:23 +0200)
>
> ----------------------------------------------------------------
> First set of iwlwifi patches for 4.21
>
> * PCI IDs for some new 9000-series cards;
> * Improve antenna usage on connection problems;
> * Some improvements in the debugging code;
> * Other clean-ups and small fixes;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
