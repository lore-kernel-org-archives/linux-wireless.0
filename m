Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:55858 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab0AYPVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 10:21:13 -0500
Received: by fxm7 with SMTP id 7so122847fxm.28
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 07:21:11 -0800 (PST)
Subject: Re: [PATCH] mac80211: fix sw crypto
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Jochen Friedrich <jochen@scram.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1264415776.23766.34.camel@johannes.local>
References: <1264415776.23766.34.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 17:21:08 +0200
Message-ID: <1264432868.6336.3.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-01-25 at 11:36 +0100, Johannes Berg wrote: 
> What a stupid mistake. In
> 
>     commit 813d76694043d00b59475baa1fbfaf54a2eb7fad
>     Author: Johannes Berg <johannes@sipsolutions.net>
>     Date:   Sun Jan 17 01:47:58 2010 +0100
> 
>         mac80211: move control.hw_key assignment
> 
> I inserted code testing the wrong flags field,
> which means that the test is almost always true
> (it's really testing for the peer's WMM support)
> and thus the later parts of the stack assume hw
> crypto will be done even if that's not true.
> 
> Obviously, that broke software crypto. Maxim
> said so specifically, and Jochen probably uses
> some cipher that iwl3945 doesn't support in
> hardware, which might also explain that Maxim
> reports that even hw crypto is broken.
This patch works for me. Thanks.

What chipers does iwl3945 support?
I use CCMP, and I also know that software encryption is used by default.

Best regards,
Maxim Levitsky 
> 
> Fix this to test the right flags field.
> 
> Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
> Reported-by: Jochen Friedrich <jochen@scram.de>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/tx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- wireless-testing.orig/net/mac80211/tx.c	2010-01-25 11:13:59.000000000 +0100
> +++ wireless-testing/net/mac80211/tx.c	2010-01-25 11:29:24.000000000 +0100
> @@ -559,7 +559,7 @@ ieee80211_tx_h_select_key(struct ieee802
>  		}
>  
>  		if (!skip_hw && tx->key &&
> -		    tx->key->conf.flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
> +		    tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
>  			info->control.hw_key = &tx->key->conf;
>  	}
>  
> 
> 


