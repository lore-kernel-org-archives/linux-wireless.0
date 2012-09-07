Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2IGQsU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 12:48:20 -0400
Message-ID: <1347036664.8913.1.camel@dcbw.foobar.com> (sfid-20120907_184823_427738_A02AA7C6)
Subject: Re: [PATCH v3] p54: connect to 11w protected networks
From: Dan Williams <dcbw@redhat.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Fri, 07 Sep 2012 11:51:04 -0500
In-Reply-To: <E1TA0re-00059m-CD@debian64.localnet>
References: <E1TA0re-00059m-CD@debian64.localnet>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 15:19 +0200, Christian Lamparter wrote:
> Previously, it was not possible to connect
> to networks which requires 11w to be supported
> by the stations.

If at all possible if we can do this without module parameters, that
would be great.  Otherwise how is userspace supposed to connect to a
W-capable network without twiddling driver-specific module options,
something we've tried really hard to not do?  Module options really
aren't any different than private ioctls or IWPRIV commands...

Dan

> Note:
> 
> As all current (and old) firmwares corrupt
> incoming, protected management frames, the
> decryption offloading needs to be disabled.
> 
> This can be done by loading the p54common
> module with the nohwcrypt=1 parameter.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> v2->v3:
> 	- fixed modparam_nohwcrypt typo
> 	(Yes, v2 never compiled :( )
> 
> Regards,
> 	Christian
> ---
>  drivers/net/wireless/p54/main.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
> index 5e91ad0..8ab5aef 100644
> --- a/drivers/net/wireless/p54/main.c
> +++ b/drivers/net/wireless/p54/main.c
> @@ -739,6 +739,17 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
>  		     IEEE80211_HW_PS_NULLFUNC_STACK |
>  		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
>  
> +	if (modparam_nohwcrypt) {
> +		/*
> +		 * Only support MFP, if the hardware crypto engine
> +		 * is disabled, as the firmware's rx-path corrupts
> +		 * incoming CCMP encrypted RX mgmt frames.
> +		 * However, if no rx key is uploaded, the firmware
> +		 * passes the unencrypted frame to the driver. 
> +		 */
> +		dev->flags |= IEEE80211_HW_MFP_CAPABLE;
> +	}
> +
>  	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
>  				      BIT(NL80211_IFTYPE_ADHOC) |
>  				      BIT(NL80211_IFTYPE_AP) |


