Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:35843 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaATJzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 04:55:33 -0500
Received: from smtp01.msg.oleane.net (smtp01.mail.priv [172.17.20.110])
	by smtp-out06.msg.oleane.net with ESMTP id s0K9tWZp027838
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 10:55:32 +0100
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Dani Camps'" <danicamps81@yahoo.com>,
	<linux-wireless@vger.kernel.org>
References: <1389976009.26074.YahooMailNeo@web172803.mail.ir2.yahoo.com>
In-Reply-To: <1389976009.26074.YahooMailNeo@web172803.mail.ir2.yahoo.com>
Subject: RE: Read VLAN Tag in mac80211
Date: Mon, 20 Jan 2014 10:35:18 +0100
Message-ID: <095701cf15c2$ee6eef00$cb4ccd00$@acksys.fr> (sfid-20140120_105540_698814_1C9EA943)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	The VLAN tag is moved from frame to the field skb->vlan_tci by the
input netdev. 

	In your case, if vlan_tci is always equal to 0, I think your driver
do not support the VLAN, or you need to enable it.
	You can have more information from netdev mailing list.

Cedric Voncken 


> -----Message d'origine-----
> Deа: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] De la part de Dani Camps
> Envoyща: vendredi 17 janvier 2014 17:27
> └а: linux-wireless@vger.kernel.org
> Objetа: Read VLAN Tag in mac80211
> 
> 
> 
> Dear all,
> 
> I am having trouble reading a VLAN tag inside mac80211. I believe the tag
is
> in the packet because I can see it in wireshark. This is a simple test
code that
> I am using in tx.c:
> 
> #include <linux/if_vlan.h>
> 
> ...
> а а а а unsigned short TCI;
> а а а а unsigned short id;
> ...
> 
> // Checking if VLAN tag is present
> а а а а if(vlan_tx_tag_present(skb)){
> а а а а а а а а TCI = vlan_tx_tag_get (skb);
> а а а а а а а а id = TCI & VLAN_VID_MASK;
> а а а а а а а а printk ("VLAN detection: аDetected frame with VLAN ID = %x
\n", id);
> а а а а }
> а а а а else{
> а а а а а а а а printk ("VLAN detection: аNo VLAN Tag detected but
skb->vlan_tci is
> %x \n", skb->vlan_tci);
> а а а а }
> 
> The previous code always fails to enter the VLAN present case, and goes to
> the else condition printing a skb->vlan_tci value of zero, whereas I can
see in
> wireshark a frame with a VLAN tag and VLAN ID=1.
> 
> Can anyone help me figure out what I am missing here?
> 
> Best Regards
> 
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

