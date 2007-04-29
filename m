Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:21982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbXD2JVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 05:21:49 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1099189uga
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2007 02:21:47 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 3/4] mac80211: document requirement for atomicity of callbacks
Date: Sun, 29 Apr 2007 11:20:33 +0200
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <20070429023215.40c2aea7@logostar.upir.cz> <20070429023345.43e09faf@logostar.upir.cz> <200704291115.43657.mb@bu3sch.de>
In-Reply-To: <200704291115.43657.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704291120.33910.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 April 2007 11:15, Michael Buesch wrote:
> On Sunday 29 April 2007 02:33:45 Jiri Benc wrote:
> > @@ -631,7 +632,8 @@ struct ieee80211_ops {
> >  	 * we need to combine the multicast lists and flags for multiple
> >  	 * virtual interfaces), they cannot assign set_multicast_list.
> >  	 * The parameters here replace dev->flags and dev->mc_count,
> > -	 * dev->mc_list is replaced by calling ieee80211_get_mc_list_item. */
> > +	 * dev->mc_list is replaced by calling ieee80211_get_mc_list_item.
> > +	 * Must be atomic. */
> >  	void (*set_multicast_list)(struct ieee80211_hw *hw,
> >  				   unsigned short flags, int mc_count);
> 
> Why is that required to be atomic, actually?

Because set_multicast_list callback inside the netdevice structure
is also called atomically. So if this should be moved out of atomic context
either the kernel shouldn't call it from atomic context or mac80211 needs to
reschedule the call to the driver.

Ivo
