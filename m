Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2B2I2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 03:28:08 -0500
Subject: Re: checking for integer overflows in cfg80211_roamed_bss()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20120229063841.GG18031@elgon.mountain> (sfid-20120229_073850_391425_67F24184)
References: <20120229063841.GG18031@elgon.mountain>
	 (sfid-20120229_073850_391425_67F24184)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Feb 2012 09:28:04 +0100
Message-ID: <1330504084.4714.0.camel@jlt3.sipsolutions.net> (sfid-20120229_092812_762848_B7F4CEA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-29 at 09:38 +0300, Dan Carpenter wrote:
> I just sent a patch for a places that didn't cap "req_ie_len" and
> "resp_ie_len" properly leading to integer overflows in
> cfg80211_roamed_bss().  If there was a good way, I'd like to cap those
> values inside cfg80211_roamed_bss() as well.  What is a good limit to
> use?
> 
> devel/net/wireless/sme.c
>    653  
>    654          ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
>    655          if (!ev) {
>    656                  cfg80211_put_bss(bss);
>    657                  return;
>    658          }
>    659  

Probably IEEE80211_MAX_DATA_LEN, there's no way all the IEs could ever
be longer than that combined, at least for now :)

johannes

