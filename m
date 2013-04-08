Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3DHJNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 05:13:01 -0400
Message-ID: <1365412374.25475.2.camel@jlt4.sipsolutions.net> (sfid-20130408_111325_581427_01D2BCAA)
Subject: Re: [PATCH] mac80211_hwsim: Register and bind to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Date: Mon, 08 Apr 2013 11:12:54 +0200
In-Reply-To: <20130408090633.GB2818@piware.de>
References: <20130408090633.GB2818@piware.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks fine, but ...

> @@ -2179,6 +2183,8 @@ static int __init init_mac80211_hwsim(void)
>  	if (IS_ERR(hwsim_class))
>  		return PTR_ERR(hwsim_class);
>  
> +	driver_register(&mac80211_hwsim_driver);
> +
>  	memset(addr, 0, ETH_ALEN);
>  	addr[0] = 0x02;

I think you forgot to update the error path to unregister the driver.

johannes

