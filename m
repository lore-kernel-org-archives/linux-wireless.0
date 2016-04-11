Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:57241 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbcDKDdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 23:33:17 -0400
Date: Sun, 10 Apr 2016 23:33:13 -0400 (EDT)
Message-Id: <20160410.233313.1103755950436664749.davem@davemloft.net> (sfid-20160411_053326_080046_7B3F1967)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, dmitrijs.ivanovs@ubnt.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] netlink: don't send NETLINK_URELEASE for unbound
 sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1460014298-30293-1-git-send-email-johannes@sipsolutions.net>
References: <1460014298-30293-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu,  7 Apr 2016 09:31:38 +0200

> From: Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com>
> 
> All existing users of NETLINK_URELEASE use it to clean up resources that
> were previously allocated to a socket via some command. As a result, no
> users require getting this notification for unbound sockets.
> 
> Sending it for unbound sockets, however, is a problem because any user
> (including unprivileged users) can create a socket that uses the same ID
> as an existing socket. Binding this new socket will fail, but if the
> NETLINK_URELEASE notification is generated for such sockets, the users
> thereof will be tricked into thinking the socket that they allocated the
> resources for is closed.
> 
> In the nl80211 case, this will cause destruction of virtual interfaces
> that still belong to an existing hostapd process; this is the case that
> Dmitry noticed. In the NFC case, it will cause a poll abort. In the case
> of netlink log/queue it will cause them to stop reporting events, as if
> NFULNL_CFG_CMD_UNBIND/NFQNL_CFG_CMD_UNBIND had been called.
> 
> Fix this problem by checking that the socket is bound before generating
> the NETLINK_URELEASE notification.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Ivanov <dima@ubnt.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and queued up for -stable, thanks everyone.
