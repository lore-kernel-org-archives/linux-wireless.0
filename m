Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0DCC10F01
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 13:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C882321905
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 13:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="m3VY026X";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OYFj7eHP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbfBRNsa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 08:48:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44350 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731382AbfBRNs3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 08:48:29 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 16F826077A; Mon, 18 Feb 2019 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550497708;
        bh=47YnBYGkL+BzbIVA6zki0kv8qjhvCHcWSuH5Kur215A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=m3VY026XdQPy2vH5B/yqudFkk3vRss8jyrNlD5HHobmK48mmvg39VEXRpLGdMo3Qc
         OM8lM/noSqhGyHXbmymr8G+P5qoHCUinTXAUcqteZ9PZmwY7K3QKhc2PqZcXYiquMW
         W7K/zIoD8pdhxJUwyITT3KyNubQn5Zs0J1eva8TQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9099E60769;
        Mon, 18 Feb 2019 13:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550497707;
        bh=47YnBYGkL+BzbIVA6zki0kv8qjhvCHcWSuH5Kur215A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OYFj7eHP54OmXsvwbfZzmDDLELbGghcunA6ZPGVkRYYPyHXW8l39udHP+Dmiz23Jz
         47+2knZk5UndzqFpEEHaukIClvByqDxcrnxXvSwZqjDww3KdvKM1n7IkCS0hCqs0rP
         T0PUnAG1zppHOP0C+2NgGut7+hLY9R4kdh6FmrHc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9099E60769
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     maowenan <maowenan@huawei.com>
Cc:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] cfg80211: pmsr: use eth_broadcast_addr() to assign broadcast address
References: <20190216094710.127182-1-maowenan@huawei.com>
        <927ff17c-c506-734f-fc27-796d4c8fba98@huawei.com>
Date:   Mon, 18 Feb 2019 15:48:22 +0200
In-Reply-To: <927ff17c-c506-734f-fc27-796d4c8fba98@huawei.com>
        (maowenan@huawei.com's message of "Mon, 18 Feb 2019 21:25:06 +0800")
Message-ID: <878sydus0p.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

maowenan <maowenan@huawei.com> writes:

> Add kalle Valo in mail list.
>
> Hi Kalle Valo,
> Do you have any comments about this patch?

Why do you ask me? Johannes maintains cfg80211, not me, and he will
provide comments once he reviews the patch (which might take some time,
we do have other tasks as well).

-- 
Kalle Valo
