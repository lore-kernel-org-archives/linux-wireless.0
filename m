Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF378C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71FE520869
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="osXNARLa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="osXNARLa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfA2M7B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:59:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42102 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfA2M7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 07:59:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B1187601D1; Tue, 29 Jan 2019 12:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548766740;
        bh=t3YhgDGT6Dt6p9LvnpE9d0EMyHhppieKMVDn+o9lL/4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=osXNARLamGZQfnaK1v42PNhJAv07vZ8cz/KjVxJE/QQM3bI9g9HPCMTqrwDkgAjqr
         VggzNiYQsLQlv9rjcyeCpPZwOUrBe+tsvBptApCWeSLVL48qESoIliUgpUsLPrYNyO
         GQi88+uLe+G89Amq6ExZZw2TJ73VBppqi/exX88c=
Received: from x230.qca.qualcomm.com (unknown [83.145.195.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5C47E602F8;
        Tue, 29 Jan 2019 12:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548766740;
        bh=t3YhgDGT6Dt6p9LvnpE9d0EMyHhppieKMVDn+o9lL/4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=osXNARLamGZQfnaK1v42PNhJAv07vZ8cz/KjVxJE/QQM3bI9g9HPCMTqrwDkgAjqr
         VggzNiYQsLQlv9rjcyeCpPZwOUrBe+tsvBptApCWeSLVL48qESoIliUgpUsLPrYNyO
         GQi88+uLe+G89Amq6ExZZw2TJ73VBppqi/exX88c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5C47E602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2019-01-25
References: <77072ceb9ce4171311f67edb51aa5713b8e4cee9.camel@coelho.fi>
Date:   Tue, 29 Jan 2019 14:58:55 +0200
In-Reply-To: <77072ceb9ce4171311f67edb51aa5713b8e4cee9.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 25 Jan 2019 21:09:43 +0200")
Message-ID: <878sz3wrg0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the first batch of patches intended for v5.1.  This includes
> the last two patchsets I sent.  Usual development work.  More details
> about the contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 4ad0be160544ffbdafb7cec39bb8e6dd0a97317a:
>
>   brcmfmac: Use firmware_request_nowarn for the clm_blob (2019-01-10 13:41:03 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2019-01-25

Pulled, thanks.

-- 
Kalle Valo
