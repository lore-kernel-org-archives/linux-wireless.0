Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab1EMXNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 19:13:14 -0400
Received: by fxm17 with SMTP id 17so2061821fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 16:13:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: WPA in ad-hoc mode with carl9170
Date: Sat, 14 May 2011 01:13:09 +0200
Cc: linux-wireless@vger.kernel.org
References: <20110513160113.GA14293@zenon.in.qult.net> <201105132231.48232.chunkeey@googlemail.com> <20110513222141.GA11200@zenon.in.qult.net>
In-Reply-To: <20110513222141.GA11200@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105140113.09867.chunkeey@googlemail.com> (sfid-20110514_011317_944661_24EB9012)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 14 May 2011 00:21:41 Ignacy Gawedzki wrote:
> On Fri, May 13, 2011 at 10:31:47PM +0200, thus spake Christian Lamparter:
> > Note: there's a special bit [RX_MAC_CONTROL - bit 6] which instructs the key
> > cache controller to do the "key security settings" lookup with addr2 for all
> > bc/mc frames. If we enable this bit and modify carl9170_op_set_key to set the
> > per station gtk correctly [i.e.: use sta->addr as MAC and put the keys into
> > the per-sta space [0-63?]] we should be able to enable PER_STA_GTK...
> > although the driver will be restricted to a single vif [I think].
> 
> If I understand correctly, by PER_STA_GTK you mean a different encryption key
> for each one-hop neighbor.  It happens to be unnecessary in my case as one
> "ad-hoc-global" encryption key would be enough.
yes, but AFAIK that's not how it works. There's no "global" encryption key see
802.11-2007 8.4.9 RSNA key management in an IBSS: 
"Each Authenticator generates its own GTK and uses either the 4-Way Handshake
or Group Key Handshake to transfer the GTK to other STAs with whom it has
completed a 4-Way Handshake."
 
Regards,
	Chr
