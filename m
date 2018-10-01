Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4A2C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2AB4213A2
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bn8dJwTA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gN2RneJ+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2AB4213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbeJAVJw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:09:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42242 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbeJAVJw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 17:09:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0329A6024C; Mon,  1 Oct 2018 14:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538404306;
        bh=TijY3XtWVf5WkqzMHDaW/f3PqLaAHhrHCrsgagENyDM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bn8dJwTAmYe44VWpsnQxo/iLehfpEWaBF6/8iDdQg49TJ4rs6TYfkwDmjvXvQeUBr
         IHRfP1h4P33mhSFweTMIPkMaSGDAqlp8OqvBcNqoQjb+91WuNn7yaTS4IY4EfEjH5B
         D74ujY9vPF17cH+Vjds3c7qedxBTm8ewPbjjersk=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46F6A6024C;
        Mon,  1 Oct 2018 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538404305;
        bh=TijY3XtWVf5WkqzMHDaW/f3PqLaAHhrHCrsgagENyDM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gN2RneJ+m4J3q5fELkTbXB1bCfe3dZ6yV72Z24PRPqa+BUreSszS06GZYx2oCtnH/
         QSc44faFvp/f2fplyJqrsFBjFWtnDNCxqjPwqjCVejunR1O5onAeEbeRoHWT7+OZN3
         Jguxu7DmlQS+Y2lMCe4fobZbBwLhLMV/n5Mwr1lk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 46F6A6024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 5/5] ath9k: fix reporting calculated new FFT upper max
References: <20180919103711.19304-6-sw@simonwunderlich.de>
        <20181001140755.6242260128@smtp.codeaurora.org>
        <3916789.BTZ6ITeYER@prime>
Date:   Mon, 01 Oct 2018 17:31:42 +0300
In-Reply-To: <3916789.BTZ6ITeYER@prime> (Simon Wunderlich's message of "Mon,
        01 Oct 2018 16:26:50 +0200")
Message-ID: <87wor1kab5.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Simon Wunderlich <sw@simonwunderlich.de> writes:

> On Monday, October 1, 2018 2:07:55 PM CEST Kalle Valo wrote:
>> Simon Wunderlich <sw@simonwunderlich.de> wrote:
>> > Cc: Nick Kossifidis <mickflemm@gmail.com>
>> > Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
>> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>> 
>> No empty commit logs, please. But I can add that, just tell me what to add.
>
> How about:
>
> Since the debug print code is outside of the loop, it shouldn't use the loop 
> iterator anymore but instead print the found maximum index.

Perfect, thanks.

> Let me know if you need me to resend or anything else.

No need, I added this to the patch in the (not yet pushed) pending
branch.

-- 
Kalle Valo
