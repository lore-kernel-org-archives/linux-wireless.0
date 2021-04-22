Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DD9C433B4
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Apr 2021 12:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B60613FA
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Apr 2021 12:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbhDVMEl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Apr 2021 08:04:41 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:60400 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235957AbhDVMEk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Apr 2021 08:04:40 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2021 08:04:39 EDT
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 4DCEF40247;
        Thu, 22 Apr 2021 04:55:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 4DCEF40247
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1619092526;
        bh=MJmqiV41U2U+lf1iaOAaPzOCORxFhqxk4vA0mywDQtQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KdYxDWdEoeaJus0kWM1LfP5vphdVFNFOSHN4P+Cra42bgPbRoGlq3z6Inlg4Y8Z1j
         7R+ZIN+zYgQ5Jb/78V4RMEzPiDy5CDS9smGwZZXuVGIvvUjaZkjZW6KjqB/DTXYsdu
         eqg8ZIAdTFJng/9e+DDjFdPZOktgP8AGCxucN7Y8=
Received: from [10.230.42.155] (unknown [10.230.42.155])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 9DF831874BD;
        Thu, 22 Apr 2021 04:55:20 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Avoid GFP_ATOMIC when GFP_KERNEL is enough
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <b6e619415db4ee5de95389280d7195bb56e45f77.1618860716.git.christophe.jaillet@wanadoo.fr>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e6f6acff-8ae8-f098-db91-8ebba9726ebc@broadcom.com>
Date:   Thu, 22 Apr 2021 13:55:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b6e619415db4ee5de95389280d7195bb56e45f77.1618860716.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 19-04-2021 21:35, Christophe JAILLET wrote:
> A workqueue is not atomic, so constraints can be relaxed here.
> GFP_KERNEL can be used instead of GFP_ATOMIC.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
