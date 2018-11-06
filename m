Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F32C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 213642081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R5UQmLcN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rb+8dXiQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 213642081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389462AbeKGC3J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:29:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59406 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGC3I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:29:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7E7DF6038E; Tue,  6 Nov 2018 17:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523780;
        bh=ZAy/E5L15EzbLaLg8tXQnEyCzUX0jvuyRDWwA5z5BM8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=R5UQmLcNHdclMhiyJycdMQocWav1LmBtQ5zLGLXKPqmSqYHM/5ekThF6SeV4/ppFA
         vcXAmfwaMm4kOBogD3q+8yghh1TMmC6y/gz4QMkHv4DNCUSL5ZKKevLlnjT1vQMov2
         V/uoZlz2tU8SIa1rrs2fpwhOVXCAlO2n0+lPHcps=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0441D601DA;
        Tue,  6 Nov 2018 17:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523780;
        bh=ZAy/E5L15EzbLaLg8tXQnEyCzUX0jvuyRDWwA5z5BM8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Rb+8dXiQBqMJL13svEj6m/YRgPqWTMeapOmZKbek/kaVyDSTs3p33fTAxSqRrlcih
         odXh1gDgXxKRKcZbqw/3VNmcg3N6bkTa+Uiil0IIG92FXZmjbpAy245CP89bkyeCb1
         Lb5MoQpCKj5SFj2DJX7BwkKCtoLoK7/lRQDhgfiw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0441D601DA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: airo: potential buffer overflow in sprintf()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181024083334.a6pxsifew3iztuun@kili.mountain>
References: <20181024083334.a6pxsifew3iztuun@kili.mountain>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106170300.7E7DF6038E@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 17:03:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> It looks like we wanted to print a maximum of BSSList_rid.ssidLen bytes
> of the ssid, but we accidentally use "%*s" (width) instead of "%.*s"
> (precision) so if the ssid doesn't have a NUL terminator this could lead
> to an overflow.
> 
> Static analysis.  Not tested.
> 
> Fixes: e174961ca1a0 ("net: convert print_mac to %pM")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied to wireless-drivers-next.git, thanks.

3d39e1bb1c88 wireless: airo: potential buffer overflow in sprintf()

-- 
https://patchwork.kernel.org/patch/10654389/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

