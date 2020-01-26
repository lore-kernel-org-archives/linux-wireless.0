Return-Path: <SRS0=/TLA=3P=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE38C35240
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Jan 2020 10:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A7082075D
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Jan 2020 10:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="JbcwTXCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgAZKLH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 Jan 2020 05:11:07 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:39495 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbgAZKLH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Jan 2020 05:11:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580033467; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ArKpCudoRTrV8huNHo9JQpUNM2ZgwVkq/3kn2Bg0GY8=; b=JbcwTXCQ/8/wDtNweRejpWq+Gilnfjjq7JNxa0qS9PaaYeBpqC/wuVHXd3LPNouO4XQYj6lu
 bmp9N1yLKPUDTytJuV1Y94luVNqJP//sLGTtwFJ/r9/lacsPhEr2W45cwuWjjIORWnAB7foj
 CWHMAQ7HVbUYLbN6+CHfdcS93u4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2d65b8.7fe44ddb0ae8-smtp-out-n02;
 Sun, 26 Jan 2020 10:11:04 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6E4C1C433A2; Sun, 26 Jan 2020 10:11:03 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7CF2DC43383;
        Sun, 26 Jan 2020 10:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7CF2DC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2020-01-11
References: <f548bee28a2ef4700a024e33c02b62893af498c7.camel@coelho.fi>
Date:   Sun, 26 Jan 2020 12:10:59 +0200
In-Reply-To: <f548bee28a2ef4700a024e33c02b62893af498c7.camel@coelho.fi> (Luca
        Coelho's message of "Sat, 11 Jan 2020 11:51:28 +0200")
Message-ID: <871rrmede4.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> Here's the fist batch of patches intended for v5.6.  This includes
> the last two patchsets I sent out.  Usual development work.  More
> details about the contents in the tag description.
>
> I pushed these patches to my pending branch, but it was just now, so I
> didn't get the results from kbuildbot yet.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit ae0a723c4cfd89dad31ce238f47ccfbe81b35b84:
>
>   Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2019-12-19 18:27:36 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2020-01-11
>
> for you to fetch changes up to 0b295a1eb81f37dc7d4f4f2ee9ef375fb36ab5d8:
>
>   iwlwifi: add device name to device_info (2020-01-04 12:48:41 +0200)
>
> ----------------------------------------------------------------
> First set of patches intended for v5.6
>
> * Support new versions of the FTM FW APIs;
> * Fix an old bug in D3 (WoWLAN);
> * A couple of fixes/improvements in the receive-buffers code;
> * Fix in the debugging where we were skipping one TXQ;
> * Support new version of the beacon template FW API;
> * Print some extra information when the driver is loaded;
> * Some debugging infrastructure (aka. yoyo) updates;
> * Support for a new HW version;
> * Second phase of device configuration work started;
> * Some clean-ups;
>
> ----------------------------------------------------------------

Pulled, thanks Luca.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
