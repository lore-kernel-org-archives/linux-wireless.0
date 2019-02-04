Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5673DC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 13:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EFD42077B
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 13:38:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ggaVAosk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SoBN6XnO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbfBDNiv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 08:38:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34582 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbfBDNiu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 08:38:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 37321607F5; Mon,  4 Feb 2019 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549287530;
        bh=RiXFp+ASDf6Ibzs46EmLQfAtvMwHQXpGlZS7VYqoh5Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ggaVAosk2SAcBnZaMj3zlGD8eSLPz100iPRwQT5mJNlULWvv+Arcl7q2X5y6YhUt8
         P4DOq5mw6wZR1q5mUeGlPjd0vE9uiVjWNeAQ92o07K7gQgVw8RifKfrOAapGebh+5P
         sr79XtBLumKb0Gz+yXjYSnCLsbeQ85hkdhzY2rmk=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E6520606AC;
        Mon,  4 Feb 2019 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549287529;
        bh=RiXFp+ASDf6Ibzs46EmLQfAtvMwHQXpGlZS7VYqoh5Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SoBN6XnOjttqRHlhqFAepxZaBw/ns/haOuRX+tTbbJ2+g1730RWIx7GW5FKcEqfCW
         cEbbUU7irQFWKTlECAgWjm2uq23oXDup8jqOlTgKeF3cHyqROwz3lTge/tHW4AYFhS
         mmE/yW8TG4yWoYY/KdknSFkfGZqyQ264e2U50aCE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E6520606AC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <Adham.Abozaeid@microchip.com>,
        <johannes@sipsolutions.net>
Subject: Re: [PATCH 01/15] staging: wilc1000: avoid the use of 'wilc_wfi_mon' static variable
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
        <1549134974-5545-2-git-send-email-ajay.kathat@microchip.com>
Date:   Mon, 04 Feb 2019 15:38:46 +0200
In-Reply-To: <1549134974-5545-2-git-send-email-ajay.kathat@microchip.com>
        (Ajay Kathat's message of "Sat, 2 Feb 2019 19:16:53 +0000")
Message-ID: <87lg2vsmft.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Ajay.Kathat@microchip.com> writes:

> From: Ajay Singh <ajay.kathat@microchip.com>
>
> Avoid use of static variable for monitor net_device and move it inside
> wilc structure.
>
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>

[...]

> --- a/drivers/staging/wilc1000/linux_mon.c
> +++ b/drivers/staging/wilc1000/linux_mon.c
> @@ -18,8 +18,6 @@ struct wilc_wfi_radiotap_cb_hdr {
>  	u16 tx_flags;
>  } __packed;
>  
> -static struct net_device *wilc_wfi_mon; /* global monitor netdev */
> -
>  static u8 srcadd[6];
>  static u8 bssid[6];

I hope you are working on moving srcadd and bssid as well (at some
point).

-- 
Kalle Valo
