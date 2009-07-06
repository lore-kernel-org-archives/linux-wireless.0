Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:62865 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZGFRgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 13:36:10 -0400
Received: by ewy7 with SMTP id 7so2133205ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 10:36:13 -0700 (PDT)
Message-ID: <4A523609.5070409@gmail.com>
Date: Mon, 06 Jul 2009 18:36:09 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: fix giwrange
References: <1246828399.4411.7.camel@johannes.local>
In-Reply-To: <1246828399.4411.7.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> commit c4c496e49ddbf022e51adbd25cedd071329280db
> Author: David Kilroy <kilroyd@googlemail.com>
> Date:   Thu Jun 18 23:21:14 2009 +0100
> 
>     cfg80211: Advertise ciphers via WE according to driver capability
> 
> unfortunately broke iwrange -- it used the variable c
> that needs to be 0 for the channel list.

Doh! I distinctly recall wonderring whether I should use a separate
variable. Must've got side-tracked. Sorry :(

Just one thing about the fix though...

> @@ -201,7 +201,7 @@ int cfg80211_wext_giwrange(struct net_de
>  	range->avg_qual.noise = range->max_qual.noise / 2;
>  	range->avg_qual.updated = range->max_qual.updated;
>  
> -	for (c = 0; c < wdev->wiphy->n_cipher_suites; c++) {
> +	for (i = 0; i < wdev->wiphy->n_cipher_suites; i++) {
>  		switch (wdev->wiphy->cipher_suites[c]) {
                                                   ^ needs to be i

Dave.
