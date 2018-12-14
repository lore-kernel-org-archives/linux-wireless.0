Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B83C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 15:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFC8620656
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 15:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DXwRbnxs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DXwRbnxs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbeLNPGo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 10:06:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729687AbeLNPGo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 10:06:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8C8B560128; Fri, 14 Dec 2018 15:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544800003;
        bh=1ZLFbepdaW+5uEVSEn44JByBtcD4+mA8c5eDiQxLabQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DXwRbnxskI3J6AXPMpv+veWl6owwmNXYfJdQr1iGuQy7PFiJwRzS2MhC2lI2eWKMH
         VcQY3MR049e+pIZH8mVvwrFW69kFcA+5pJDFwCkVOdq2kZqkSVZEX/vJpQG0+BME18
         8ht7b/0FRuF90I27mZWqmYbB5Ik7NP8nzf8kQO7U=
Received: from x230.qca.qualcomm.com (37-33-70-195.bb.dnainternet.fi [37.33.70.195])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C05DB60208;
        Fri, 14 Dec 2018 15:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544800003;
        bh=1ZLFbepdaW+5uEVSEn44JByBtcD4+mA8c5eDiQxLabQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DXwRbnxskI3J6AXPMpv+veWl6owwmNXYfJdQr1iGuQy7PFiJwRzS2MhC2lI2eWKMH
         VcQY3MR049e+pIZH8mVvwrFW69kFcA+5pJDFwCkVOdq2kZqkSVZEX/vJpQG0+BME18
         8ht7b/0FRuF90I27mZWqmYbB5Ik7NP8nzf8kQO7U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C05DB60208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-12-14
References: <d17183ee2870be4c61b9d8b80c1e0a34496ca327.camel@coelho.fi>
Date:   Fri, 14 Dec 2018 17:06:38 +0200
In-Reply-To: <d17183ee2870be4c61b9d8b80c1e0a34496ca327.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 14 Dec 2018 15:59:33 +0200")
Message-ID: <87o99ocflt.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the third batch of patches intended for v4.21.  This includes
> only the last patchset I sent.  Usual development work, continuing with
> the new debugging infrastructure, some 802.11ax fixes in radiotap and
> other small fixes and cleanups.  More details about the contents in the
> tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit e3e454b7047a8bb11c0311ab1708e040481a6044:
>
>   rtlwifi: rtl8821ae: remove set but not used variable 'type' in translate_rx_signal_stuff (2018-12-13 17:04:09 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-12-14
>
> for you to fetch changes up to 55ed14cdaec503bfe6a94f0524d0d2c9b7226aed:
>
>   iwlwifi: mvm: don't check if a pointer is set if it can't be unset (2018-12-14 13:04:49 +0200)
>
> ----------------------------------------------------------------
> Third batch of iwlwifi patches intended for v4.21
>
> * Some cleanups in the HW configuration structures;
> * More work on the debugging infrastructure;
> * Fixes related to 802.11ax;
> * Other cleanups and small fixes;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
