Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26B1C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 19:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B620E2081B
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 19:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Zq24ogAk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PZgd1sn3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfBTTIN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 14:08:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41898 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfBTTIM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 14:08:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2E03360850; Wed, 20 Feb 2019 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550689692;
        bh=jkg4LlOrCEJZf8sxNmja8OowEjVSDSnrROPK28PKi7g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Zq24ogAkAVVdred3Ctowzu0A91dAcRjtz9jaecaeb79fGuEoUMHKsPZVHgX/bhgMB
         +pcsKnOQuZQUQ+ia5UXO1EPzCyHb+sCeg+An7MWUhnD7id7/LGzhrEBgBrHn0p6/zI
         4ipwyCq9N/xkwvcpHt+qoXDrvE1bntMXlefQ9lV4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 91B0D6034E;
        Wed, 20 Feb 2019 19:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550689690;
        bh=jkg4LlOrCEJZf8sxNmja8OowEjVSDSnrROPK28PKi7g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PZgd1sn3tzwe4cEJBVeu3f9zb/soYGgEToF/xDc54RsaZZdv7h2Hz1UfOt3rdh2X2
         cLlhui00wMXNpWnsPOqzjqVI2HhHNQfHyOanWvasDWUq78EcUsN4JKutGM9XKVq74m
         KvwdS9a9TOqWZG6q3Ejcal2iR1Fu/H/V0o/cw1yY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 91B0D6034E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2019-02-20
References: <8bf655adcf1e58a5e2fd25404a3ae3693cd9e154.camel@coelho.fi>
Date:   Wed, 20 Feb 2019 21:08:07 +0200
In-Reply-To: <8bf655adcf1e58a5e2fd25404a3ae3693cd9e154.camel@coelho.fi> (Luca
        Coelho's message of "Wed, 20 Feb 2019 20:56:40 +0200")
Message-ID: <87o976p9bc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the fifth and last batch of patches intended for v5.1.  This
> includes the last two patchsets I sent.  Usual development work.  More
> details about the contents in the tag description.
>
> As agreed, I'm sending this before kbuildbot finished its tests, but we
> can fix any problems that may arise.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 6c88e0ce5ebcbac8ac930c0149c217c6aa7ab0a3:
>
>   Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2019-02-20 20:01:27 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2019-02-20
>
> for you to fetch changes up to 085486de833e383705bce61dbde8d31077f5b8ca:
>
>   iwlwifi: add new cards for 22000 and killer series and change the market name (2019-02-20 20:48:01 +0200)
>
> ----------------------------------------------------------------
> Fifth batch of iwlwifi patches intended for v5.1
>
> * Some small fixes and continued work on the new debugging
>   infrastructure;
> * Greg's debugfs clean-ups;
> * Some janitorial patches from the community;
> * Fix to one false-positive compiler warning;
> * VHT extended NSS support;
> * New PCI IDs for 9260 and 22000 series;
> * Other general bugfixes and cleanups;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
