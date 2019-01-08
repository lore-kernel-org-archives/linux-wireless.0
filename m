Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53080C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 245D42070B
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RBbHMIT/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YSCIKxxe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfAHRPa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:15:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727764AbfAHRPa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 12:15:30 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4E7F460112; Tue,  8 Jan 2019 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546967729;
        bh=/f9n2bRocW3HbBkVErz4F8KKDog2zJeS7PG9BzAA4SQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RBbHMIT/3ML9qL0lpvBxNfYT9UrvHfBXOwDbxMLRAg0M7HLR4NcU6C3wHZ+r1QvtV
         Xs0AUVqQzdVm/EXQBYoN4Hp0KUkCCfmuXrSNdQIt9zhsr2CExQ7oGYbrd0q1PNrwdz
         bSmyj7e6yE0HKi7adlGWG5AZiVsa68eCMQPUIzkA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C986160112;
        Tue,  8 Jan 2019 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546967728;
        bh=/f9n2bRocW3HbBkVErz4F8KKDog2zJeS7PG9BzAA4SQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YSCIKxxeC/6s+tIJXc8ta7fJpbYm36nDb+xkenoJpyEfwIyqcwRPm6fHOh93ulpbs
         ufSAM8emj3JvAKFVhSzp8WWQ0/x/D1xB2KiqUWfP0F723efSE7ogt4+Oij8ernaeqE
         ZBDETENrNA/rP/a1OV4mGiZf7YKXtpa1rqLaaCWE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C986160112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Rakesh Parmar <rakeshp@marvell.com>, James Cao <jcao@marvell.com>,
        linux-wireless@vger.kernel.org
Subject: Re: Not able to see patches in patchwork
References: <CY4PR18MB12372AF071013F01A0DE6A32A08A0@CY4PR18MB1237.namprd18.prod.outlook.com>
Date:   Tue, 08 Jan 2019 19:15:25 +0200
In-Reply-To: <CY4PR18MB12372AF071013F01A0DE6A32A08A0@CY4PR18MB1237.namprd18.prod.outlook.com>
        (Ganapathi Bhat's message of "Tue, 8 Jan 2019 09:50:54 +0000")
Message-ID: <87ef9nqdea.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless

Hi Ganapathi,

please do not email me privately. If you have questions send them to the
list, you get answers faster and I get less email :)

Ganapathi Bhat <gbhat@marvell.com> writes:

> I am not able to see the patch sent to
> 'linux-wireless.vger.kernel.org', in
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> Let me know if you received my patch, named "mwifiex: add support for
> sd8977 chipset"

When did you submit it? I don't see such email on linux-wireless list. I
recommend resubmitting the patch as v2.

-- 
Kalle Valo
