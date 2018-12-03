Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647CFC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 18:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3923D208A3
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 18:33:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3923D208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbeLCSc6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 13:32:58 -0500
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:44448 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726595AbeLCSc6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 13:32:58 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 32B55181D341D;
        Mon,  3 Dec 2018 18:32:55 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: brush93_8db5ec48c9c5b
X-Filterd-Recvd-Size: 3448
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Mon,  3 Dec 2018 18:32:53 +0000 (UTC)
Message-ID: <eef7598bb282218d4700986b15cf9f83a5e7edb5.camel@perches.com>
Subject: Re: [PATCH 1/3] mwifiex: debugfs: correct histogram spacing,
 formatting
From:   Joe Perches <joe@perches.com>
To:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org
Date:   Mon, 03 Dec 2018 10:32:52 -0800
In-Reply-To: <20181130225303.143409-1-briannorris@chromium.org>
References: <20181130225303.143409-1-briannorris@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-11-30 at 14:53 -0800, Brian Norris wrote:
> Currently, snippets of this file look like:
> 
> rx rates (in Mbps): 0=1M   1=2M2=5.5M  3=11M   4=6M   5=9M  6=12M
> 7=18M  8=24M  9=36M  10=48M  11=54M12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)
> 44-53=MCS0-9(VHT:BW20)54-63=MCS0-9(VHT:BW40)64-73=MCS0-9(VHT:BW80)
> ...
> noise_flr[--96dBm] = 22
> noise_flr[--95dBm] = 149
> noise_flr[--94dBm] = 9
> noise_flr[--93dBm] = 2
> 
> We're missing some spaces, and we're adding a minus sign ('-') on values
> that are already negative signed integers.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/debugfs.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
> index cce70252fd96..65e48e16cb49 100644
> --- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
> +++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
> @@ -273,14 +273,14 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
>  		     "total samples = %d\n",
>  		     atomic_read(&phist_data->num_samples));
>  
> -	p += sprintf(p, "rx rates (in Mbps): 0=1M   1=2M");
> +	p += sprintf(p, "rx rates (in Mbps): 0=1M   1=2M ");
>  	p += sprintf(p, "2=5.5M  3=11M   4=6M   5=9M  6=12M\n");
> -	p += sprintf(p, "7=18M  8=24M  9=36M  10=48M  11=54M");
> +	p += sprintf(p, "7=18M  8=24M  9=36M  10=48M  11=54M ");
>  	p += sprintf(p, "12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)\n");
> 

It's be smaller object code and more intelligible source to use
a single coalesced string with one sprintf

>  	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info)) {
> -		p += sprintf(p, "44-53=MCS0-9(VHT:BW20)");
> -		p += sprintf(p, "54-63=MCS0-9(VHT:BW40)");
> +		p += sprintf(p, "44-53=MCS0-9(VHT:BW20) ");
> +		p += sprintf(p, "54-63=MCS0-9(VHT:BW40) ");
>  		p += sprintf(p, "64-73=MCS0-9(VHT:BW80)\n\n");
>  	} else {
>  		p += sprintf(p, "\n");
> @@ -310,7 +310,7 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,y 
>  	for (i = 0; i < MWIFIEX_MAX_NOISE_FLR; i++) {
>  		value = atomic_read(&phist_data->noise_flr[i]);
>  		if (value)
> -			p += sprintf(p, "noise_flr[-%02ddBm] = %d\n",
> +			p += sprintf(p, "noise_flr[%02ddBm] = %d\n",
>  				(int)(i-128), value);
>  	}
>  	for (i = 0; i < MWIFIEX_MAX_SIG_STRENGTH; i++) {

