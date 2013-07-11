Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:44895 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3GKI1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 04:27:42 -0400
Subject: [RFC]: vlan priority handling in WMM
Date: Thu, 11 Jul 2013 09:45:00 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319015E05AD@sbs2003.acksys.local> (sfid-20130711_102752_483838_26F21898)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric Debarge" <cedric.debarge@acksys.fr>
To: <netdev@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear mailing list,

I would like to manage the VLAN priority in Wireless QOS (WMM).

I get the VLAN tag from skb->vlan_tci and I extract the VLAN priority. 

How I should handle the priority value 0. 
	- Handle this value as no priority request, In this case the frame will 
		sent with the DSCP priority or default (Best effort)
	- Handle this value as a lowest priority, in this case I Map it to the WMM.

For your information, you can found below a discussion on this point 
with Johannes Berg.

Regards.

Cedric Voncken.

-----Message d'origine-----
De : Johannes Berg [mailto:johannes@sipsolutions.net]
Envoyé : lundi 8 juillet 2013 14:16
À : voncken
Cc : linux-wireless@vger.kernel.org
Objet : Re: [PATCH V2] vlan priority handling in WMM

On Mon, 2013-07-08 at 12:39 +0200, voncken wrote:
> > > The vlan Tag contain three bit for priority. The value 0 indicate
> no
> > > priority (on this case the VLAN tag contain only VID). The
> vlan_tci
> > > field is set to zero if the frame do not contain the vlan tag. So
> if
> > > we have not a vlan tag or no priority in VLAN tag the priority
> value
> > > is always 0.
> 
> > Yes but don't we know that the vlan_tci field is valid?
> 
> > I don't think you're correct in that 0 means "no priority present",
> it actually means "best effort" as far as I can tell. Ignoring the 
> VLAN tag when the field is 0 would mean we could use a higher priority 
> from the contents of the frame, which would not be desired?
> 
> I can add a test with the macro vlan_tx_tag_present() to verify if the 
> vlan_tci field is valid.
> I test the value 0 to skip the VLAN priority and use the dscp priority 
> in this case. The priority 0 in VLAN tag is often use to turn off the 
> QOS, because not bit is allowed for it.

What do you mean by "is often used"? I don't see how that would be the case? Are you saying routers commonly ignore the VLAN priority value if it's 0? That would seem odd?

> For me is it correct. Nevertheless, if you prefer, I can test only the 
> vlan_tci validity and in this case always use the VLAN priority.

I don't know! Since you don't seem to really know either, we should ask somebody who knows, I think. Maybe you should Cc netdev with this question on the patch or so?

> Sorry I made a mistake  0xE000 >>13 = 0x0007 and not 0x0003, and 7 is 
> a 3 bits value.

Ah yes, I made the same mistake, sorry.

johannes
