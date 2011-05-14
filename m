Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48064 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab1ENLFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 07:05:13 -0400
Received: by fxm17 with SMTP id 17so2211851fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 04:05:12 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: WPA in ad-hoc mode with carl9170
Date: Sat, 14 May 2011 13:05:06 +0200
Cc: linux-wireless@vger.kernel.org, Stephen.Chen@atheros.com
References: <20110513160113.GA14293@zenon.in.qult.net> <201105140113.09867.chunkeey@googlemail.com> <20110514094102.GA31275@zenon.in.qult.net>
In-Reply-To: <20110514094102.GA31275@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105141305.06659.chunkeey@googlemail.com> (sfid-20110514_130525_492526_E93DB788)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 14 May 2011 11:41:02 Ignacy Gawedzki wrote:
> On Sat, May 14, 2011 at 01:13:09AM +0200, thus spake Christian Lamparter:
> > On Saturday 14 May 2011 00:21:41 Ignacy Gawedzki wrote:
> > > On Fri, May 13, 2011 at 10:31:47PM +0200, thus spake Christian Lamparter:
> > > > Note: there's a special bit [RX_MAC_CONTROL - bit 6] which instructs the key
> > > > cache controller to do the "key security settings" lookup with addr2 for all
> > > > bc/mc frames. If we enable this bit and modify carl9170_op_set_key to set the
> > > > per station gtk correctly [i.e.: use sta->addr as MAC and put the keys into
> > > > the per-sta space [0-63?]] we should be able to enable PER_STA_GTK...
> > > > although the driver will be restricted to a single vif [I think].
> > > 
> > > If I understand correctly, by PER_STA_GTK you mean a different encryption key
> > > for each one-hop neighbor.  It happens to be unnecessary in my case as one
> > > "ad-hoc-global" encryption key would be enough.
> > yes, but AFAIK that's not how it works. There's no "global" encryption key see
> > 802.11-2007 8.4.9 RSNA key management in an IBSS: 
> > "Each Authenticator generates its own GTK and uses either the 4-Way Handshake
> > or Group Key Handshake to transfer the GTK to other STAs with whom it has
> > completed a 4-Way Handshake."
> 
> Okay, I suppose I didn't understand correctly after all.  What you mean by
> PER_STA_GTK is a different *decryption* key per station (one-hop neighbor),
> right?  The encryption key is the GTK and any receiving station supposed to be
> able to decrypt the frames must have gone through the 4-way handshake with the
> sending station somehow.
> 
> In my case, it would be nice to be able to tell the driver to use the
> encryption key for decryption as well and bypass the need to go through the
> handshake.  But I assume this is not something worth implementing if it's not
> there already and not specified by the standard anyway.
Oh, don't let the "RX_MAC_CONTROL" fool you, this is just Atheros' name
for the register. They really say "Setting this bit instructs the Key Cache controller
to send address2 of multicast/broadcast frames to be searched for user and
key security settings". If it would only affect decryption, the would have written
"*RxMac* Key Cache controller" instead... or Stephen, can you comment on this?
[We are talking about Address: 0x1c3c40 - Bit 6] 

Regards,
	Christian
