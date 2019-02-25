Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E40C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 671592087C
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:15:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MMwkBi99";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Bv1xhCmP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfBYKPs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 05:15:48 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60778 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfBYKPs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 05:15:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6873460A43; Mon, 25 Feb 2019 10:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551089747;
        bh=9R+y37WsJIEMvqaK2psU+0P+b+vC4FaXG+zGDnKeHro=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MMwkBi99WJXZiLPSqbQjnbo2lKaoSecSklPzx7GNOsUAA5awchjvF6hTJPD6bouts
         8cuaFFW1sJTUF4FuhTurVm6Zet+WHmgZOnTKaOc41gDsLodR9iXCIpoXQ2/VcZ7R1X
         qPawCHVQhBidbbs7A5TggHacv3SE7bGP2wTvdAiE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF120609EF;
        Mon, 25 Feb 2019 10:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551089746;
        bh=9R+y37WsJIEMvqaK2psU+0P+b+vC4FaXG+zGDnKeHro=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Bv1xhCmPGAxIFEkW7KbwMC+XAgdzqRJ4Wlo0RggCxa+YwCjINdlX6UpmN4AFIg6JE
         i9iEmu/gzFxeHW2qaTw/LmT9Ic4l8vK+y7/lhShujYO3LRfaQ9oA30F+/W67Zm3sLh
         rbZnl+2bZXhQCqH51+fIcXec5DRnyVetP5IWShVA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EF120609EF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add peer param map for tlv and non-tlv
References: <1550556576-19803-1-git-send-email-pillair@codeaurora.org>
Date:   Mon, 25 Feb 2019 12:15:43 +0200
In-Reply-To: <1550556576-19803-1-git-send-email-pillair@codeaurora.org>
        (Rakesh Pillai's message of "Tue, 19 Feb 2019 11:39:36 +0530")
Message-ID: <87bm30mawg.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> writes:

> The peer param id for PEER_PARAM_USE_FIXED_PWR
> is different for tlv and non-tlv firmware. This
> causes incorrect peer param to be set by the driver
> to the firmware(tlv/non-tlv).
>
> Create seperate peer param map for tlv and non-tlv
> firmware and attach the peer param id based on the
> firmware type during the init.
>
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> ---
> This change is dependent on the below patchset
> ath10k: add support for controlling tx power to a station (https://patchwork.kernel.org/patch/9562405/)

You got me really confused, that patch is two years old :) But I think
you mean this v3 patch (oddly the one submitted in 2017 was also v3?):

[v3,3/3] ath10k: add support for controlling tx power to a station

https://patchwork.kernel.org/patch/10825293/

-- 
Kalle Valo
