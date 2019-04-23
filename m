Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB4AC282E1
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 05:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE8DD20B1F
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 05:41:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nH/G33bc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="f6Ivt9g8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfDWFly (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 01:41:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46978 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfDWFly (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 01:41:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0C7956122D; Tue, 23 Apr 2019 05:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555998113;
        bh=xc6SA98y786i+LUXpnqWPJw4OJpFrUmdxkaO6GuzA4I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nH/G33bcAwJTk/tTJe/WAMPs+yygTo5jx/i1hQHSmSUhhafzTqrlYheOA7oekHI0i
         jmaCIsNVOVE+f8ZxSUqJDZ7dA0UITqPW7SyjeALk50lKVN9qaTP54BiUpCy+REOuYb
         NhrhqdGQdv1Df2/x0NqrO8hQQJWMOStwXXc7CtLI=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A9EB16118F;
        Tue, 23 Apr 2019 05:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555998112;
        bh=xc6SA98y786i+LUXpnqWPJw4OJpFrUmdxkaO6GuzA4I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=f6Ivt9g8MRnEB2CEIEv3yolryeEfyCHNeyDMuZlND2abSiJAxvmVw7SsmHzN0bELv
         WIpJgU1hGSszfEfr4wLGDM3VccGGJ8B5rTi/W3bShpgnpk6Kj8D/3GZH76q3Iqj1m6
         +c2jF0XbT/MpSL4ZREddaXZnlBK40pUnkyuxZLbo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A9EB16118F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        <linux-next@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [linux-next] rtlwifi commit contains a patch reject file
References: <20190420155008.GM23044@windriver.com>
Date:   Tue, 23 Apr 2019 08:41:48 +0300
In-Reply-To: <20190420155008.GM23044@windriver.com> (Paul Gortmaker's message
        of "Sat, 20 Apr 2019 11:50:09 -0400")
Message-ID: <87a7ghxopv.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> writes:

> I'm kind of surprised sfr doesn't have a bot to complain when it sees
> a foo.c.rej or foo.c.orig in a commit...
>
> Paul.
> ---
>
> $ git show --stat ddab2eee794
> commit ddab2eee7949f94b8ecdc5c84ae238826142d35d
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Thu Apr 4 13:29:31 2019 -0500
>
>     rtlwifi: Convert the wake_match variable to local
>     
>     In five of the drivers, the contents of bits 29-31 of one of the RX
>     descriptors is used to set bits in a variable that is used to save the
>     wakeup condition for output in a debugging statement. The resulting
>     variable is not used anywhere else even though it is stored in a struct
>     and could be available in other routines. This variable is changed to be
>     local.
>     
>     Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>     Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c     | 15 ++++++++-------
>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej | 10 ++++++++++

Thanks for the report, the issue was fixed by this:

b5250c9c14c1 rtlwifi: rtl8188ee: Remove extraneous file

-- 
Kalle Valo
