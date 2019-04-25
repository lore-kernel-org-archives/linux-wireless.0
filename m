Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96ACC43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A4C3206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HqXP/0qP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CCvFH7wH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfDYQuK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:50:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58142 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfDYQuK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:50:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 547516019D; Thu, 25 Apr 2019 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211009;
        bh=U7ZH4pmBfj8b0YaAo7+t6e3MnhnKm0gJLXEnxV9iQqs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HqXP/0qP5eHg4dkywIPYauWXY1zJ7f8vOI2pt7h2v/2k8NOozD3qpJmEhyv3ZuPlj
         yFmIhgxCNKAOURwb6al4M6UR83r2+5tEdzbeuiY0DDTNl4ImlnBj4SapqTo0mzTDGu
         nSEwZ5b6JIXnnhnfsR6CdZKcroi0SnJsanhSqDgA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2914D601B4;
        Thu, 25 Apr 2019 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211008;
        bh=U7ZH4pmBfj8b0YaAo7+t6e3MnhnKm0gJLXEnxV9iQqs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CCvFH7wHTnULRJJbAHOJmtAP613aJ5LLI/QkIAGPH5CMqWmejrAmSj6f4DWGyuKmP
         4u+aVLZ7/1myDHX7Mt75juol/2dkBy39yxrx/6agNF6yuRbNssfygJWm1Z2NekjR8r
         VZ7ni+fogPVCJKwS8MKdboGhNs/8ASA9YLxGPuUk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2914D601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] zd1211rw: use struct_size() helper
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403185905.GA8650@embeddedor>
References: <20190403185905.GA8650@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165009.547516019D@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:50:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace code of the following form:
> 
> sizeof(struct usb_req_write_regs) + count * sizeof(struct reg_data)
> 
> with:
> 
> struct_size(req, reg_writes, count)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

0c7beb2db9a5 zd1211rw: use struct_size() helper

-- 
https://patchwork.kernel.org/patch/10884349/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

