Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3BTIZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 03:25:14 -0500
Message-ID: <1361348702.8629.0.camel@jlt4.sipsolutions.net> (sfid-20130220_092518_726364_E30FED57)
Subject: Re: [RFC] mac80211: make CONFIG_MAC80211_MESH=y default
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Wed, 20 Feb 2013 09:25:02 +0100
In-Reply-To: <CAGRGNgWLHTV2T9WFAGtB8Wz4=zNcrCUkHVFJX5Q=kdbFLTSKOQ@mail.gmail.com> (sfid-20130220_020103_480201_41342364)
References: <1361042551-15598-1-git-send-email-thomas@cozybit.com>
	 <1361197194.8555.17.camel@jlt4.sipsolutions.net>
	 <CAGRGNgWLHTV2T9WFAGtB8Wz4=zNcrCUkHVFJX5Q=kdbFLTSKOQ@mail.gmail.com>
	 (sfid-20130220_020103_480201_41342364)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

> > What might be interesting is for drivers to somehow indicate they
> > support it? But you wouldn't necessarily want drivers to "select MESH",
> > so it'd probably have to be something like not allowing mesh to be
> > turned on if no driver is turned on that has it? But that makes it
> > complicated again, so it's all probably not worth it.
> 
> IIRC, the standard way to do things like that is something like:
> 
> config HAVE_MESH_DRIVER
>     default n
> 
> config RANDOM_DRIVER
>     select HAVE_MESH_DRIVER
> 
> config MESH
>     default y if HAVE_MESH_DRIVER
> 
> That way it's default on if drivers are selected which have mesh
> support but still user selectable (either to disable or if out-of-tree
> drivers want it).

Ah, yes, I was thinking something like that but forgot about the
"default ... if" syntax and gave up trying to reproduce it with "select"
and "depends on" :-)

That seems like the best of both worlds? Thomas?

johannes

