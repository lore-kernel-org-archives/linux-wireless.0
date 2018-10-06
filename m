Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7243CC65C30
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2276F2087D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MysH4dKW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l7R5Qipl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2276F2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbeJFTs4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 15:48:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53520 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeJFTsz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 15:48:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1D36F609F3; Sat,  6 Oct 2018 12:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538829946;
        bh=bzV1wsOqg8S2bdT5nHEWzVqvZtv5sKu7lJObzLHZXqU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MysH4dKWGS+BLpXJ63yd+OZkAoqgGi8epw+Si5dZKjsXz447eXUjgkB5EzDA/ldym
         SH2EZXHZzrcgmHHvwHkn44lmIvucHyXIu1Iw7NskbxgEhsMJSFnK2IdOMO3AsVzG1O
         jLBZ+YZfqOBPm02N1YPh0O5oxgMHVAwxPM+NgqF4=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D5376024C;
        Sat,  6 Oct 2018 12:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538829945;
        bh=bzV1wsOqg8S2bdT5nHEWzVqvZtv5sKu7lJObzLHZXqU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=l7R5Qiplf6FyKUbeZ9olp3vIr5LJ1IxlZ3S/7vUgBJKQ+MS3V+qpGBv9MKLQ2Qoy5
         0llc0VdfKYQYcet2r2bqPchYQdAp53BlxPIMt03qZlaYiITJw2gTQTOfPRduoERYWZ
         /UKeDIBXld2u2XKx25el3oJFKFRa9DcK56yXiSU4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D5376024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [RFC 00/19] wilc: added driver for wilc module
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
Date:   Sat, 06 Oct 2018 15:45:41 +0300
In-Reply-To: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
        (Ajay Singh's message of "Wed, 26 Sep 2018 15:55:06 +0530")
Message-ID: <87zhvrdz0q.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ajay Singh <ajay.kathat@microchip.com> writes:

> This patch set contains the driver files from 'driver/staging/wilc1000'.
> Renamed the driver from 'wilc1000' to 'wilc' to have generic name, as
> the same driver will be used by other wilc family members.

I'm worried that the name 'wilc' is just too generic, I liked the
original name wilc1000 much more. Quite often when we have a new
generation of wireless devices there's also a new driver, so in the long
run I'm worried that a generic name like 'wilc' could be a source of
confusion. I think it's much smaller problem if 'wilc1000' (the driver)
also supports wilc3000 (the device), people are already used to that.
And if there's ever a need for a new driver, you can call it 'wilc4000'
or whatever.

For example, I think good driver names are like 'mt76' or 'rtw88'
(currently under review).

-- 
Kalle Valo
