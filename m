Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264AbZJVPbt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 11:31:49 -0400
Subject: Re: [RFC] libertas: monster-patch to make CFG/WEXT configurable
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200910221128.01851.hs4233@mail.mn-solutions.de>
References: <200910191449.18915.hs4233@mail.mn-solutions.de>
	 <1256150184.5010.45.camel@localhost.localdomain>
	 <200910221128.01851.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 22 Oct 2009 08:31:53 -0700
Message-Id: <1256225513.29650.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-10-22 at 11:28 +0200, Holger Schurig wrote:
> > For the mesh interface stuff, especially in tx/rx paths, would
> > you mind not ifdefing that?  Since with cfg80211,
> > priv->mesh_dev will always be NULL, those checks will be just
> > fine and you still don't have to care about mesh.
> 
> Sure, I'll do that.
> 
> I just thought that there's no need for priv->mesh_dev in the 
> cfg80211 case. Wouldn't mesh be activated by "iw dev XXX set 
> type mesh"?  Then cfg80211_ops .change_intf() would be called.
> 
> Now that could either populate priv->mesh_dev ... or it could 
> change priv->dev. Not sure about what is better. But the answer 
> to this would tell us how to handle the mesh tx/rx paths.

Except that we need *both* the mesh dev and the normal wifi dev running
at the same time, like we had before.  It's not either/or.  So in
cfg80211 land, we'd have two virtual interfaces, one would be mesh, and
the other wifi.  They would always share the same RF channel and a few
other PHY characteristics.

> cmdresp.c checks for priv->mesh_autostart_enabled. Is this 
> another "sitting-forever-in-OLPC" thingy?  It's nowhere else
> used and there's no code to set it.

Mesh autostart is a feature where if mesh isn't explicitly enabled (by
turning on msh0 or whatever) then after a short delay, the mesh
functionality will be automatically enabled in firmware.  As with most
mesh stuff, this is OLPC-specific.

> > I'm sure that the bits for SNMP_MIB_OID_BSS_TYPE could also be
> > converted to use lib80211 or cfg80211 values instead of WEXT
> > ones; I just picked WEXT at the time because we had no cfg80211
> > yet. 
> 
> Good idea.
> 
> However, when I'm teaching cfg80211 about the SNMP-commands, I'll 
> use new-style commands anyway. I'd need them for RTS threshold 
> etc anyway.
> 
> 
> 
> 
> BTW: I added the RX part of the monitor in my cfg80211
> implementation. But for my CF card, I'm still stuck with firmware
> 5.0.16.p0. That doesn't support monitor mode. However, I also
> have some USB stick around (got it from you!). Do you know which
> firmware for this USB stick supports monitor?

Any of the mesh-enabled firmwares should work, I think; just pick the
latest of:

http://dev.laptop.org/pub/firmware/libertas/

I checked on Extranet and I do not have access to any CF8385 firmware
later than 5.0.21.p3 (and thus cannot commit it to linux-firmware).

Dan


