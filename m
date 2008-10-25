Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46471 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbYJYLZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 07:25:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
Date: Sat, 25 Oct 2008 13:25:07 +0200
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
References: <4902DEBB.3050205@hotmail.com> <20081025112147.GA12252@Chamillionaire.breakpoint.cc>
In-Reply-To: <20081025112147.GA12252@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810251325.07916.mb@bu3sch.de> (sfid-20081025_132533_587384_111E9BBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 October 2008 13:21:47 Sebastian Andrzej Siewior wrote:
> -	fc = *(__le16 *)buffer;
> +	fc = get_unaligned_le32(buffer);

I'd say this semantically changes the code.

>  	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
>  
>  	skb = dev_alloc_skb(length + (need_padding ? 2 : 0));

-- 
Greetings Michael.
