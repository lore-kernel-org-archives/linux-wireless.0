Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab1IOJDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:03:13 -0400
Subject: Re: [PATCH] cfg80211: add cfg80211_find_vendor_ie() function
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316076781-12580-1-git-send-email-eliad@wizery.com> (sfid-20110915_105337_024525_83632A66)
References: <1316076781-12580-1-git-send-email-eliad@wizery.com>
	 (sfid-20110915_105337_024525_83632A66)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 11:03:10 +0200
Message-ID: <1316077390.3992.1.camel@jlt3.sipsolutions.net> (sfid-20110915_110317_164118_D37B5283)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> +const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
> +				  const u8 *ies, int len)
> +{
> +	struct ieee80211_vendor_ie *ie;
> +	const u8 *pos = ies, *end = ies + len;
> +	int ie_oui;
> +
> +	while (pos < end) {
> +		pos = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, pos,
> +				       end - pos);
> +		if (!pos)
> +			return NULL;
> +
> +		if (end - pos < sizeof(*ie))
> +			return NULL;
> +
> +		ie = (struct ieee80211_vendor_ie *)pos;
> +		ie_oui = ie->oui[0] << 16 | ie->oui[1] << 8 | ie->oui[2];
> +		if (ie_oui == oui && ie->oui_type == oui_type)
> +			return pos;
> +
> +		pos += 2 + ie->len;

I think it should also check that the whole IE including ie->len (not
just sizeof(*ie) fits into the buffer, before returning it. That is, add
something like

if (end - pos < 2 + ie->len)
	return NULL;

after the sizeof(*ie) check.

johannes

