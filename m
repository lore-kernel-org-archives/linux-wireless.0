Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9432AC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61BE32184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ha5xgjIj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NzJF9+SF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfB1I2V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:28:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730832AbfB1I2V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:28:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4DCCB608CE; Thu, 28 Feb 2019 08:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551342500;
        bh=2qfEPljDzI0n+ylUz10NpciA4v9LxT8JMRniW8lovyQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ha5xgjIjCzlPLR6mMdJ5ccKykfjAktFA6P71IyVl9gRlkVhuzfqm5sO3T3WByzst/
         /hyCWOelcTighgKiGEpO1Ek84IgTBu3t55iabZWuGGk0RmUsiDGMOjrlao8IyI9QoR
         n/icXYCqFCtLCQYTf96eApKhQGWfqS5ZMdlO29fA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0EDDB60128;
        Thu, 28 Feb 2019 08:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551342499;
        bh=2qfEPljDzI0n+ylUz10NpciA4v9LxT8JMRniW8lovyQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NzJF9+SFkeVmA0RZsNErdngkfh7LbP5T/7UDQ6jbNvBSxT3Za8E17H4pOehEWfOci
         cCQQKMjeK+7ddvZLdAk/oicTxvUTHCXQvoFaS6h+uG6beAPvx6JjqaKP+unucxqym7
         vpEYWNqy5C7aYK+GZdkIqOWPL2iZHn3I4owsfcqo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0EDDB60128
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH wireless-drivers-next 1/2] brcmfmac: fix size of the
 struct msgbuf_ring_status
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190221103325.28228-1-zajec5@gmail.com>
References: <20190221103325.28228-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190228082820.4DCCB608CE@smtp.codeaurora.org>
Date:   Thu, 28 Feb 2019 08:28:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This updates host struct to match the in-firmawre definition. It's a
> cosmetic change as it only applies to the reserved struct space.
> 
> Fixes: c988b78244df ("brcmfmac: print firmware reported ring status errors")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

2 patches applied to wireless-drivers-next.git, thanks.

0c7051610c57 brcmfmac: fix size of the struct msgbuf_ring_status
c91377495192 brcmfmac: print firmware reported general status errors

-- 
https://patchwork.kernel.org/patch/10823623/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

