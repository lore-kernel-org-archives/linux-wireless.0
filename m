Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:48546 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964883AbXDGBjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 21:39:42 -0400
Date: Fri, 6 Apr 2007 18:38:48 -0700
From: Jouni Malinen <j@w1.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: ieee80211: Spamming of log resulting from packets with ExtIV not set
Message-ID: <20070407013848.GG16197@jm.kir.nu>
References: <4616DD7E.6010606@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4616DD7E.6010606@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 06, 2007 at 06:53:34PM -0500, Larry Finger wrote:
> Using bcm43xx-softmac, my log gets full of messages that look like:
> 
> Apr  6 18:06:55 larrylap kernel: TKIP: ICV error detected: 
> STA=00:14:bf:85:49:fa

Does the driver properly filter out FCS errors? If not, the proper fix
is to fix the driver to do that. If yes, I'm quite surprised that you
see these messages so frequently.

> Are there any objections to the following patch to eliminate these messages 
> from TKIP and CCMP?

Your patch is not changing this particular error that you showed.. Was
that on purpose? I would be okay with removing the ICV error message
since it has a separate counter, _assuming_ this can be shown to not be
caused by a driver that does not filter out FCS errors.

> Index: wireless-2.6/net/ieee80211/ieee80211_crypt_tkip.c
> ===================================================================
> --- wireless-2.6.orig/net/ieee80211/ieee80211_crypt_tkip.c
> +++ wireless-2.6/net/ieee80211/ieee80211_crypt_tkip.c
> @@ -439,11 +439,7 @@ static int ieee80211_tkip_decrypt(struct
>  	pos = skb->data + hdr_len;
>  	keyidx = pos[3];
>  	if (!(keyidx & (1 << 5))) {
> -		if (net_ratelimit()) {
> -			printk(KERN_DEBUG "TKIP: received packet without 
> ExtIV"
> -			       " flag from " MAC_FMT "\n", 
> MAC_ARG(hdr->addr2));
> -		}
> -		return -2;
> +		return -2; /* received packet without ExtIV */
>  	}

Have you ever seen this message? I would be against this change unless
an error counter is added here. I do not remember anyone having
complained about this particular message, so I would just leave this
as-is.

> Index: wireless-2.6/net/ieee80211/ieee80211_crypt_ccmp.c
> @@ -306,11 +306,7 @@ static int ieee80211_ccmp_decrypt(struct
>  	pos = skb->data + hdr_len;
>  	keyidx = pos[3];
>  	if (!(keyidx & (1 << 5))) {
> -		if (net_ratelimit()) {
> -			printk(KERN_DEBUG "CCMP: received packet without 
> ExtIV"
> -			       " flag from " MAC_FMT "\n", 
> MAC_ARG(hdr->addr2));
> -		}
> -		return -2;
> +		return -2; /* received packet without ExtIV */

Hmm.. This does not apply to the version I have (which actually has
dot11RSNAStatsCCMPFormatErrors counter here).. Without the counter, I
would be against removing this and even with the counter, I would not
remove this unless someone has actually reported this particular message
showing up in logs frequently.


So far, these messages in TKIP/CCMP have found number of issues in
various implementation doing things incorrectly and as such, I would not
recommend removing them unless they can clearly be showed to be causing
problems which cannot be fixed by doing a proper fix (e.g., FCS
validation, duplicate filtering, etc. at the driver level).

-- 
Jouni Malinen                                            PGP id EFC895FA
