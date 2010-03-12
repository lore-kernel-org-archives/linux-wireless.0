Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0CLLgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 06:36:10 -0500
Subject: Re: [PATCH/RFC 2/3] mac80211_hwsim: add a control device
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: jouni.malinen@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <1268368999-12734-3-git-send-email-me@bobcopeland.com>
References: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
	 <1268368999-12734-3-git-send-email-me@bobcopeland.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 03:36:00 -0800
Message-ID: <1268393760.4828.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-11 at 23:43 -0500, Bob Copeland wrote:

> +	err = misc_register(&mac80211_hwsim_miscdev);
> +	if (err) {
> +		class_unregister(hwsim_class);
> +		goto failed;
> +	}
> +
>  	for (i = 0; i < radios; i++) {
>  		struct mac80211_hwsim_data *data =
>  			mac80211_hwsim_create_radio();
>  

Keeping the static virtual radios is odd ... you can't use them for
anything since they can't communicate, I think?

johannes

