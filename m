Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354DEC04EBC
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 13:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8074A206BB
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 13:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="f4zpDz2y";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="izJzBMED"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8074A206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbeKTXv5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 18:51:57 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34104 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbeKTXv5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 18:51:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9C95660B13; Tue, 20 Nov 2018 13:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542720170;
        bh=MKpuK3NpSbH2OhF67xWi5Tm6JcHg/NSEphXIahQ0j8E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=f4zpDz2y/0ttz5gRjCFtjIlmT6Mnj9wpdQKb7ve4uoS77ZbEoAPvN2NlNbXpI9vB2
         b65gS+wu9EU9OlovT4a3tgoNHoH1ER67y9e1quYpljsm04J2IPmqXjDZ6JuXAdoJb6
         azvwMaO+mpATHotx4gbegTYeJhrh7eNODrHdnWFk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8E8786071B;
        Tue, 20 Nov 2018 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542720169;
        bh=MKpuK3NpSbH2OhF67xWi5Tm6JcHg/NSEphXIahQ0j8E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=izJzBMEDbSAqj3EKdAdoRPJ4/yLOZglnX+95BdH2yIWLHkOe8OUsbpN3Ty0ggeS/f
         EA6gY0wPlpK8jp8UQQlhAvwKxhTOm5dy9A4/aGZk5ISeCjpYHaPQ0I2wMH5awvbgnB
         W0PZlF05j3Nu2jLu6RXon5sBr5DdGqRoZs6k/A/8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8E8786071B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Priit Laes <plaes@plaes.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/4] wireless: Use common cordic algorithm for b43 driver
References: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
        <20181119181016.4fxuszvvyiokuqvl@plaes.org>
Date:   Tue, 20 Nov 2018 15:22:44 +0200
In-Reply-To: <20181119181016.4fxuszvvyiokuqvl@plaes.org> (Priit Laes's message
        of "Mon, 19 Nov 2018 18:10:16 +0000")
Message-ID: <871s7fdgt7.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Priit Laes <plaes@plaes.org> writes:

> On Mon, Nov 19, 2018 at 08:01:21PM +0200, Priit Laes wrote:
>> b43 wireless driver includes an internal implementation of
>> cordic algorithm, although there's a common cordic library
>> which was split out from brcmsmac driver. Use that and drop
>> internal implementation.
>> 
>> During the process, cordic-algorithm related macros in
>> brcmfmac driver were also removed and use general macros.
>> 
>> Please note that this series is only compile-tested, as I
>> do not have access to the hardware.
>
>
> Gah.. I missed the series version in subject. Shall I resend?

No need, I'll remember now that this is v4.

-- 
Kalle Valo
