Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab3APWR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 17:17:27 -0500
Message-ID: <1358374672.15012.23.camel@jlt4.sipsolutions.net> (sfid-20130116_231731_405110_4B777F1B)
Subject: Re: [PATCH] nl80211: allow user-space to determine address for
 P2P_DEVICE
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Greg Goldman <ggoldman@broadcom.com>,
	Jithu Jance <jithu@broadcom.com>
Date: Wed, 16 Jan 2013 23:17:52 +0100
In-Reply-To: <1357636648-4012-1-git-send-email-arend@broadcom.com>
References: <1357636648-4012-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-08 at 10:17 +0100, Arend van Spriel wrote:
> As per email discussion Jouni Malinen pointed out that:
> 
> "P2P message exchanges can be executed on the current operating channel
> of any operation (both P2P and non-P2P station). These can be on 5 GHz
> and even on 60 GHz (so yes, you _can_ do GO Negotiation on 60 GHz).
> 
> As an example, it would be possible to receive a GO Negotiation Request
> frame on a 5 GHz only radio and then to complete GO Negotiation on that
> band. This can happen both when connected to a P2P group (through client
> discoverability mechanism) and when connected to a legacy AP (assuming
> the station receive Probe Request frame from full scan in the beginning
> of P2P device discovery)."
> 
> This means that P2P messages can be sent over different radio devices.
> However, these should use the same P2P device address so it should be
> able to provision this from user-space. This patch adds a parameter for
> this to struct vif_params which should only be used during creation of
> the P2P device interface.
> 
> Cc: Jouni Malinen <j@w1.fi>
> Cc: Greg Goldman <ggoldman@broadcom.com>
> Cc: Jithu Jance <jithu@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Johannes,
> 
> Best wishes. Found this patch catching dust on my shelf/branch. Cleaning
> up in 2013 so here you have it :-)

:-)

> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2079,6 +2079,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>  	    !(rdev->wiphy.interface_modes & (1 << type)))
>  		return -EOPNOTSUPP;
>  
> +	if (type == NL80211_IFTYPE_P2P_DEVICE && info->attrs[NL80211_ATTR_MAC])
> +		nla_memcpy(&params.macaddr[0], info->attrs[NL80211_ATTR_MAC],
> +			   ETH_ALEN);

It seems like this might need a capability parameter or something, so
wpa_s knows this will take effect. OTOH, wpa_s can query the MAC address
afterwards, so it's not really needed, so I applied it.

(I changed the subject to say "configure", "determine" seems a bit vague
to me, the way I read it it could possibly also mean "allow to get" it)

I would also like to see a mac80211 change though to make it take effect
there.

johannes

