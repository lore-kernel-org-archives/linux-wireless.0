Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:53553 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYGWQpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:45:35 -0400
Received: by nf-out-0910.google.com with SMTP id d3so906189nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 09:45:33 -0700 (PDT)
To: Daniel Wagner <wagi@monom.org>
Subject: Re: [PATCH] rt2x00mac: In error case stop netdev queue, free skb and return NETDEV_TX_OK
Date: Wed, 23 Jul 2008 19:02:46 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1216805279-19149-1-git-send-email-wagi@monom.org> <200807231822.04895.IvDoorn@gmail.com> <48875EE5.3060303@monom.org>
In-Reply-To: <48875EE5.3060303@monom.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807231902.47026.IvDoorn@gmail.com> (sfid-20080723_184538_767681_1E371855)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008, Daniel Wagner wrote:
> Ivo van Doorn wrote:
> > On Wednesday 23 July 2008, Daniel Wagner wrote:
> >> It is not allowed to use NETDEV_TX_BUSY in tx path anymore.
> > 
> > If not, then why is mac80211 checking and handling the return value
> > and is tx() still a function returning an int. mac80211 is actually requeueing
> > the frame when the hardware fails to send it, so why should that be completely blocked?
> 
> Well, I might be completely wrong here. I got this idea from following mail on netdev:
> http://marc.info/?l=linux-wireless&m=121025252321824&w=2

Hmm, well Johannes just indicated that the code I mentioned earlier will be removed,
in that case I am fine with a patch like this, however with a few adjustments. ;)

> >> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> >> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> >> @@ -46,7 +46,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
> >>  	skb = dev_alloc_skb(size + rt2x00dev->hw->extra_tx_headroom);
> >>  	if (!skb) {
> >>  		WARNING(rt2x00dev, "Failed to create RTS/CTS frame.\n");
> >> -		return NETDEV_TX_BUSY;
> >> +		return -1;
> > 
> > I am kind of missing the point here, this patch seems to come down to:
> > 	We can't return TX_BUSY so we return a random other value
> 
> Unfortunately yes. The last return in this function is still NETDEV_TX_OK. My idea
> was to return 0 on success in error -1. Is this not the expected normal
> 'typeless' return behavior of a function, no? 

Please make it a decent -E... error code then. Looks far less obscure then -1.

Also could you make the exit code with

	ieee80211_stop_queue(rt2x00dev->hw, qid);
	dev_kfree_skb_any(skb);
	return NETDEV_TX_OK;

and exit_fail goto?

Saves a lot of duplicate code. ;)

Thanks,

Ivo
