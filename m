Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B9CC5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 13:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 193FA20849
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 13:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MuGdsDMH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MuGdsDMH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 193FA20849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbeLKNCt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 08:02:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40940 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbeLKNCs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 08:02:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3EF5F60C5F; Tue, 11 Dec 2018 13:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544533368;
        bh=slnAhNeN9moZY9WfdLJZxEMzZjQ9iAPgk3HOrVTFVjk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MuGdsDMH3DSrDUuWxWoovP/nk2eRHKJpJfke4mshMNzO8CYWrwUmozkAsfXlfTVq4
         JscpzqjbbS5ia9RcSMhpUupyKPMnJIzdySTU5/g5WaeCaDNAchptj1yUhzPHveqL4u
         kGi85W1mT7t6oZShOTEAz7Fnj15StbqwuG5CAReQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 02A026028B;
        Tue, 11 Dec 2018 13:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544533368;
        bh=slnAhNeN9moZY9WfdLJZxEMzZjQ9iAPgk3HOrVTFVjk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MuGdsDMH3DSrDUuWxWoovP/nk2eRHKJpJfke4mshMNzO8CYWrwUmozkAsfXlfTVq4
         JscpzqjbbS5ia9RcSMhpUupyKPMnJIzdySTU5/g5WaeCaDNAchptj1yUhzPHveqL4u
         kGi85W1mT7t6oZShOTEAz7Fnj15StbqwuG5CAReQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 02A026028B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V4 0/8] brcmfmac: chip related changes
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
        <4dca6580-8fa8-b2fb-6f65-86e8791319cf@broadcom.com>
Date:   Tue, 11 Dec 2018 15:02:44 +0200
In-Reply-To: <4dca6580-8fa8-b2fb-6f65-86e8791319cf@broadcom.com> (Arend Van
        Spriel's message of "Tue, 11 Dec 2018 13:42:47 +0100")
Message-ID: <87k1kg1aiz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 11/21/2018 8:53 AM, Chi-Hsien Lin wrote:
>> This patch series includes various chip-related changes:
>> * 43012 support
>> * 4373 saverestore support
>> * SDIO bus settings
>> * 4354 raw chipid
>
> Hi Kalle,
>
> This series [1] is still marked as New in patchwork. Are you planning
> to take them?

Yeah, along with 111 other patches ;) In other words, I'm lagging behind
in patch review but I'll try to catch up today and tomorrow. I haven't
reviewed these patchset yet, but if all goes well I'm planning to take
these.

> [1] https://patchwork.kernel.org/cover/10692067/

BTW thanks for adding the link to patchwork, very helpful.

-- 
Kalle Valo
