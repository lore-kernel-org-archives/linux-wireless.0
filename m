Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZBUDea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 22:34:30 -0500
Date: Fri, 20 Feb 2009 22:34:29 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: reinette.chatre@intel.com, yi.zhu@intel.com, samuel.ortiz@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi bug when extending a channel struct
Message-ID: <20090221033429.GA20383@bombadil.infradead.org> (sfid-20090221_043449_827114_5E2C2631)
References: <20090220044100.GG4740@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090220044100.GG4740@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 19, 2009 at 08:41:00PM -0800, Luis R. Rodriguez wrote:
> I ran into an issue with iwlagn when working on some patches for cfg80211.
> Initially I thought it was my own patches (even though they didn't touch
> iwlagn) due to some horrible memory corruption issue. As it turns out it
> was my patches but I can reproduce this with this simple patch below.
> 
> diff --git a/include/net/wireless.h b/include/net/wireless.h
> index d815aa8..64a1925 100644
> --- a/include/net/wireless.h
> +++ b/include/net/wireless.h
> @@ -82,6 +82,7 @@ struct ieee80211_channel {
>  	int max_power;
>  	u32 orig_flags;
>  	int orig_mag, orig_mpwr;
> +	bool bug;
>  };
>  
>  /**
> 
> What ends up happening is the wiphy's band channels get all mangled up

So after a fresh kernel install and reboot I do not see this issue any more,
so who knows WTF was going on.

  Luis
