Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:54217 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754885AbcBBOdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 09:33:10 -0500
Message-ID: <1454423585.7291.16.camel@perches.com> (sfid-20160202_153317_858200_6EB577EA)
Subject: Re: [patch] mwifiex: fix a reversed condition
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	chunfan chen <jeffc@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Tue, 02 Feb 2016 06:33:05 -0800
In-Reply-To: <20160202100005.GA3040@mwanda>
References: <20160202100005.GA3040@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-02 at 13:00 +0300, Dan Carpenter wrote:
> The NULL test here is reversed.
[]
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
[]
> @@ -2196,7 +2196,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
>  
>  			pmatch = adapter->nd_info->matches[idx];
>  
> -			if (!pmatch) {
> +			if (pmatch) {
>  				memset(pmatch, 0, sizeof(*pmatch));

As it's just been kzalloc'ed,
this memset seems unnecessary as well.

