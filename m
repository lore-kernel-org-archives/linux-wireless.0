Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20247C43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 873F7206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I4d3hIN8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XSzbeKSW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfDYQus (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:50:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfDYQus (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:50:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EBF8160388; Thu, 25 Apr 2019 16:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211047;
        bh=TIYiWMP71EMZTHsGrDIw5t6BtKJGWFWrAFbkehIaAqQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=I4d3hIN8H8rI7uFELWgF/DBRW1yyFuECyNvryf42/TLNrT7/h/yjCQleKrSVgn/m6
         mhxAos54reZzCHm8BGb2emp6L3Evso39IA6qGAj52n9yQNZxnCJvLYM3vza8JRZBNa
         wOqFJL4FjJvv0Deu6Z4lUIqnCdYiFo/LUPaMnwVk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 759B260159;
        Thu, 25 Apr 2019 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211046;
        bh=TIYiWMP71EMZTHsGrDIw5t6BtKJGWFWrAFbkehIaAqQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XSzbeKSWgCcPCmLEmm0lhDtBSCzBOTQ8ZOdSQOt/0pqPEWkqgfG2uPQwkxgSTlh51
         O5Z+q7d5qln7CZF8qoee1aO3pveVl3Vy2mhWIsyw+EPmZbZ0DLzrfH2+5zshQbY1gF
         L4NZN9Mcz81L277hwQtXRgab6k3mUOi333qfhD5s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 759B260159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: prevent an array overflow
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190404084423.GB20193@kadam>
References: <20190404084423.GB20193@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxm@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165046.EBF8160388@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:50:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The "rate_index" is only used as an index into the phist_data->rx_rate[]
> array in the mwifiex_hist_data_set() function.  That array has
> MWIFIEX_MAX_AC_RX_RATES (74) elements and it's used to generate some
> debugfs information.  The "rate_index" variable comes from the network
> skb->data[] and it is a u8 so it's in the 0-255 range.  We need to cap
> it to prevent an array overflow.
> 
> Fixes: cbf6e05527a7 ("mwifiex: add rx histogram statistics support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied to wireless-drivers-next.git, thanks.

b4c35c17227f mwifiex: prevent an array overflow

-- 
https://patchwork.kernel.org/patch/10885297/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

