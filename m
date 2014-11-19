Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40101 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbaKSSCP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:02:15 -0500
Message-ID: <1416420127.9374.16.camel@sipsolutions.net> (sfid-20141119_190219_257385_E9878219)
Subject: Re: [PATCH v2 2/2] mac80211-hwsim: Add HWSIM_CMD_GET_RADIO command
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrik Flykt <patrik.flykt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 19:02:07 +0100
In-Reply-To: <1415803360-4073-3-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141112_154253_218563_3F2D005A)
References: <1415803360-4073-1-git-send-email-patrik.flykt@linux.intel.com>
	 <1415803360-4073-3-git-send-email-patrik.flykt@linux.intel.com>
	 (sfid-20141112_154253_218563_3F2D005A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-12 at 16:42 +0200, Patrik Flykt wrote:

> -	if (param->reg_alpha2)
> +	if (param->reg_alpha2) {
> +		data->alpha2[0] = param->reg_alpha2[0];
> +		data->alpha2[1] = param->reg_alpha2[1];
>  		regulatory_hint(hw->wiphy, param->reg_alpha2);
> +	}


> +	param.reg_alpha2 = data->alpha2;

This seems incorrect, first reg_alpha2 was conditional, and then you
memcpy it, and then you use it unconditionally which may end up as \x00
\x00?

johannes

