Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A54C282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D99420844
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MleiQr9I";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KTZWDahQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfAUHsE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:48:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbfAUHsE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:48:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 154586024C; Mon, 21 Jan 2019 05:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548047967;
        bh=6VI+ti815jdOI2XxdGma92qGWr8PQcwkeTX3Y17VyRY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MleiQr9I8S9Zy1H7dnvrOpjaPN7Y3uL4uXf8KoJyR2lcLOFxcFm+ZnOneYCaWeKIH
         N73evEWQVHJ+UShpSoJ3V6MD2PfSLuzzMIkEx1pmiIb/eU9iMTaGw0hvmydgJ7ZmgJ
         K6F+UV2hImcC6o4yqWlIjrTAAKBSRBzunT8YfY3o=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A87816028D;
        Mon, 21 Jan 2019 05:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548047966;
        bh=6VI+ti815jdOI2XxdGma92qGWr8PQcwkeTX3Y17VyRY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KTZWDahQetg05IjvggRq3cF4sShi9xLeZs/BIGOjxOj99v/axnxBwymLaySSUU/vC
         u4qncY4n3E9MZMG4ZMRIDj7XFEkPJQnOX35STbSgM+Awk/MDSDoWlRuVFLtrqJtuHA
         tdyq+2+0XQDFpSM/lNftE108IgJQTh58kVRTtqkc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A87816028D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next] wireless: fix typos
References: <20190120232000.4940-1-mcroce@redhat.com>
Date:   Mon, 21 Jan 2019 07:19:21 +0200
In-Reply-To: <20190120232000.4940-1-mcroce@redhat.com> (Matteo Croce's message
        of "Mon, 21 Jan 2019 00:20:00 +0100")
Message-ID: <87va2ioaee.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Matteo Croce <mcroce@redhat.com> writes:

> Fix spelling mistakes in brcm80211 and cfg80211: "lenght" -> "length".
> The typos are also in the special comment blocks which
> translates to documentation.
>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h     | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h     | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      | 2 +-
>  include/net/cfg80211.h                                      | 2 +-

cfg80211 changes go through mac80211-next. Can you please split these in
two patches, cfg80211 and brcmfmac?

-- 
Kalle Valo
