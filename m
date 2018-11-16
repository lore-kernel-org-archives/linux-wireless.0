Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD232C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 07:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DE0720818
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 07:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DtzmAsvO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BXLMwuQb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DE0720818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbeKPRPt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 12:15:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51674 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbeKPRPs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 12:15:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D8E6605A2; Fri, 16 Nov 2018 07:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542351881;
        bh=CUkCvDhLjMxIxocZskPVDzTL7wvbbspx5QuvXWEpyF0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DtzmAsvOSE1XkmaXBlOgfMiKGdovbVQnR3f1KDasR6Bk814K/zrdg2sbk8Os+Q5aA
         TOvSc0Phk6Xi4nT1T4kulw5Ul8aSlnamtWSTxYc2SZyx60uo7f4fEDO2C3joEqUUKB
         p5/NB17uCVOpi1XBSvAmsguj+KavlJQXjployQOk=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 44CE460452;
        Fri, 16 Nov 2018 07:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542351880;
        bh=CUkCvDhLjMxIxocZskPVDzTL7wvbbspx5QuvXWEpyF0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BXLMwuQbY6cd7OKHrRRkYUdOrna3+ipEgcgzMsXR1GiuZ31Bq3dpAk7xGi7bFPLad
         JbEmnsOffQPpTHMGWHs2zZq38nt4P/GI55m+iRjfdUT9d5mtjWFBvB/dYEep8tjMtN
         piKmsya5XVE5jNaS8sF047kjaPel7MX7ivtfKujE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 44CE460452
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi 2018-11-15
References: <36b1d59aec9ed10decb32d054de33bb108530a26.camel@coelho.fi>
Date:   Fri, 16 Nov 2018 09:04:37 +0200
In-Reply-To: <36b1d59aec9ed10decb32d054de33bb108530a26.camel@coelho.fi> (Luca
        Coelho's message of "Thu, 15 Nov 2018 23:57:11 +0200")
Message-ID: <87r2fl8pve.fsf@codeaurora.org>
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
> This is the first batch of fixes for v4.20.  More details about the
> contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit b374e8686fc35ae124e62dc78725ea656ba1ef8a:
>
>   mt76: fix building without CONFIG_LEDS_CLASS (2018-11-06 18:46:33 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-for-kalle-2018-11-15
>
> for you to fetch changes up to 5d041c46ccb9b48acc110e214beff5e2789311df:
>
>   iwlwifi: mvm: don't use SAR Geo if basic SAR is not used (2018-11-15 23:50:59 +0200)
>
> ----------------------------------------------------------------
> First batch of iwlwifi fixes for 4.20
>
> * New FW debugging infrastructure;
> * Some more work on 802.11ax;
> * Improve support for multiple RF modules with 22000 devices;
> * Remove an unused FW parameter;
> * Other debugging improvements;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
