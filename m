Return-Path: <SRS0=EA+v=SB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A745EC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 06:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 642F7218A3
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 06:40:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XW0iPytZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MjVySjzs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfC3Ggk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 30 Mar 2019 02:36:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53160 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfC3Ggk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Mar 2019 02:36:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 580AE6087F; Sat, 30 Mar 2019 06:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553927799;
        bh=llezU4Dl75zyZRfpF8H+BjS17vo7SA0naWNF4tpPk9w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XW0iPytZmyeDQ8Iyrl2CIMg/IhvjPPIC89bTHA4MZCVIYS7ZjMsJXaasCmKLfDOWF
         EkiuHTyDndr4YtcHVzc/RhB+vIQ1so+7sP4ZIyzosPGMOjougRzyJllgfRnoJSWN6X
         oECLAyZvG2FrWXXnyU1L0CwC+gCq+IVULe0b4i6Y=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5C2F1602BA;
        Sat, 30 Mar 2019 06:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553927798;
        bh=llezU4Dl75zyZRfpF8H+BjS17vo7SA0naWNF4tpPk9w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MjVySjzsI4wAbzWf2EQcELzYeX1itBez9mO5sylqHdGEe9MibNNH1M+82/IEezzmO
         RB9n0+LyX8YskoI8X/Sd552ivXmLCGorWGeH+OtjCHUmBeYZYUCESoqdsXf892l3f5
         +nkETovYk68On1YZwPVu3H3rVZglAyQRDvrQKJ1o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5C2F1602BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-fixes 2019-03-22
References: <c1c92313e0ecec1110d60d5624e94c8d75d5e664.camel@coelho.fi>
Date:   Sat, 30 Mar 2019 08:36:35 +0200
In-Reply-To: <c1c92313e0ecec1110d60d5624e94c8d75d5e664.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 22 Mar 2019 12:58:10 +0200")
Message-ID: <87ftr43m30.fsf@kamboji.qca.qualcomm.com>
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
> This is the first batch of fixes for v5.1.  More details about the
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
> The following changes since commit 7dfc45e6282a7662279d168cc1219929456f8750:
>
>   mt76x02: do not enable RTS/CTS by default (2019-03-19 17:37:25 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2019-03-22
>
> for you to fetch changes up to 972d8e1377795556024e948357e82532890f2f7d:
>
>   iwlwifi: add new 0x2723/0x2080 card for 22000 (2019-03-22 12:49:05 +0200)
>
> ----------------------------------------------------------------
> First batch of iwlwifi fixes intended for v5.1
>
> * add some new PCI IDs (plus a struct name change they depend on);
> * fix crypto with new devices, namely 22560 and above;
> * a bunch of fixes (and a dependency) for the new debugging infra;
>
> ----------------------------------------------------------------

Pulled, thanks Luca.

-- 
Kalle Valo
