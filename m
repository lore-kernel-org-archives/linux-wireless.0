Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53112 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753309AbXD2Ktf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 06:49:35 -0400
Date: Sun, 29 Apr 2007 12:49:29 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] mac80211: document requirement for atomicity of  callbacks
Message-ID: <20070429124929.417ef7da@logostar.upir.cz>
In-Reply-To: <200704291115.43657.mb@bu3sch.de>
References: <20070429023215.40c2aea7@logostar.upir.cz>
	<20070429023345.43e09faf@logostar.upir.cz>
	<200704291115.43657.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 29 Apr 2007 11:15:43 +0200, Michael Buesch wrote:
> On Sunday 29 April 2007 02:33:45 Jiri Benc wrote:
> > +	 * Must be atomic. */
> >  	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
> >  		       u8 *addr, struct ieee80211_key_conf *key, int aid);
> 
> I think USB drivers and bcm43xx violate that. We can't easily workaround it
> without doing the operation async.

I know. Unfortunately, it's not easy to fix that in mac80211. I really want
this call not to be atomic and will try to change it later, but it's not a
priority now.

For now, just always return success and complain to dmesg if something goes
wrong during setting of the key in a workqueue.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
