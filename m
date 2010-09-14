Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab0INNNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 09:13:53 -0400
Subject: Re: mesh beacons broken on HEAD for libertas_tf
From: Johannes Berg <johannes@sipsolutions.net>
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikCBPGjNmRxdkgpZdTnHNvcMSOa6g2V-Z3o6bCx@mail.gmail.com>
References: <AANLkTikCBPGjNmRxdkgpZdTnHNvcMSOa6g2V-Z3o6bCx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 15:13:52 +0200
Message-ID: <1284470032.3704.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-10 at 18:23 -0700, Steve deRosier wrote:

> 1. Move the setting of SDATA_STATE_RUNNING to earlier in the function.
>  This is obviously problematic, having to unset it on errors or so on.

Yeah, that's why I did it this way mostly.

> 3. Put an exception to the check in ieee80211_bss_info_change_notify()
> so that if vif->type is mesh, that we don't check the
> SDATA_STATE_RUNNING bit.  Fairly straight forward and I know how to do
> that.

I see you posted a patch for this. I don't think it's a great change,
and I think you may also need to check netif_running() which is true
earlier in the function, but not while the interface is really down.

> 4. Somehow delay the mesh setup from setting up beacons till after the
> ieee80211_do_open() call finishes.  I'm not sure how to accomplish
> this in a sensible way.

That would be best, really. The main issue is that the way mesh is
configured is really sad -- you set parameters before bringing up the
interface and then they take effect. It'd be _much_ nicer if it behaved
like IBSS in cfg80211, so that you can set parameters to "join" a mesh
and then you could "leave" a mesh again without setting the interface
down, etc. Some backward compat code might be needed in cfg80211 so if
you set an interface up while it's already configured, these things take
effect already ...

johannes

