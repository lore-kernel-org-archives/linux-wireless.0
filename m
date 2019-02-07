Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDDCC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E02E52075C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:44:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fIpZZOd0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fIpZZOd0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfBGJo3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:44:29 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfBGJo2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 04:44:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E6B4460878; Thu,  7 Feb 2019 09:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549532667;
        bh=vit+QNRdJI9eAcJCktz1Z+gH2uJGcBvIqA5Dasxqo70=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fIpZZOd0vXpDk1abT7H3riirdmr19xA3e/DBA6oC04f0+IdbPKozZlcnXQkt52oQr
         IGarHD9YBeBvzhh1o+LrQiWMk3x3IBOxbTU6e0OxFgcRlKd43f1k4GdlUWHmi8ltZg
         TmP8Omy/RWvGNZK8OyaeXyZievAS5fD7rbC2bSgc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3E7DF602CB;
        Thu,  7 Feb 2019 09:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549532667;
        bh=vit+QNRdJI9eAcJCktz1Z+gH2uJGcBvIqA5Dasxqo70=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fIpZZOd0vXpDk1abT7H3riirdmr19xA3e/DBA6oC04f0+IdbPKozZlcnXQkt52oQr
         IGarHD9YBeBvzhh1o+LrQiWMk3x3IBOxbTU6e0OxFgcRlKd43f1k4GdlUWHmi8ltZg
         TmP8Omy/RWvGNZK8OyaeXyZievAS5fD7rbC2bSgc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3E7DF602CB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2019-02-04
References: <398c36d2200bce61e943f728aded412e9b4cf0cc.camel@coelho.fi>
Date:   Thu, 07 Feb 2019 11:44:24 +0200
In-Reply-To: <398c36d2200bce61e943f728aded412e9b4cf0cc.camel@coelho.fi> (Luca
        Coelho's message of "Mon, 04 Feb 2019 12:40:20 +0200")
Message-ID: <878sys9blz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the third batch of patches intended for v5.1.  This includes
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
> The following changes since commit 030b43671ae88f827a415ad35700705ffc10d10d:
>
>   wireless: prefix header search paths with $(srctree)/ (2019-02-01 14:42:25 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2019-02-04
>
> for you to fetch changes up to b998fbbd531fe33d9dd50fd37056f48b4257113d:
>
>   iwlwifi: implement BISR HW workaround for 22260 devices (2019-02-04 12:28:10 +0200)
>
> ----------------------------------------------------------------
> Third batch of iwlwifi patches intended for v5.1
>
> * Work on the new debugging infrastructure continues;
> * HE radiotap;
> * Support for new FW version 44;
> * A couple of new FW API changes;
> * A bunch of fixes for static analyzer reported issues;
> * General bugfixes;
> * Other cleanups and small fixes;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
