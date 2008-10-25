Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47789 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYJYLbq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 07:31:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
Date: Sat, 25 Oct 2008 13:31:24 +0200
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
References: <4902DEBB.3050205@hotmail.com> <200810251325.07916.mb@bu3sch.de> <20081025112813.GC12252@Chamillionaire.breakpoint.cc>
In-Reply-To: <20081025112813.GC12252@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810251331.24311.mb@bu3sch.de> (sfid-20081025_133148_789767_CDE40B7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 October 2008 13:28:13 Sebastian Andrzej Siewior wrote:
> @@ -662,7 +663,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
>  			&& !mac->pass_ctrl)
>  		return 0;
>  
> -	fc = *(__le16 *)buffer;
> +	fc = get_unaligned_le16(buffer);

This still does semantically change the code.
fc is supposed to be LE and is used as LE in the following code.

>  	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
>  
>  	skb = dev_alloc_skb(length + (need_padding ? 2 : 0));

-- 
Greetings Michael.
