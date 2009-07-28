Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f221.google.com ([209.85.218.221]:55298 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZG1TyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 15:54:05 -0400
Received: by bwz21 with SMTP id 21so278517bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 12:54:04 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: fix disassoc while not associated
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1248682948.19945.27.camel@johannes.local>
References: <1248682948.19945.27.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 22:53:59 +0300
Message-Id: <1248810839.30488.10.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 10:22 +0200, Johannes Berg wrote:
> When trying to disassociate while not associated,
> the kernel would crash rather than refusing the
> operation, fix this;
> 
> Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/wireless/mlme.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- wireless-testing.orig/net/wireless/mlme.c	2009-07-27 10:20:17.000000000 +0200
> +++ wireless-testing/net/wireless/mlme.c	2009-07-27 10:20:56.000000000 +0200
> @@ -545,6 +545,12 @@ static int __cfg80211_mlme_disassoc(stru
>  
>  	ASSERT_WDEV_LOCK(wdev);
>  
> +	if (wdev->sme_state != CFG80211_SME_CONNECTED)
> +		return -ENOTCONN;
> +
> +	if (WARN_ON(!wdev->current_bss))
> +		return -ENOTCONN;
> +
>  	memset(&req, 0, sizeof(req));
>  	req.reason_code = reason;
>  	req.ie = ie;
> 
> 

Thanks, this fixes this bug for me.
Still many problems though.


Best regards,
	Maxim Levitsky

