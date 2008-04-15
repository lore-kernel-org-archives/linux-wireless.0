Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:6400 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbYDOPOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 11:14:32 -0400
Received: by nf-out-0910.google.com with SMTP id g13so544807nfb.21
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2008 08:14:30 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 hardware encryption
Date: Tue, 15 Apr 2008 17:17:54 +0200
Cc: Tomas Winkler <tomasw@gmail.com>, linux-wireless@vger.kernel.org
References: <200804051931.58895.IvDoorn@gmail.com> <200804142307.48550.IvDoorn@gmail.com> <1208255742.3502.5.camel@johannes.berg>
In-Reply-To: <1208255742.3502.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804151717.54920.IvDoorn@gmail.com> (sfid-20080415_161451_968540_4DACEEBA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 April 2008, Johannes Berg wrote:
> 
> > > Not sure what was intention for hw_key_idx but currently there are assignment
> > > from key->conf.keyidx to hw_key_idx and visa versa.  keyidx is used
> > > for 802.11 key index [1..4]
> > > So it's quit risky to use it for something else
> > 
> > That souds like a bug in mac80211 then. hw_key_idx is for internal use for the driver,
> > and mac80211 should never expect the driver to set it to a particular value.
> 
> Yeah, that'd be a bug, and I can't find any such assignment. In fact,
> mac80211 doesn't contain any assignment to hw_key_idx or to a 1-4
> key_idx from hw_key_idx. Never mind the fact that the tx_control member
> could be called hw_key_idx as well...
> 
> In any case, for the problem at hand, I wouldn't mind increasing
> hw_key_idx to a u16 all the way through, or pass the key_conf pointer
> instead.

I'll create a patch that changes it to the key_conf pointer then,
that sounds like the safest option to allow changes to key_conf later.

Note that this change (either adding the key_conf pointer or the hw_key_idx to u16)
will cause ieee80211_tx_control to exceed the 48 bytes. So that will make it
harder to move it into the skb->cb array later.

Ivo
