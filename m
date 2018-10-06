Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F109C64EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 09:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C28DB20875
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 09:53:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EDaSPcXC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UX4CQlwp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C28DB20875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbeJFQzs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 12:55:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49760 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbeJFQzr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 12:55:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1D32560C4E; Sat,  6 Oct 2018 09:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538819590;
        bh=pjqaJjqBANCjdZuJcXb0NG1HkaIoE2Jte1uMMbSZWJk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EDaSPcXC3g7rpIZcklmpqSjYmIEkbbWrcM02CrkJYazWAs6Ni8gcf4AFrdAB1yC94
         HHcxPBq8KqvTsMGjZZNi8WoYrLGT4wTGyS0bJgB1KFCQFWa3YFiNf4jByBQvl63+K5
         FuyoIdm8I2pELkmTHL1RSqM6r3ovmle7z84EkzDU=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 06BCB60818;
        Sat,  6 Oct 2018 09:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538819589;
        bh=pjqaJjqBANCjdZuJcXb0NG1HkaIoE2Jte1uMMbSZWJk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UX4CQlwpiIRZugj8oepXf3TJcxy+SQ+0m+6Uquv6O0JQ6QBpblIao6jDTZBn6ndSu
         5KfoT8gArXcXslR/ZtQN/wA6QqMR4VkNUTt51dGg+OJ35a9nAx4moDn9wXkZeUXKuh
         LoLk553XqGFEezYFD2I+3UsVizR2ROVwercu6kJA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 06BCB60818
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-10-06
References: <f5d3582e83112e6fb0c3b5aa1a0cb136bcc12c1e.camel@coelho.fi>
Date:   Sat, 06 Oct 2018 12:53:05 +0300
In-Reply-To: <f5d3582e83112e6fb0c3b5aa1a0cb136bcc12c1e.camel@coelho.fi> (Luca
        Coelho's message of "Sat, 06 Oct 2018 10:29:33 +0300")
Message-ID: <87o9c7h05a.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the third batch of patches intended for v4.20.  This includes
> the last 2 patchsets I sent.  Usual development work, including some
> improvements in the HE radiotap stuff, a new FW version support and
> other small improvements and fixes.  More details about the contents in
> the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit e1c02eb16a9c742178874a7d1a08d300981715fb:
>
>   qtnfmac: implement dump_station support for STA mode (2018-10-05 14:01:44 +0300)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-10-06
>
> for you to fetch changes up to ea7cb8293874f8d9cf36c9e5387e2247f15373dc:
>
>   iwlwifi: dbg: make trigger functions type agnostic (2018-10-06 10:25:55 +0300)
>
> ----------------------------------------------------------------
> Third set of iwlwifi patches for 4.20
>
> * Fix for a race condition that caused the FW to crash;
> * HE radiotap cleanup and improvements;
> * Reorder channel optimization for scans;
> * Bumped the FW API version supported after the last API change for
>   this release;
> * Debugging improvements;
> * A few bug fixes;
> * Some cleanups in preparation for a new implementation;
> * Other small improvements, cleanups and fixes.
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
