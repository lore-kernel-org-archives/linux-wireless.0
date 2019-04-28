Return-Path: <SRS0=6X5c=S6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA52C43218
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 11:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6C802075D
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 11:27:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CQpwECkq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TNpkfDi3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfD1L1p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Apr 2019 07:27:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37944 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfD1L1o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Apr 2019 07:27:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5D8C76079C; Sun, 28 Apr 2019 11:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556450864;
        bh=JzSeRbP0oC4DfbjwVBWUso+WAqrdFbduxdt0hHB/ubw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CQpwECkqP9jTiJQ3WwVkp9jcD7DSbxzI9zEYpw85abXbMd1lFFcCslPvhIbIhq+zK
         AHjBZSjO3wbvY5u/6XA5Irdui+5NRITRcwXqFU7lz7XTNTPVV//ZarudxiYfIfsoxw
         YP2jsdFcjRJ4QoqXgXGzk7Y1OyJAj0/q4405olmM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 95DD260364;
        Sun, 28 Apr 2019 11:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556450862;
        bh=JzSeRbP0oC4DfbjwVBWUso+WAqrdFbduxdt0hHB/ubw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TNpkfDi3ZBTYfA8GqcXHhWBg0Ohsqp58QNtO0KO/e+LApSnbRGnw0ky6PgvMZa5ir
         kB0hkx1+2HSd54F3leMnFoKV9LgHYzlOZtcjTsGjLI/Sc92FhOF312w9wFmvlMGUy5
         XE2RiWr7vWYrHTeY28Cg3YeCI4uI8UnPI9CjLhog=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 95DD260364
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-fixes 2019-04-28
References: <aab3d1cab0caf00d7c3ae1cc10ca3ec99cc54efd.camel@coelho.fi>
Date:   Sun, 28 Apr 2019 14:27:39 +0300
In-Reply-To: <aab3d1cab0caf00d7c3ae1cc10ca3ec99cc54efd.camel@coelho.fi> (Luca
        Coelho's message of "Sun, 28 Apr 2019 10:06:50 +0300")
Message-ID: <87mukas72s.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the fourth batch of fixes for v5.1.  It contains two fixes I
> send in the last patchset plus a patch that I sent separately to fix a
> merge damage caused by the previous pull.  More details about the
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
> The following changes since commit b82d6c1f8f8288f744a9dcc16cd3085d535decca:
>
>   mwifiex: Make resume actually do something useful again on SDIO cards (2019-04-25 14:05:14 +0300)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2019-04-28
>
> for you to fetch changes up to d156e67d3f58c5d3c7ebe1bec80657db534f32d4:
>
>   iwlwifi: mvm: fix merge damage in iwl_mvm_vif_dbgfs_register() (2019-04-28 09:59:59 +0300)
>
> ----------------------------------------------------------------
> Fourth batch of patches intended for v5.1
>
> * Fix an oops when we receive a packet with bogus lengths;
> * Fix a bug that prevented 5350 devices from working;
> * Fix a small merge damage from the previous series;
>
> ----------------------------------------------------------------

Pulled, thanks Luca.

-- 
Kalle Valo
