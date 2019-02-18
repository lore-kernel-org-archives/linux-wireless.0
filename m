Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF3EC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 18:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD17217D7
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 18:25:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Jc7+M/Bq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YEP8v8kW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733082AbfBRSZt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 13:25:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55422 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731147AbfBRSZs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 13:25:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1640560779; Mon, 18 Feb 2019 18:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550514348;
        bh=lF5maKMfHoUbFjMaUgq/HOIlt27/xvZknizeK1CnfNw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Jc7+M/BqRYeJrWTfQ15EhgQaeGxhDTT9R5FO2VZ7RzoN56Iq2nk8bHOuxCBg+sZK5
         vTzLw8D20ADe9W5/bk6DlDFrmkI7oIGULlaieZF8NGiapq4+dIjSPzruXBjIzsgV4L
         ndiezL9RuIIXt/27m5Qips0XzHFL5QJT/LJvepO4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40F7C602C3;
        Mon, 18 Feb 2019 18:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550514347;
        bh=lF5maKMfHoUbFjMaUgq/HOIlt27/xvZknizeK1CnfNw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YEP8v8kWR04PATjihOqzYNXbw+EVasv/zSBT5mOOlPj73CLdL99jphgn2DwKrNxQT
         0GiTjZPJRJFAJ3xRoGt8HJk03iZrViPxHCF8o1+hNSqee59TgX98gVunE7h8mvPOq7
         /F/VI4H/6CAXlQY0CxfgZyz+Yu4xvJuYdog/BVqQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 40F7C602C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2019-02-14
References: <948cdfe88dcad399e0acb698542fb97a35609059.camel@coelho.fi>
Date:   Mon, 18 Feb 2019 20:25:44 +0200
In-Reply-To: <948cdfe88dcad399e0acb698542fb97a35609059.camel@coelho.fi> (Luca
        Coelho's message of "Thu, 14 Feb 2019 11:42:45 +0200")
Message-ID: <8736olt0lz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> This is the fourth batch of patches intended for v5.1.  This includes
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
> The following changes since commit 34025a1056a3c82b7e16992da9af54d729dd77fe:
>
>   rsi: fix indentation issue with a code block (2019-02-08 17:31:23 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2019-02-14
>
> for you to fetch changes up to 99944b73069d8bcea573c07df8dc8d4f33e78586:
>
>   iwlwifi: mvm: stop static queues correctly (2019-02-14 11:29:52 +0200)
>
> ----------------------------------------------------------------
> Fourth batch of iwlwifi patches intended for v5.1
>
> * Work on the new debugging infrastructure continues;
> * FTM (Fine Timing Measurement) initiator and responder implementation;
> * Support for a new device family started;
> * Bump supported FW API to 46;
> * General bugfixes;
> * Other cleanups;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
