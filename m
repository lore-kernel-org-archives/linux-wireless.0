Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735Ab3CDTX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 14:23:26 -0500
Date: Mon, 4 Mar 2013 13:23:20 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Marco Porsch <marco@cozybit.com>, johannes@sipsolutions.net
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCHv4 2/3] mac80211: mesh power save doze scheduling
Message-ID: <20130304192320.GB20505@thinkpad-t410> (sfid-20130304_202330_699101_EBAE2289)
References: <1362419675-27127-1-git-send-email-marco@cozybit.com>
 <1362419675-27127-2-git-send-email-marco@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362419675-27127-2-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 04, 2013 at 06:54:34PM +0100, Marco Porsch wrote:
> Configure the device for PS mode if the local mesh PS parameters
> allow so and the driver supports it.
> 
> Add two callbacks to ieee80211_ops for mesh powersave:
> - mesh_ps_doze - put the device to sleep now, wake up at given
>   TBTT
> - mesh_ps_wakeup - wake the device up now for frame RX
> These ops may be extended in the future to allow drivers/HW to
> implement mesh PS themselves. (Current design goal was to
> concentrate most mesh PS routines in mac80211 to keep driver
> modifications minimal.)
> 
> Track beacon timing information of peers we are in PS mode
> towards. Calculate the next TBTT per STA. Stay awake to receive
> multicast traffic after DTIM beacons.
> 
> When going to doze state, get the most imminent STA TBTT and
> configure the device to trigger a wakeup on time to catch that
> beacon. After successful receipt put the device to doze again.
> Set a timeout for the case that the beacon is not received on
> time. In this case calculate the following TBTT and go to doze
> again.
> 
> For mesh Awake Windows wakeup on PreTBTT/SWBA (beacon_get_tim)
> and start a timer which triggers a doze call on expiry.
> Similarly, stay awake for the Awake Window duration after
> sending probe response frames.
> 
> Signed-off-by: Marco Porsch <marco@cozybit.com>

I've been looking at power save in mac80211 over the past few days with
an eye towards allowing multiple interface to be supported, as a result
of comments Johannes made at [1]. It seems like adding driver callbacks
for PS which are specific to the interface type is contrary to this
goal.

The basic idea that's been forming on my mind is add PS states to vifs
and make the managed, mesh, etc. code manipulate vif PS states rather
than hw states. Then a PS module would manage the hw state based on the
aggregate of the vif states.

I don't have a lot of the details worked out yet, and my knowledge of PS
in mesh networks (and of mesh network operation in general) is pretty
rudimentary at this point. But afaict any modes which support PS define
the same two hw states, awake and doze. I wonder whether we should
instead aim for a single interface into the driver for PS that's capable
of supporting all interface types.

Anyway, I just wanted to throw this out for discussion.

Thanks,
Seth

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/104064

