Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18F8C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C3B62081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XA48eu9H";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OTdjxdgR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C3B62081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389510AbeKGCYC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:24:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389386AbeKGCYB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:24:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D4AE160591; Tue,  6 Nov 2018 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523474;
        bh=J5lzo+MD1hJGMHKcsElCOyT4X3kWRklEWri0cQALWvU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XA48eu9HKlhaDXDYkcrYuFgRgbPyf8ujw09ZJG9x0lCZczg3tES6Y4sgBwX1IbaFs
         QElBGiVCa+JlFvXDl1NRaLnYcHrHAcQVM9ftFxcrCuR2qZBDg9k4dGT3doa0taAnmr
         rkPJ9ebE01HsHTiZqj3o1ui4d9+ZYzTqmXI5B1y4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8A02D601D7;
        Tue,  6 Nov 2018 16:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523474;
        bh=J5lzo+MD1hJGMHKcsElCOyT4X3kWRklEWri0cQALWvU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=OTdjxdgRFb6We7R310sOx69XLRa8Nr7wZJAe3mTk/PpMpC6mLVSy5YHVkSZcJ3HZD
         rvylp5sCgsNJii4dID3xf9XkXQfHaD6wJcxwpvdjipauhiUFUVQMEHnd4qe5P7wYX9
         lo2inLo3fx34E11lsatkfHbdAPVoRdjCdIC0oy6Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8A02D601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] qtnfmac: fix error handling in control path
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181017140231.27353-1-sergey.matyukevich.os@quantenna.com>
References: <20181017140231.27353-1-sergey.matyukevich.os@quantenna.com>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106165754.D4AE160591@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:57:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> This patch fixes the following warnings:
> 
> - smatch
> drivers/net/wireless/quantenna/qtnfmac/commands.c:132 qtnf_cmd_send_with_reply() warn: variable dereferenced before check 'resp' (see line 117)
> drivers/net/wireless/quantenna/qtnfmac/commands.c:716  qtnf_cmd_get_sta_info() error: uninitialized symbol 'var_resp_len'.
> drivers/net/wireless/quantenna/qtnfmac/commands.c:1668 qtnf_cmd_get_mac_info() error: uninitialized symbol 'var_data_len'.
> drivers/net/wireless/quantenna/qtnfmac/commands.c:1697 qtnf_cmd_get_hw_info() error: uninitialized symbol 'info_len'.
> drivers/net/wireless/quantenna/qtnfmac/commands.c:1753 qtnf_cmd_band_info_get() error: uninitialized symbol 'info_len'.
> drivers/net/wireless/quantenna/qtnfmac/commands.c:1782 qtnf_cmd_send_get_phy_params() error: uninitialized symbol 'response_size'.
> drivers/net/wireless/quantenna/qtnfmac/commands.c:2438 qtnf_cmd_get_chan_stats() error: uninitialized symbol 'var_data_len'.
> 
> - gcc-8.2.1
> drivers/net/wireless/quantenna/qtnfmac/commands.c: In function 'qtnf_cmd_send_with_reply':
> drivers/net/wireless/quantenna/qtnfmac/commands.c:133:54: error: 'resp' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

1066bd193d68 qtnfmac: fix error handling in control path

-- 
https://patchwork.kernel.org/patch/10645681/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

