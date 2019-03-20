Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2112C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 14:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 755642175B
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 14:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ghHKua9i";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ghHKua9i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfCTOF4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:05:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfCTOF4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 10:05:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BD4986077A; Wed, 20 Mar 2019 14:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553090755;
        bh=CZ7OYjo4OAfHixHRfrvTWgkbQ9iZKHUNyFRzeCQhAV8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ghHKua9iZ2Uw5YzAnbXvJyFo1UUMeuIlz8/6gLnnG5dpC56u638a+2Y/7znIzIlqi
         R8IgEtuH3poMFupoAj6ynpFGSqPdrgtGGmUzzUxN/MB+SsJcFaXF4Ymk0dELFQ5MTu
         MSB0p7woqJYj92ZTdzwaRIUgUYjz0nGLOBYEq0Y4=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9E37D602AE;
        Wed, 20 Mar 2019 14:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553090755;
        bh=CZ7OYjo4OAfHixHRfrvTWgkbQ9iZKHUNyFRzeCQhAV8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ghHKua9iZ2Uw5YzAnbXvJyFo1UUMeuIlz8/6gLnnG5dpC56u638a+2Y/7znIzIlqi
         R8IgEtuH3poMFupoAj6ynpFGSqPdrgtGGmUzzUxN/MB+SsJcFaXF4Ymk0dELFQ5MTu
         MSB0p7woqJYj92ZTdzwaRIUgUYjz0nGLOBYEq0Y4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9E37D602AE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on the same host
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
        <20190320100340.14168-13-sergey.matyukevich.os@quantenna.com>
Date:   Wed, 20 Mar 2019 16:05:51 +0200
In-Reply-To: <20190320100340.14168-13-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Wed, 20 Mar 2019 10:04:07 +0000")
Message-ID: <874l7xzlmo.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Fix creation of debugfs entries for qtnfmac wireless card: use separate
> directories for different wireless cards. This commit enables support
> for multiple qtnfmac wireless cards on the same PCIe host.
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> index b561b75e4433..56fc6d49c121 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> @@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
>  
>  int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
>  {
> +	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
> +	char card_id[64];
>  	int ret;
>  
>  	bus->fw_state = QTNF_FW_STATE_BOOT_DONE;
> @@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
>  	if (ret) {
>  		pr_err("failed to attach core\n");
>  	} else {
> -		qtnf_debugfs_init(bus, DRV_NAME);
> +		snprintf(card_id, sizeof(card_id), "%s:%s",
> +			 DRV_NAME, pci_name(priv->pdev));

Can you give an example for the path?

-- 
Kalle Valo
