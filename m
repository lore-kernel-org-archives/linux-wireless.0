Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C73C10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 10:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80FB0206BA
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 10:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WJlvugpO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WJlvugpO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfDMKrN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 06:47:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfDMKrM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 06:47:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D46C561786; Sat, 13 Apr 2019 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555152431;
        bh=0bcCDXcR8lsYHcLIYeNoEZRfC0IiPNnJdaumBeWW22c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WJlvugpOV4TLsmGCvvvqQfeShsTuUyzQUmkD/Ys4GshW4L+6NYulX64fpgcS//+ZU
         0LY4V/V+cbYCZ059Dgsyqa/imh+Pwg/hXvP4BA1cy14Jcpj/URHCnuQCXwv5YYLFQk
         dAGezy0GEPeIi/tNZ8wyIRzx0sWRffXMC5HxlrtY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C221F61573;
        Sat, 13 Apr 2019 10:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555152431;
        bh=0bcCDXcR8lsYHcLIYeNoEZRfC0IiPNnJdaumBeWW22c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WJlvugpOV4TLsmGCvvvqQfeShsTuUyzQUmkD/Ys4GshW4L+6NYulX64fpgcS//+ZU
         0LY4V/V+cbYCZ059Dgsyqa/imh+Pwg/hXvP4BA1cy14Jcpj/URHCnuQCXwv5YYLFQk
         dAGezy0GEPeIi/tNZ8wyIRzx0sWRffXMC5HxlrtY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C221F61573
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2019-04-03
References: <713ec14872e6f0b9ced02d2d523286d522e0eab1.camel@coelho.fi>
Date:   Sat, 13 Apr 2019 13:47:06 +0300
In-Reply-To: <713ec14872e6f0b9ced02d2d523286d522e0eab1.camel@coelho.fi> (Luca
        Coelho's message of "Wed, 03 Apr 2019 11:24:51 +0300")
Message-ID: <87mukuchcl.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> This is the second batch of patches intended for v5.2.  This includes
> the last patchset I sent.  Usual development work.  More details about
> the contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 8db32fa400916333c20184793d1400bd74e1f740:
>
>   Merge tag 'iwlwifi-next-for-kalle-2019-03-22' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2019-03-30 08:37:38 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2019-04-03
>
> for you to fetch changes up to ef8a913766cd5e341da68c011b4a0ff5e2c0f5d1:
>
>   iwlwifi: remove misconfigured pci ids from 22260 series (2019-04-03 11:20:05 +0300)
>
> ----------------------------------------------------------------
> Second batch of patches intended for v5.2
>
> * Work on the new debugging infra continues;
> * Fixes for the 22000 series;
> * Support for some new FW API changes;
> * Work on new hardware continues;
> * Some debugfs cleanups by Greg-KH;
> * General bugfixes;
> * Other cleanups;
>
> ----------------------------------------------------------------

Pulled, thanks Luca.

-- 
Kalle Valo
