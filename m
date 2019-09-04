Return-Path: <SRS0=IwVr=W7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C20BC3A5A7
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 06:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6526A23401
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 06:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SLll4VeA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZQfyRXsC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfIDGYC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:24:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40250 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDGYC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Sep 2019 02:24:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 80882614BF; Wed,  4 Sep 2019 06:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567578240;
        bh=9TsUPRGNa8j66RTOeV8Du+4Nt7klePDihA/uWZTIa9I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SLll4VeAQ0QU17zi0e7HP8Mki2FWhPaVGpzWDI6S0NKYis5LtZW1G/vpb6qWjiL54
         nvYFyHV+ddz0pwWN5dsxNtQZ58Vh/PmYHBFDYMAHtIaKlhK120IGziUnFjbtINkH5V
         7CioEVz2rtFfHmL9DT83fPwx2KkF48uE17lYlMFU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 286D561516;
        Wed,  4 Sep 2019 06:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567578235;
        bh=9TsUPRGNa8j66RTOeV8Du+4Nt7klePDihA/uWZTIa9I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZQfyRXsCCsnPjZwCMqxdB3E9XvA9mVHunzff7Wpg8fqaa057rSGq8/ehziQl+KnHr
         eWb4sCCE43Sh0DIMouQPhkjdCmlQKO0d4Li+wlRaMqtnFZCXAadLvX9YJY84FkMbBN
         EW0orLCFvsmvQYIn0B5KzzlkmSK14aJCFsy7cho4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 286D561516
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] Fix a NULL-ptr-deref bug in
 ath6kl_usb_alloc_urb_from_pipe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190804002905.11292-1-benquike@gmail.com>
References: <20190804002905.11292-1-benquike@gmail.com>
To:     Hui Peng <benquike@gmail.com>
Cc:     davem@davemloft.net, Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190904062400.80882614BF@smtp.codeaurora.org>
Date:   Wed,  4 Sep 2019 06:23:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hui Peng <benquike@gmail.com> wrote:

> The `ar_usb` field of `ath6kl_usb_pipe_usb_pipe` objects
> are initialized to point to the containing `ath6kl_usb` object
> according to endpoint descriptors read from the device side, as shown
> below in `ath6kl_usb_setup_pipe_resources`:
> 
> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> 	endpoint = &iface_desc->endpoint[i].desc;
> 
> 	// get the address from endpoint descriptor
> 	pipe_num = ath6kl_usb_get_logical_pipe_num(ar_usb,
> 						endpoint->bEndpointAddress,
> 						&urbcount);
> 	......
> 	// select the pipe object
> 	pipe = &ar_usb->pipes[pipe_num];
> 
> 	// initialize the ar_usb field
> 	pipe->ar_usb = ar_usb;
> }
> 
> The driver assumes that the addresses reported in endpoint
> descriptors from device side  to be complete. If a device is
> malicious and does not report complete addresses, it may trigger
> NULL-ptr-deref `ath6kl_usb_alloc_urb_from_pipe` and
> `ath6kl_usb_free_urb_to_pipe`.
> 
> This patch fixes the bug by preventing potential NULL-ptr-deref
> (CVE-2019-15098).
> 
> Signed-off-by: Hui Peng <benquike@gmail.com>
> Reported-by: Hui Peng <benquike@gmail.com>
> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

39d170b3cb62 ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

-- 
https://patchwork.kernel.org/patch/11074655/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

