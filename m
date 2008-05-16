Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58425 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbYEPUmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 16:42:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [RFC-PATCH] mac80211: add helpers for frame control tests
Date: Fri, 16 May 2008 22:42:27 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <1210966154.5915.50.camel@brick> <1210966704.5915.51.camel@brick>
In-Reply-To: <1210966704.5915.51.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805162242.28181.mb@bu3sch.de> (sfid-20080516_224257_738570_778C11BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 May 2008 21:38:23 Harvey Harrison wrote:
> diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
> index 45709ad..f899a06 100644
> --- a/net/mac80211/wpa.c
> +++ b/net/mac80211/wpa.c
> @@ -24,23 +24,21 @@ static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
>  {
>  	struct ieee80211_hdr *hdr;
>  	size_t hdrlen;
> -	u16 fc;
>  	int a4_included;
>  	u8 *pos;
>  
>  	hdr = (struct ieee80211_hdr *) skb->data;
> -	fc = le16_to_cpu(hdr->frame_control);
>  
>  	hdrlen = 24;
> -	if ((fc & (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) ==
> -	    (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) {
> +	if (ieee80211_fctl_has_a4(hdr)) {
>  		hdrlen += ETH_ALEN;
> +		a4_included = 1;
>  		*sa = hdr->addr4;
>  		*da = hdr->addr3;
> -	} else if (fc & IEEE80211_FCTL_FROMDS) {
> +	} else if (ieee80211_fctl_fromds(hdr)) {
>  		*sa = hdr->addr3;
>  		*da = hdr->addr1;
> -	} else if (fc & IEEE80211_FCTL_TODS) {
> +	} else if (ieee80211_fctl_tods(hdr)) {
>  		*sa = hdr->addr2;
>  		*da = hdr->addr3;
>  	} else {
> @@ -48,16 +46,14 @@ static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
>  		*da = hdr->addr1;
>  	}
>  
> -	if (fc & 0x80)
> +	if (ieee80211_stype(hdr, IEEE80211_STYPE_QOS_DATA))
>  		hdrlen += 2;
>  
>  	*data = skb->data + hdrlen;
>  	*data_len = skb->len - hdrlen;
>  
> -	a4_included = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
^^^^^^^^^^^^^^^^^^^
> -		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
> -	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
> -	    fc & IEEE80211_STYPE_QOS_DATA) {
> +	if (ieee80211_ftype_data(hdr) &&
> +	    ieee80211_stype(hdr, IEEE80211_STYPE_QOS_DATA)) {
>  		pos = (u8 *) &hdr->addr4;
>  		if (a4_included)

Are we going to use a4_included uninitialized now?

>  			pos += 6;



-- 
Greetings Michael.
