Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:31389 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZJVJ21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 05:28:27 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC] libertas: monster-patch to make CFG/WEXT configurable
Date: Thu, 22 Oct 2009 11:28:01 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <200910191449.18915.hs4233@mail.mn-solutions.de> <1256150184.5010.45.camel@localhost.localdomain>
In-Reply-To: <1256150184.5010.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910221128.01851.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> For the mesh interface stuff, especially in tx/rx paths, would
> you mind not ifdefing that?  Since with cfg80211,
> priv->mesh_dev will always be NULL, those checks will be just
> fine and you still don't have to care about mesh.

Sure, I'll do that.

I just thought that there's no need for priv->mesh_dev in the 
cfg80211 case. Wouldn't mesh be activated by "iw dev XXX set 
type mesh"?  Then cfg80211_ops .change_intf() would be called.

Now that could either populate priv->mesh_dev ... or it could 
change priv->dev. Not sure about what is better. But the answer 
to this would tell us how to handle the mesh tx/rx paths.


cmdresp.c checks for priv->mesh_autostart_enabled. Is this 
another "sitting-forever-in-OLPC" thingy?  It's nowhere else
used and there's no code to set it.


> I'm sure that the bits for SNMP_MIB_OID_BSS_TYPE could also be
> converted to use lib80211 or cfg80211 values instead of WEXT
> ones; I just picked WEXT at the time because we had no cfg80211
> yet. 

Good idea.

However, when I'm teaching cfg80211 about the SNMP-commands, I'll 
use new-style commands anyway. I'd need them for RTS threshold 
etc anyway.




BTW: I added the RX part of the monitor in my cfg80211
implementation. But for my CF card, I'm still stuck with firmware
5.0.16.p0. That doesn't support monitor mode. However, I also
have some USB stick around (got it from you!). Do you know which
firmware for this USB stick supports monitor?

-- 
http://www.holgerschurig.de
