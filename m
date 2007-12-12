Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:46533 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXLLXYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 18:24:01 -0500
Received: by wa-out-1112.google.com with SMTP id v27so692989wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2007 15:23:56 -0800 (PST)
Message-ID: <1ba2fa240712121523h59d919f8k42fe54b992618432@mail.gmail.com> (sfid-20071212_232407_342301_26E8757C)
Date: Thu, 13 Dec 2007 01:23:55 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 ethtool support
Cc: "Michael Buesch" <mb@bu3sch.de>, "Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197481520.6558.140.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197361048.3170.381.camel@debian.sh.intel.com>
	 <200712111350.25522.mb@bu3sch.de>
	 <1197421988.3170.405.camel@debian.sh.intel.com>
	 <200712121148.48716.mb@bu3sch.de>
	 <1197481520.6558.140.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 12, 2007 7:45 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > > Yeah, we can do this also. But the users want a standard way, especially
> > > when there is already such kernel interface and user space tools ready
> > > there. Any chance mac80211 supports ethtool or something similar?
> >
> > You could write a patch.
> > Add a callback to mac80211 that mac80211 uses to register the eeprom
> > ethtool interface.
>
> NACK. Which virtual interface should get this? wmaster sounds like the
> "obvious" candidate but we want to get rid of it ASAP. And the others
> ones are pretty wrong because you can, technically, have a wiphy without
> any virtual interfaces on it.
>
Just a thought. What if all virtual interfaces will quasi implements
it. It doesn't matter if all the interfaces answers the same. Since
these are get only operations the mutual exclusion shouldn't be so
hard. All interfaces will support equally the handlers.  But I'm not
sure about other ethool handlers.
If wmaster goes will be all virtual interfaces equal citizens ?

> Maybe it should live in cfg80211's sysfs...

This is also a viable option

>
> johannes
>
