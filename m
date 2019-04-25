Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F9AC43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 15:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F277E206C0
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 15:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EgFRhieR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n9SnDQSj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfDYP3X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:29:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37922 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729077AbfDYP3X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 11:29:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 746936049C; Thu, 25 Apr 2019 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556206162;
        bh=KqSOIhDtoGs/0Pi7hKq6nV2HSVOHJO+oGHmCt1KPmRI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EgFRhieReSz+VZI6xdQsi1U2Elmn78zv+QarqZE+yBIAIjFl6D7pckoXR+nah2RDD
         TrZ9jTkpOLuOZblraB96pkb4b841dn89wT8GZadk67QW7+trGgB8EBf65XtEoPSuB3
         lV92eF+mtDViHZkUWyBIRZdxx4vAH/NQpY4xhe9A=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8DFD860213;
        Thu, 25 Apr 2019 15:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556206161;
        bh=KqSOIhDtoGs/0Pi7hKq6nV2HSVOHJO+oGHmCt1KPmRI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=n9SnDQSjd2NxmH6vyNHH+h+RcCO7Q1AGoIH98KN1s8cGCKFg3THf2ymhwVyyki/Zs
         Lz0k0XOhYsApxLEKzgghFiiQdQJfkTT2+Vo8esIIF+MCBgOLv2exnWHFoqr3IJBYDC
         KJrAJmO2XGq9nLMMP5FWaQB4NFHMGVy/FoN0geGo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8DFD860213
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2019-04-18-2
References: <53070f180e2ae093d0daccc664b09837beb8b549.camel@coelho.fi>
        <560ba2b6a20ac9842fd6a5a5d786def1077811f4.camel@coelho.fi>
Date:   Thu, 25 Apr 2019 18:29:18 +0300
In-Reply-To: <560ba2b6a20ac9842fd6a5a5d786def1077811f4.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 19 Apr 2019 10:37:18 +0300")
Message-ID: <87ef5qw1bl.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is a new version of my pull request on top of your tree after you
> fast-forwarded to net-next, to avoid a small conflict.
>
> This is the third batch of patches intended for v5.2.  This includes
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
> The following changes since commit 5c2e6e14a0ad24a35d9d2b318204c8c012d9d618:
>
>   Merge branch 'net-add-reset-controller-driven-PHY-reset' (2019-04-18 17:43:11 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2019-04-18-2
>
> for you to fetch changes up to 69166f7a37dc0bde5a3c26945e3cdbfc740b0562:
>
>   iwlwifi: dbg_ini: set dump bit only when trigger collection is certain (2019-04-19 10:27:34 +0300)
>
> ----------------------------------------------------------------
> Third batch of patches intended for v5.2
>
> * Bump the 20000-series FW API version supported;
> * Work on the new debugging infra continues;
> * One clean-up to prevent a bogus warning with clang;
> * A small cleanup in the PCI ID list;
> * Work on new hardware continues;
> * RTT confidence indication support for FTM;
> * An improvement in HE rate-scaling;
>
> ----------------------------------------------------------------

Pulled, thanks Luca.

-- 
Kalle Valo
