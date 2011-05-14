Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:40993 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1ENJlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 05:41:07 -0400
Date: Sat, 14 May 2011 11:41:02 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WPA in ad-hoc mode with carl9170
Message-ID: <20110514094102.GA31275@zenon.in.qult.net> (sfid-20110514_114127_207186_8057641B)
References: <20110513160113.GA14293@zenon.in.qult.net>
 <201105132231.48232.chunkeey@googlemail.com>
 <20110513222141.GA11200@zenon.in.qult.net>
 <201105140113.09867.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201105140113.09867.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 01:13:09AM +0200, thus spake Christian Lamparter:
> On Saturday 14 May 2011 00:21:41 Ignacy Gawedzki wrote:
> > On Fri, May 13, 2011 at 10:31:47PM +0200, thus spake Christian Lamparter:
> > > Note: there's a special bit [RX_MAC_CONTROL - bit 6] which instructs the key
> > > cache controller to do the "key security settings" lookup with addr2 for all
> > > bc/mc frames. If we enable this bit and modify carl9170_op_set_key to set the
> > > per station gtk correctly [i.e.: use sta->addr as MAC and put the keys into
> > > the per-sta space [0-63?]] we should be able to enable PER_STA_GTK...
> > > although the driver will be restricted to a single vif [I think].
> > 
> > If I understand correctly, by PER_STA_GTK you mean a different encryption key
> > for each one-hop neighbor.  It happens to be unnecessary in my case as one
> > "ad-hoc-global" encryption key would be enough.
> yes, but AFAIK that's not how it works. There's no "global" encryption key see
> 802.11-2007 8.4.9 RSNA key management in an IBSS: 
> "Each Authenticator generates its own GTK and uses either the 4-Way Handshake
> or Group Key Handshake to transfer the GTK to other STAs with whom it has
> completed a 4-Way Handshake."

Okay, I suppose I didn't understand correctly after all.  What you mean by
PER_STA_GTK is a different *decryption* key per station (one-hop neighbor),
right?  The encryption key is the GTK and any receiving station supposed to be
able to decrypt the frames must have gone through the 4-way handshake with the
sending station somehow.

In my case, it would be nice to be able to tell the driver to use the
encryption key for decryption as well and bypass the need to go through the
handshake.  But I assume this is not something worth implementing if it's not
there already and not specified by the standard anyway.

-- 
 "The whole problem with the world is that fools and fanatics are
   always so certain of themselves, and wiser people so full of doubts."
                                                 - Bertrand Russell
