Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A21C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1A0C2146E
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vpyjij55";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LZlT8T/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfBHOkZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:40:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41738 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfBHOkZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 09:40:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 626CD605FC; Fri,  8 Feb 2019 14:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549636824;
        bh=a8pcoA+ElRlg+BPbhvv3yjxf3aYrEk6yRg4GtWX6Sd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vpyjij55O7gRa5b+vB4OrppAJUaTfkVRE42WDlM7S3g1jcnVFOgoHZXlQzlsDlwSA
         6zW7c5vLgJOJF9XGsnI9eMKnUIL+nG9P4xIL2jGnjNGs2jIQMJKTqBeQNWLg+5RjGK
         vwa+thkaMQBdlGrXtVaWXM5c1XHZVBn2t6IHz26Y=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id B066B605FC;
        Fri,  8 Feb 2019 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549636823;
        bh=a8pcoA+ElRlg+BPbhvv3yjxf3aYrEk6yRg4GtWX6Sd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LZlT8T/XN9HEtwvtpBjjHy2FJ/HmiBwu/2E0ZOuN6NQw7mfYlX3S2PFL4/EzBbzKQ
         /2UiQPg3uK/cEzPdOBGgBZ6gFPqUpcAs+4kG5igG9ORDy0Pp3eP0NMHN7/fZ/bHDd4
         cQgbEIk6Ly3PLu9RVXQQG9OikMVyBR4B7mZWJ11k=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 08 Feb 2019 20:10:23 +0530
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Enable Factory Test Mode for WCN3990
In-Reply-To: <20190208141604.B2D266074F@smtp.codeaurora.org>
References: <1535526038-4299-1-git-send-email-pillair@codeaurora.org>
 <20190208141604.B2D266074F@smtp.codeaurora.org>
Message-ID: <ab3140ba07ac91bc3729e9e2e31d9333@codeaurora.org>
X-Sender: pillair@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,
I have checked the patch, and it is fine.

Thanks,
Rakesh Pillai.


On 2019-02-08 19:46, Kalle Valo wrote:
> Rakesh Pillai <pillair@codeaurora.org> wrote:
> 
>> The support to put WCN3990 firmware into Factory
>> test mode is not present currently. The WCN3990
>> firmware can operate in Factory test mode based
>> on the mode it receives in the wlan enable message
>> from the host driver.
>> 
>> When the host driver is started in testmode send
>> the operating mode as UTF mode, to the WCN3990
>> firmware, in the wlan enable message to start the
>> firmware in Factory test mode.
>> 
>> Tested on: WCN3990
>> Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.
>> 
>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
>> Reviewed-by: Brian Norris <briannorris@chromium.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> I was able to apply with 3-way merge but please double check the 
> results:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=ef562f95826f412c14f59ca916ff55931bed0813
> 
> Applying: ath10k: Enable Factory Test Mode for WCN3990
> Using index info to reconstruct a base tree...
> M       drivers/net/wireless/ath/ath10k/ahb.c
> M       drivers/net/wireless/ath/ath10k/core.c
> M       drivers/net/wireless/ath/ath10k/hif.h
> M       drivers/net/wireless/ath/ath10k/mac.c
> M       drivers/net/wireless/ath/ath10k/pci.c
> M       drivers/net/wireless/ath/ath10k/sdio.c
> M       drivers/net/wireless/ath/ath10k/snoc.c
> M       drivers/net/wireless/ath/ath10k/usb.c
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/wireless/ath/ath10k/usb.c
> Auto-merging drivers/net/wireless/ath/ath10k/snoc.c
> Auto-merging drivers/net/wireless/ath/ath10k/sdio.c
> Auto-merging drivers/net/wireless/ath/ath10k/pci.c
> Auto-merging drivers/net/wireless/ath/ath10k/mac.c
> Auto-merging drivers/net/wireless/ath/ath10k/hif.h
> Auto-merging drivers/net/wireless/ath/ath10k/core.c
> Auto-merging drivers/net/wireless/ath/ath10k/ahb.c
