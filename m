Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:45786 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370AbYDNVAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 17:00:45 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1701116fgb.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 14:00:43 -0700 (PDT)
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [PATCH] rfkill: Fix device type check when toggling states
Date: Mon, 14 Apr 2008 23:03:32 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <20080412153947.16498.12348.stgit@localhost>
In-Reply-To: <20080412153947.16498.12348.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804142303.32587.IvDoorn@gmail.com> (sfid-20080414_220056_942955_BFBC8013)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 12 April 2008, Carlos Corbacho wrote:
> rfkill_switch_all() is supposed to only switch all the interfaces of a
> given type, but does not actually do this; instead, it just switches
> everything currently in the same state.
> 
> Add the necessary type check in.
> 
> (This fixes a bug I've been seeing while developing an rfkill laptop
> driver, with both bluetooth and wireless simultaneously changing state
> after only pressing either KEY_WLAN or KEY_BLUETOOTH).
> 
> Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

Good catch.
John, could you push this to 2.6.25 as well? Thanks.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
>  net/rfkill/rfkill.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 140a0a8..4e10a95 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -92,7 +92,7 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  	rfkill_states[type] = state;
>  
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
> -		if (!rfkill->user_claim)
> +		if ((!rfkill->user_claim) && (rfkill->type == type))
>  			rfkill_toggle_radio(rfkill, state);
>  	}
>  
> 
> 


