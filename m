Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:5667 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbXKAAVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 20:21:14 -0400
Received: by wa-out-1112.google.com with SMTP id v27so374820wah
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 17:21:14 -0700 (PDT)
Message-ID: <8e8340660710311721m5a8cae83h743dcfb09ea6bba2@mail.gmail.com> (sfid-20071101_002118_447499_78B52EA1)
Date: Wed, 31 Oct 2007 17:21:13 -0700
From: "Luis Carlos Cobo" <luisca@cozybit.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 4/7] o80211s: (mac80211s) basic mesh interface support
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1193833372.23775.42.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4727de06.0e578c0a.2568.ffffb079@mx.google.com>
	 <1193833372.23775.42.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/07, Dan Williams <dcbw@redhat.com> wrote:
> I'm not sure where this would go (and therefore don't know if you've
> done it or not), but we need to make sure that mesh devices have some
> sort of differentiating attribute in sysfs.  For example, the mac80211
> master device has a "type" of 803 (or something like that) and and the
> STA device has a type of 1.  That probably can't be used here, because
> mesh devices are the same as STA devices from the perspective of an
> application trying to push data to it.  But something else needs to be
> there.  More comments below...

I do not know either what would be the best place (Johannes?) but I am
going to implement specific mesh statistics in sysfs so you could use
that or I could add a specific mesh_iface flag in sysfs.

> > +             IEEE80211_MESH
>
> Just "MESH" doesn't seem quite descriptive enough here...  what exactly
> is this state supposed to mean, that the interface is currently in a
> mesh?

Right. As soon as the interface comes up, it is in a mesh, even if it
is the only node. The mesh id will be the one specified or the
wildcard zero-length mesh id if none was specified. There is no
association or authentication process (actually there is, but in a
per-link basis), so only one mesh state is required. If you prefer
MESH_ON, MESH_ACTIVE or something like that I do not mind changing it.

> /proc/net/wireless was a colossal mistake from a userspace perspective
> since people started screenscraping it, and that's almost _always_ the
> wrong wrong wrong thing to do.

Ok, got the message, getting rid of /proc/net/mesh, will go the
nl80211s/sysfs way.

> the } and else should be on the same line.  I think 'checkpatch.pl'
> should catch this, its in the kernel sources in scripts/.

Thanks for the tip!

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.
