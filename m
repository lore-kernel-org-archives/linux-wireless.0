Return-Path: <SRS0=aCCt=UW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E755EC48BE8
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Jun 2019 12:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B50BF20820
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Jun 2019 12:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VU2XVMK0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ymd9RnnK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfFWMzJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 23 Jun 2019 08:55:09 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54026 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfFWMzJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Jun 2019 08:55:09 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0E9A96034D; Sun, 23 Jun 2019 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561294508;
        bh=u0EIOp8zhTBzJo+bCMYXWKPKbXih72ix3aaCZFqFdaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VU2XVMK0Cn/AaFZsbTJZ+EpLbVg2t84O+JKjnB7E2n2syhqqSuUxt0eIQfGVHt7/i
         /uLxD6l20pelBQHxtXrEPalwGVbOo43pnXXP/myuIpChOeCQ5Q8l28xv9q6cxo2rYk
         CtuUOxx6uE3oQBITE/9gxKBmKIdKTqxoSJw0buyA=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 0B65A6034D;
        Sun, 23 Jun 2019 12:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561294507;
        bh=u0EIOp8zhTBzJo+bCMYXWKPKbXih72ix3aaCZFqFdaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ymd9RnnKKUBk/vwFpHNXUZPzMh1zbfzSoHOiFdEXdUIl29EE1RSik33vSwFN2xad0
         7e8ONbH7ScOV9A+InyKfAyAf8P24jf+UwIHmtPsmnDy8ScBELnhQADKeSPGT4lsUNc
         J+epOYY6bBZP4OQOJ2DgS49fxRwlto2ncqJydQsc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 23 Jun 2019 15:55:06 +0300
From:   merez@codeaurora.org
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] wireless: wil6210: no need to check return value of
 debugfs_create functions
In-Reply-To: <20190611191024.GA17227@kroah.com>
References: <20190611191024.GA17227@kroah.com>
Message-ID: <00b9544a2d0a03930635e144ecbff9c2@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-06-11 22:10, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Maya Erez <merez@codeaurora.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: wil6210@qti.qualcomm.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/wireless/ath/wil6210/debugfs.c | 80 ++++++----------------
>  1 file changed, 22 insertions(+), 58 deletions(-)
> 

Reviewed-by: Maya Erez <merez@codeaurora.org>

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
