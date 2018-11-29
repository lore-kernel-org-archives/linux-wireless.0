Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1D8C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 09:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA9C620834
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 09:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="flaQGKiX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FJsHZEoX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA9C620834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbeK2U6E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 15:58:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35266 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbeK2U6E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 15:58:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1630560B62; Thu, 29 Nov 2018 09:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543485198;
        bh=F2KlkB3kpp4HkuesVS8env8cvfYVJ3hEepu3pP+oEQQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=flaQGKiX7d4TOSzlc2t/pzHN1y+4qbTLnGM25VAhDz0/ixelWlkHdWEKfoG4wxIcW
         UEC6I04UnJdAWcIgaF255SamEzz/q09S42jWPv8QqhuEJiCYZfMT8M+2hkw2teaeeq
         F8Zvkoih+okChW7y9+RRA/rxCSdmrWcEwi0QHPOo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 29A6E60350;
        Thu, 29 Nov 2018 09:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543485197;
        bh=F2KlkB3kpp4HkuesVS8env8cvfYVJ3hEepu3pP+oEQQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FJsHZEoX2n8Q1gSEFZiP0x5MoSUv/hYEC1J6cGscFWFguVtUrzyj1kG6xOSWMz5Xc
         lgbwZtsnV9Edti1ICutHkxAdO91xl41ptGGXKSkqyyjmiBgckNzPglFFULDn1kfCqU
         CMeUy+OPbfhQEhMczJmWIQM5Ti1DrtAT1DQ69F34=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 29A6E60350
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-11-23
References: <f7e2243ec8a8bcc65ee44146d7486b8f7586eea1.camel@coelho.fi>
Date:   Thu, 29 Nov 2018 11:53:14 +0200
In-Reply-To: <f7e2243ec8a8bcc65ee44146d7486b8f7586eea1.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 23 Nov 2018 13:19:18 +0200")
Message-ID: <878t1c6whh.fsf@kamboji.qca.qualcomm.com>
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
> This is the second batch of patches intended for v4.21.  This includes
> only the last patchset I sent.  Usual development work, mostly in the
> debugging infrastructure and small fixes and cleanups.  More details
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
> The following changes since commit 12d56175c89c8a8cc41e478775155709274ff733:
>
>   Merge tag 'iwlwifi-next-for-kalle-2018-11-11' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2018-11-15 16:59:01 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-11-23
>
> for you to fetch changes up to 520229e4b02dc4f5241a251a569fe0691a2c2e2c:
>
>   iwlwifi: mvm: set HW capability VHT_EXT_NSS_BW (2018-11-23 13:01:08 +0200)
>
> ----------------------------------------------------------------
> second batch of iwlwifi patches intended for v4.21
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
