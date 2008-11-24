Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54562 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbYKXIrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 03:47:39 -0500
Date: Mon, 24 Nov 2008 09:49:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: Ian Schram <ischram@telenet.be>
Cc: gregkh@suse.de, greg@kroah.com, linux-wireless@vger.kernel.org
Subject: Re: patch staging-add-w35und-wifi-driver.patch added to gregkh-2.6
	tree
Message-ID: <20081124084915.GA30173@elf.ucw.cz> (sfid-20081124_094743_909160_F5DB5F84)
References: <12228899693880@kroah.org> <48E40225.60204@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48E40225.60204@telenet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu 2008-10-02 01:05:09, Ian Schram wrote:
> > +
> > +static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
> > +		      struct ieee80211_tx_control *control)
> > +{
> > +	char *buffer = kmalloc(skb->len, GFP_ATOMIC);
> > +	printk("Sending frame %d bytes\n", skb->len);
> > +	memcpy(buffer, skb->data, skb->len);
> > +	if (1 == MLMESendFrame(my_adapter, buffer, skb->len, FRAME_TYPE_802_11_MANAGEMENT))
> > +		printk("frame sent ok (%d bytes)?\n", skb->len);
> > +	return NETDEV_TX_OK;
> > +}
> > +
> 
> Looks to me, that this is an Oops waiting to happen, might be cautious to check
> if kmalloc succeeded, before copying to the address.

This was fixed -- not by me :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
