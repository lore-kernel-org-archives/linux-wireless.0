Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2JRH0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 03:26:53 -0400
Message-ID: <1350545240.10638.0.camel@jlt4.sipsolutions.net> (sfid-20121018_092656_207499_20E15D11)
Subject: Re: [PATCH] cfg80211: Disallow HT/WEP in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 18 Oct 2012 09:27:20 +0200
In-Reply-To: <20607.35416.907913.623637@gargle.gargle.HOWL> (sfid-20121018_065553_279891_C636C8C8)
References: <20607.35416.907913.623637@gargle.gargle.HOWL>
	 (sfid-20121018_065553_279891_C636C8C8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-18 at 10:19 +0530, Sujith Manoharan wrote:
> Currently, a user is allowed to choose a HT operating channel
> with WEP when creating an IBSS network. WEP is not allowed
> in HT configuration - this patch ensures that such requests
> are denied.

Applied, but

> @@ -733,6 +733,12 @@ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
>  		result->params[parse.idx].key_len = parse.p.key_len;
>  		result->params[parse.idx].key = result->data[parse.idx];
>  		memcpy(result->data[parse.idx], parse.p.key, parse.p.key_len);
> +
> +		if (result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP40 ||
> +		    result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP104) {

I changed this to be "parse.p.cipher == " to make the lines shorter.

johannes

