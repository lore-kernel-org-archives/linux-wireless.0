Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59370
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbXD2MyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 08:54:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 3/4] mac80211: document requirement for atomicity of callbacks
Date: Sun, 29 Apr 2007 14:53:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070429023215.40c2aea7@logostar.upir.cz> <200704291115.43657.mb@bu3sch.de> <20070429124929.417ef7da@logostar.upir.cz>
In-Reply-To: <20070429124929.417ef7da@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704291453.47601.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 April 2007 12:49:29 Jiri Benc wrote:
> On Sun, 29 Apr 2007 11:15:43 +0200, Michael Buesch wrote:
> > On Sunday 29 April 2007 02:33:45 Jiri Benc wrote:
> > > +	 * Must be atomic. */
> > >  	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
> > >  		       u8 *addr, struct ieee80211_key_conf *key, int aid);
> > 
> > I think USB drivers and bcm43xx violate that. We can't easily workaround it
> > without doing the operation async.
> 
> I know. Unfortunately, it's not easy to fix that in mac80211. I really want
> this call not to be atomic and will try to change it later, but it's not a
> priority now.
> 
> For now, just always return success and complain to dmesg if something goes
> wrong during setting of the key in a workqueue.

Ok, I see. But I want to note that this might be more problematic
then just a lost error code. It might race.
For example it might race with the EAPOL KEY authentication stuff.
So I think we must also workaround that by disabling TX queues
until the key configuration request has actually happened
on the device.

-- 
Greetings Michael.
