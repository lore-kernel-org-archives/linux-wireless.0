Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27892C67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFD232086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:54:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QD6S4cV7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bvlOos/D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFD232086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbeLMOyI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:54:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41914 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbeLMOyH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:54:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1DF896071A; Thu, 13 Dec 2018 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544712847;
        bh=pYCs7/tGTTcO5Tah/UCFL3QvGTgo98FZiu+6gLdQ2TM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QD6S4cV78owa4wsOkhK9+SenXwx7PoLMz1WGxvdvOMmCHLxDU1Ra6CDBJmkJ+tmur
         hfw11qSQaOXEPcdE5fJZZLXBkB614m6NFwc6Gr+ratozsuVQwTzTesm1zkCsFlXMU6
         NzEpWzA6OVV2UV2D+0yF8p1gRYYn/RAWGUh5pqi0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 239CC601C3;
        Thu, 13 Dec 2018 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544712846;
        bh=pYCs7/tGTTcO5Tah/UCFL3QvGTgo98FZiu+6gLdQ2TM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=bvlOos/D+AsHe9JLe9jgUGxf144Gl7CLBsmRT2SbyfBWGuI9wS6rcqw16hHg1wwua
         HQFaGNfXj5jPluvuAophNqWsBcximDNct49VZzn/DppXPSlLU/2aJqpU7W/cVal/vV
         u0HNqNAHIN2lQXmmnf4yYcZhM2w+YKNh5dl5OSP8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 239CC601C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: fix potential NULL dereference and use after free
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1543487119-92033-1-git-send-email-bianpan2016@163.com>
References: <1543487119-92033-1-git-send-email-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213145407.1DF896071A@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 14:54:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pan Bian <bianpan2016@163.com> wrote:

> There are two defects: (1) passing a NULL bss to
> mwifiex_save_hidden_ssid_channels will result in NULL dereference,
> (2) using bss after dropping the reference to it via cfg80211_put_bss.
> To fix them, the patch moves the buggy code to the branch that bss is
> not NULL and puts it before cfg80211_put_bss.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Patch applied to wireless-drivers-next.git, thanks.

1dcd9429212b mwifiex: fix potential NULL dereference and use after free

-- 
https://patchwork.kernel.org/patch/10704311/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

