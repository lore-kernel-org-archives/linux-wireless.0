Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BB6C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF46721773
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="H9QP3Rzc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EVnX6FV3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbeLTQks (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 11:40:48 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730125AbeLTQks (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 11:40:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 29B806053B; Thu, 20 Dec 2018 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545324048;
        bh=wuFZKRnANEPgMpq04gw+6tYix3/ni4xrhcjtCumJkY4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=H9QP3RzcHrDO910IxjRwBrcPDqU3pah8x6PTLrwZpRnfXSHOvWbef90YQ3dMBsGJ3
         qljIEw427znvOM3HN3kU+qg6lsLtsBXOVy+1DjzDJ+ZoUrxoni/OPZddA9jn7+TZFb
         C5IoSm1V3yQUjOuz15umuelKLE9rvFQiLEwbwJMM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC9F960208;
        Thu, 20 Dec 2018 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545324047;
        bh=wuFZKRnANEPgMpq04gw+6tYix3/ni4xrhcjtCumJkY4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EVnX6FV3kVfaq2zjUuPa0Gc6ZVDWh6keNdMmbOmBrKRh76ip84VpthFT5fXVnXJIF
         ykEfN65hqDIs5EK7IoAcrXolMIUHKDC0nEZ2dWvTyfxC8quwwa0vSgKG0Kv2MNNvhm
         8KsniFxDBpMNug9GP24+VeDi3cox9p+qwtSFBdT8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BC9F960208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     govinds@codeaurora.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Move non-fatal warn logs to dbg level
References: <20181129042522.11767-1-govinds@codeaurora.org>
        <CA+ASDXMOqzXk9HrX9AS58cUfKOHeXA7zN_ME3+zDZXQcok_0Tg@mail.gmail.com>
Date:   Thu, 20 Dec 2018 18:40:43 +0200
In-Reply-To: <CA+ASDXMOqzXk9HrX9AS58cUfKOHeXA7zN_ME3+zDZXQcok_0Tg@mail.gmail.com>
        (Brian Norris's message of "Fri, 30 Nov 2018 12:59:49 -0800")
Message-ID: <87h8f8talw.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Wed, Nov 28, 2018 at 8:25 PM Govind Singh <govinds@codeaurora.org> wrote:
>>
>> During driver load below warn logs are printed in the console.
>> Since driver may not implement all wmi events sent by fw and
>> all of them are non-fatal, move this log to debug level to
>> remove un-necessary warn message on console.
>>
>> [  361.887230] ath10k_snoc a000000.wifi: Unknown eventid: 16393
>> [  361.907037] ath10k_snoc a000000.wifi: Unknown eventid: 237569
>>
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>
> Alternatively, you could add these ignored commands to wmi-tlv.h, and
> just ignore them specifically. That's better documentation, in case
> new WMI events come along that *are* important to notice when we
> ignore them. There are other recent examples of that sort of patch
> being merged.

I have actually tried to do that (what Brian describes above) during the
last years but the problem is that there are just so many different
firmware branches that it's difficult to keep up in ath10k. So in the
end these warnings just confused the users and they mistakenly thought
this warning message is the cause of their problems. That's why I think
it's best to remove this warning.

-- 
Kalle Valo
