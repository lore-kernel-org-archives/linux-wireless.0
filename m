Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from winston.telenet-ops.be ([195.130.137.75]:34424 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYJAXFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 19:05:21 -0400
Message-ID: <48E40225.60204@telenet.be> (sfid-20081002_010529_554851_F5DD2D34)
Date: Thu, 02 Oct 2008 01:05:09 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: gregkh@suse.de
CC: pavel@suse.cz, greg@kroah.com, linux-wireless@vger.kernel.org
Subject: Re: patch staging-add-w35und-wifi-driver.patch added to gregkh-2.6
 tree
References: <12228899693880@kroah.org>
In-Reply-To: <12228899693880@kroah.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +
> +static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
> +		      struct ieee80211_tx_control *control)
> +{
> +	char *buffer = kmalloc(skb->len, GFP_ATOMIC);
> +	printk("Sending frame %d bytes\n", skb->len);
> +	memcpy(buffer, skb->data, skb->len);
> +	if (1 == MLMESendFrame(my_adapter, buffer, skb->len, FRAME_TYPE_802_11_MANAGEMENT))
> +		printk("frame sent ok (%d bytes)?\n", skb->len);
> +	return NETDEV_TX_OK;
> +}
> +

Looks to me, that this is an Oops waiting to happen, might be cautious to check
if kmalloc succeeded, before copying to the address.
