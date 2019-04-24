Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44ADC282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 15:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74215218FC
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 15:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hNQTG2y2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PKYFPLbl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbfDXPRg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 11:17:36 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46978 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfDXPRg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 11:17:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AA3766055C; Wed, 24 Apr 2019 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556119055;
        bh=o6lJxOJUK21xd5wRMaWZZl11RC+WkjZFuRFhYHpAtnI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hNQTG2y2jVq8sGMtiYdWAtK+bThCPJld190z2kmNIyKb1GsneyeuEYgUJi73yhX9f
         J1JWhpdQ7GPHltUeMPYblMrPDoQqGW42taI2LCp6xhcFxMN9km1UkpzolSL9kY8DtV
         Akn2NlkR29xDFlXgFZ61blw4HtyFz6QmAN684m48=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ED2B8604B4;
        Wed, 24 Apr 2019 15:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556119054;
        bh=o6lJxOJUK21xd5wRMaWZZl11RC+WkjZFuRFhYHpAtnI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PKYFPLblqDFaCbEf9yQjVscbOhNsADHUUhYj1MePiVSAlkcmWUxp+W0pSXMaj6b61
         k9JMcvrzrMKDor9S0INmb8u+wPTyCQqaSMJSMcJmhL+uxnuo1P8ehpq6bt43ybjZem
         VyzFRZ4oB5t8Bb74WQgZogXLewy9RQVnsvoNRuV0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ED2B8604B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-fixes 2019-04-19
References: <31cd1d98775748ed92c32dc6d298f1b2c5dc5e16.camel@coelho.fi>
Date:   Wed, 24 Apr 2019 18:17:30 +0300
In-Reply-To: <31cd1d98775748ed92c32dc6d298f1b2c5dc5e16.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 19 Apr 2019 09:19:55 +0300")
Message-ID: <874l6nxwj9.fsf@kamboji.qca.qualcomm.com>
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
> This is the third batch of fixes for v5.1.  More details about the
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
> The following changes since commit 614c70f35cd77a9af8e2ca841dcdb121cec3068f:
>
>   bnx2x: fix spelling mistake "dicline" -> "decline" (2019-04-15 17:23:09 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2019-04-19
>
> for you to fetch changes up to c537e07b000bc00c9a5ac9d119ed2c8456a99b6e:
>
>   iwlwifi: cfg: use family 22560 based_params for AX210 family (2019-04-18 15:06:44 +0300)
>
> ----------------------------------------------------------------
> Third batch of iwlwifi fixes intended for v5.1
>
> * Fix an oops when creating debugfs entries;
> * Fix bug when trying to capture debugging info while in rfkill;
> * Prevent potential uninitialized memory dumps into debugging logs;
> * Fix some initialization parameters for AX210 devices;
> * Fix an oops with non-MSIX devices;
>
> ----------------------------------------------------------------

Pulled, thanks Luca.

-- 
Kalle Valo
