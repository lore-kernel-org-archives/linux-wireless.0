Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbYJAXSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 19:18:44 -0400
Date: Wed, 1 Oct 2008 16:10:11 -0700
From: Greg KH <gregkh@suse.de>
To: Ian Schram <ischram@telenet.be>
Cc: pavel@suse.cz, greg@kroah.com, linux-wireless@vger.kernel.org
Subject: Re: patch staging-add-w35und-wifi-driver.patch added to gregkh-2.6
	tree
Message-ID: <20081001231011.GA26428@suse.de> (sfid-20081002_011852_518562_50041C3C)
References: <12228899693880@kroah.org> <48E40225.60204@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48E40225.60204@telenet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 02, 2008 at 01:05:09AM +0200, Ian Schram wrote:
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

Patches gladly accepted :)

thanks,

greg k-h
