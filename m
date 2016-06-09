Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57760 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbcFIGnX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 02:43:23 -0400
Message-ID: <1465454595.3442.0.camel@sipsolutions.net> (sfid-20160609_084342_187726_567463CA)
Subject: Re: [PATCH] Add .set_antenna callback in ath6kl driver to fix
 wireless core warns
From: Johannes Berg <johannes@sipsolutions.net>
To: Prasun Maiti <prasunmaiti87@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Prasun Maiti <prasunmaii87@gmail.com>
Date: Thu, 09 Jun 2016 08:43:15 +0200
In-Reply-To: <1465450591-23543-1-git-send-email-prasunmaiti87@gmail.com> (sfid-20160609_073700_555858_D064B679)
References: <CAGRGNgV4sL2TypkR+zsaDHN26KCF0kjtWPsi9y9D_JkGpvWrUw@mail.gmail.com>
	 <1465450591-23543-1-git-send-email-prasunmaiti87@gmail.com>
	 (sfid-20160609_073700_555858_D064B679)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-06-09 at 11:06 +0530, Prasun Maiti wrote:
> Since add more warnings for inconsistent ops in cfg80211, the
> wireless
> core warns if a driver implements a cfg80211 callback but doesn't
> implements the inverse operation. The ath6kl driver implements a
> cfg80211
> .get_antenna operation handler but doesn't have the inverse
> .set_antenna
> callback. So, it makes warning.
> 
> To remove this warning, add .set_antenna callback in ath6kl driver
> which
> is unimplemented.
> 
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index 4e11ba0..e638296 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -3231,6 +3231,16 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy,
> struct wireless_dev *wdev,
>  					wait, buf, len, no_cck);
>  }
>  
> +static int ath6kl_set_antenna(struct wiphy *wiphy,
> +				u32 tx_ant, u32 rx_ant)
> +{
> +	/*
> +	 * Note: This callback should be implement when firmware
> support this
> +	 * command.
> +	 */
> +	return 0;
> +}
> 
Seriously, this makes no sense at all. Just submit a patch to remove
the warning.

johannes
