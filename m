Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:26311 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934819Ab1JETzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 15:55:16 -0400
Date: Wed, 5 Oct 2011 22:52:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Yogesh Powar <yogeshp@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mwifiex: add cfg80211 handlers add/del_virtual_intf
Message-ID: <20111005195228.GG30887@longonot.mountain> (sfid-20111005_215521_557191_FFD958AD)
References: <20111005060744.GB32513@elgon.mountain>
 <477F20668A386D41ADCC57781B1F70430815597445@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430815597445@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 05, 2011 at 12:08:36PM -0700, Bing Zhao wrote:
> Since the first element of priv[] cannot be NULL. How about this fix?
> 
> +       priv = adapter->priv[0];
> +       BUG_ON(!priv);
> +
>         wiphy_unregister(priv->wdev->wiphy);
> 

I don't know the code at all, so I'll trust you on that.  :)

But please don't add the BUG_ON().  Calls to BUG_ON() make the code
messier, and they are more painful than needed for the user.  If we
don't have the BUG_ON() then we get an Oops and the driver will die,
but we can still can close our documents and reboot the system.

Debugging NULL dereference bugs is normally super easy.  Just compile
with CONFIG_DEBUG_INFO=y, run gdb on the .ko file and type:
"list *(function_name+0x63)" at the gdb prompt.  Done.

regards,
dan carpenter

