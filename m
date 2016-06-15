Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:45351 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbcFOArR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 20:47:17 -0400
Date: Wed, 15 Jun 2016 10:46:55 +1000
From: James Cameron <quozl@laptop.org>
To: Pavel Andrianov <andrianov@ispras.ru>
Cc: Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@codeaurora.org>,
	libertas-dev@lists.infradead.org, LDV list <ldv-project@ispras.ru>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, vaishali.thakkar@oracle.com
Subject: Re: [ldv-project] [net] libertas: potential race condition
Message-ID: <20160615004655.GE5852@us.netrek.org> (sfid-20160615_024734_898933_96F316B2)
References: <57569424.9040906@ispras.ru>
 <1465310395.29158.2.camel@redhat.com>
 <20160607225114.GA21437@us.netrek.org>
 <5760039B.4050902@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5760039B.4050902@ispras.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 14, 2016 at 05:16:11PM +0400, Pavel Andrianov wrote:
> 08.06.2016 02:51, James Cameron пишет:
> >On Tue, Jun 07, 2016 at 09:39:55AM -0500, Dan Williams wrote:
> >>On Tue, 2016-06-07 at 13:30 +0400, Pavel Andrianov wrote:
> >>>Hi!
> >>>
> >>>There is a potential race condition in
> >>>drivers/net/wireless/libertas/libertas.ko.
> >>>In the function lbs_hard_start_xmit(..), line 159, a socket buffer
> >>>is
> >>>written to priv->current_skb with a spin_lock protection.
> >>>In the function lbs_mac_event_disconnected(..), lines 50-51, the
> >>>field
> >>>current_skb is cleaned. There is no protection used. The
> >>>corresponding
> >>>handlers are activated at the same time in lbs_start_card(..) and
> >>>then
> >>>may be executed simultaneously. Note, there are two structures
> >>>lbs_netdev_ops and mesh_netdev_ops, which have the target handler
> >>>lbs_hard_start_xmit.
> >>>Is it a real race or I have missed something?
> >>Yeah, it looks like it should be grabbing priv->driver_lock before
> >>clearing priv->currenttxskb in lbs_mac_event_disconnected().  Care to
> >>submit a patch after testing?  Do you have any of that hardware?
> >I've hardware, with serial console.
> >
> >Can test any patch, on USB (8388) or SDIO (8686).
> >
> Hi!
> 
> I've prepare the patch for this issue. Could you test it?
> 
> Thank you.

Tested on OLPC XO-1 (usb8388) and XO-1.5 (sd8686) with v4.7-rc3.

Confirmed that lbs_mac_event_disconnected is being called on the
station when hostapd on access point is given SIGHUP.

Longer duration test was;

- SSH to station and run "top -d 0.2",

- send SIGHUP every six seconds, for 300 cycles,

You may add my;

Tested-by: James Cameron <quozl@laptop.org>

-- 
James Cameron
http://quozl.netrek.org/
