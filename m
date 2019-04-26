Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CE6C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 04:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B042F206C1
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 04:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o4AZHfom";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LX3DQNSr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbfDZEW0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 00:22:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51290 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZEW0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 00:22:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D2B5960213; Fri, 26 Apr 2019 04:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556252545;
        bh=wv1QMw5uOW+vh4lsVIUZfwxYEmqbr6Cwi1pImorDnwY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=o4AZHfomkiPAt7Cbc7+MFHuL6Hvd85HHmiHuBpqmI9Ne//XaqH67c0kexId6Z4zGQ
         GE8VnUrv7nHAa9W+ndjTzXTkTiemm5bIcD6HoOfvU8nTdibZl9qsdufKy/mZeO9p9e
         qwDQ5cAMmSgmK+UBbZXSwlzRaEknhmkIIj6/UWzY=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4FBFF60213;
        Fri, 26 Apr 2019 04:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556252544;
        bh=wv1QMw5uOW+vh4lsVIUZfwxYEmqbr6Cwi1pImorDnwY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LX3DQNSr08z19VuoloIgGbiM7Z64aaOIIsz8HJ6+dYY9C5qwD0ehTUpBAMnip5kt1
         CZxNhy/azAxVxcHT36k2nFuhixvCtwz87peL1nn3IXbRTtn5Gasfi6eU+xzvY2RDgk
         ivmCCiYvow66EZ2jmRArZIcOemtVPq6OQgdl0vMw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4FBFF60213
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ryder Lee <ryder.lee@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Roy Luo <royluo@google.com>,
        YF Luo <yf.luo@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mt7615: add TX/RX antenna pattern capabilities
References: <4f0780666982b3e935f46abcfe434bc68c232fb0.1556249572.git.ryder.lee@mediatek.com>
Date:   Fri, 26 Apr 2019 07:22:20 +0300
In-Reply-To: <4f0780666982b3e935f46abcfe434bc68c232fb0.1556249572.git.ryder.lee@mediatek.com>
        (Ryder Lee's message of "Fri, 26 Apr 2019 11:36:17 +0800")
Message-ID: <871s1pxuo3.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ryder Lee <ryder.lee@mediatek.com> writes:

> Announce antenna pattern cap to adapt PHY and baseband settings.
>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7615/init.c | 2 ++
>  1 file changed, 2 insertions(+)

Please add the driver name, in this case mt76, as a prefix in the title.
For example the title could be:

mt76: mt7615: add TX/RX antenna pattern capabilities
mt76: add TX/RX antenna pattern capabilities for mt7615

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
