Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:58908 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888Ab2E2MWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 08:22:02 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: Re: ath9k stops working (DMA trouble?) shortly after going online
Date: Tue, 29 May 2012 13:21:45 +0100
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
References: <201205281316.15008.tvrtko.ursulin@onelan.co.uk> <201205291212.46377.tvrtko.ursulin@onelan.co.uk> <20420.48433.260465.183715@gargle.gargle.HOWL>
In-Reply-To: <20420.48433.260465.183715@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201205291321.45920.tvrtko.ursulin@onelan.co.uk> (sfid-20120529_142207_242809_7DA2E2C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 29 May 2012 13:12:33 Sujith Manoharan wrote:
> Tvrtko Ursulin wrote:
> > I've collected several interesting events but the compressed log is quite
> > large. Not sure if it will make it to the mailing list, but you should at
> > least get it privately.
> 
> Thanks.
> 
> > There are events ranging from short to long connection dropouts (in the
> > light of that it is possible that the path Mohammed suggested did indeed
> > help, at least partially to unwedge some situation which would hang it
> > completely without the patch). There is always mention of the 'DMA'
> > keyword when it happens, so if you grep for that in my log you will see
> > events happening at, in printk time:
> > 
> > 118.779362 - 118.795238 (WARN_ON WARNING: at
> > drivers/net/wireless/ath/ath9k/recv.c:531 ath_stoprecv+0x118/0x130
> > [ath9k]())
> > 
> > 524.162432 - 524.753750
> > 1544.610658 - 1550.218324
> > 1685.668241 - 1686.991166
> > 1773.268867 - 1804.465933
> > 
> > Hope this helps?
> 
> Yes !
> 
> Here are a couple of patches to help narrow down the issue.
> 
> http://sujith.github.com/patches/wl/0001-ath9k-Add-some-debug-messages.patc
> h
> http://sujith.github.com/patches/wl/0002-ath9k-Resync-beacons-after-a-rese
> t.patch
> 
> The first one adds some messages, the second sets up beacons properly in
> case a HW reset happens. Can you try these and post the log ?

Will do.

The second one did not apply though. You have a line:

        if (!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL) && start) {

While my kernel has:

        if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)) && start) {
 
I've manually added your code below it and will test with that unless you 
shout no quickly.

> If you are willing to move to a more recent kernel, then current
> wireless-testing would be a good choice since it has various driver fixes.
> There are a few pending ath9k patches which have not been merged yet, you
> can find it here:
> 
> http://sujith.github.com/patches/wl/wl-ath9k-May-29-2012.patch

I can do that, but ideally I need to find a set of fixes which will make a 
released kernel work. compat-wireless also works for us.

I'll test the above patches first and then we'll see.

Tvrtko
