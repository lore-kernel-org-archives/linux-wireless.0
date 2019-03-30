Return-Path: <SRS0=EA+v=SB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB60C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 06:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93850218A6
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 06:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NGsdrrLV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XGnJSl++"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfC3Gk2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 30 Mar 2019 02:40:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55426 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfC3Gk2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Mar 2019 02:40:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 462DF60850; Sat, 30 Mar 2019 06:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553928027;
        bh=TOL5fhKccn+XPU1LtJTmBIWnJK3GjRu5+m6tIv05BKU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NGsdrrLVhSy3hNToe8F7mMMxQnvXPkwE2CW5GMgfGu7t28qiKu7aU/rhn3BzifSOF
         Umxi9PxHU/46ZimzMZBhRfY0bU9F/IIfKq2zcxDLjp/1a0n/8Rrp480CNV9cqAUQaX
         Gqkdhuq9jSqWNAh2WTtfqIqOm37UcnG90dlv0Q4k=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 62E3D602BA;
        Sat, 30 Mar 2019 06:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553928026;
        bh=TOL5fhKccn+XPU1LtJTmBIWnJK3GjRu5+m6tIv05BKU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XGnJSl++up0b2FDXijCUclTDPFQPTlQqg09ZLnt/aAuH9TxwqrMn/Q0on4dGQz7cn
         q69/xipGuYmawXibvGAlZfqSAMCPgD+Ry5XXO9+QBlULXgx8wHDTudf5olauwVZUEo
         CxsxwO0Y5YjmELJTcuUCH3o4yGVR/xnPQf4sxJfI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 62E3D602BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2019-02-22
References: <8dc374567ff4a1138b5c9605ecc2dc0aeb9bc4bc.camel@coelho.fi>
Date:   Sat, 30 Mar 2019 08:40:23 +0200
In-Reply-To: <8dc374567ff4a1138b5c9605ecc2dc0aeb9bc4bc.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 22 Mar 2019 14:16:08 +0200")
Message-ID: <87bm1s3lwo.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the first batch of patches intended for v5.2.  This includes
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
> The following changes since commit 501faf710230b67e470b314868110357cf3a554d:
>
>   Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2019-02-28 11:50:40 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2019-03-22
>
> for you to fetch changes up to fe63f21b20df1adaab90c1839d36ee7c6e4b6ac0:
>
>   iwlwifi: dbg_ini: align to FW api version 1 (2019-03-22 12:59:42 +0200)
>
> ----------------------------------------------------------------
> First batch of patches intended for v5.2
>
> * Send NO_DATA events so they can be captured in radiotap;
> * Some channel-switch changes;
> * Support for multiple BSSID;
> * Continued work and bugfixes for the new debugging infra;
> * Support for some new FW API versions;
> * Some work to support new hardware;
> * General bugfixes;
> * Other cleanups;
>
> ----------------------------------------------------------------

Pulled, thanks Luca.

-- 
Kalle Valo
