Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54370 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbYDIU6A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 16:58:00 -0400
Subject: Re: [PATCH] rtl8187: Add missing priv->vif assignments
From: Pavel Roskin <proski@gnu.org>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200804091638.31525.herton@mandriva.com.br>
References: <200804091638.31525.herton@mandriva.com.br>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 16:57:58 -0400
Message-Id: <1207774678.2576.3.camel@dv> (sfid-20080409_215809_660152_5ADA1022)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2008-04-09 at 16:38 -0300, Herton Ronaldo Krzesinski wrote:
> This adds missing priv->vif assignments after "mac80211: don't use
> interface indices in drivers" change. As rtl8180, rtl8187 also needs
> priv->vif to be set, as without this an oops can happen in rtl8187_tx
> function (priv->vif is passed to ieee80211_rts_duration).
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Pavel Roskin <proski@gnu.org>

This patch fixes a potential kernel panic if RTS/CTS is used.  It may be
a good candidate for 2.6.25.

If somebody has an rtl8187 (as opposed to rtl8187b) and the patch indeed
fixes RTS/CTS, please speak up.

-- 
Regards,
Pavel Roskin
