Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaCETiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 14:38:19 -0500
Message-ID: <1394048380.2278.9.camel@dcbw.local> (sfid-20140305_203822_760823_413635B2)
Subject: Re: WEP is not working on libertas drivers.
From: Dan Williams <dcbw@redhat.com>
To: Enric Balletbo Serra <eballetbo@gmail.com>
Cc: david.abd@gmail.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Wed, 05 Mar 2014 13:39:40 -0600
In-Reply-To: <CAFqH_52V8JPROp_cmJHsVEu4s+s20vbkWgL2xykDoJAAScWmVw@mail.gmail.com>
References: <CAFqH_52V8JPROp_cmJHsVEu4s+s20vbkWgL2xykDoJAAScWmVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-05 at 11:30 +0100, Enric Balletbo Serra wrote:
> Hi all,
> 
> Due a customer requirement I need to configure and ad-hoc network with
> wep encryption. This worked fine with a very old kernel (2.6.35) but
> now that we need to update the kernel seems this
> functionality is totally broken. I found some old messages[1] related
> to this without response.
> 
> As I'm totally a newbie with this I would like to know if there is a
> hard reason why this is still not working or the only reason is
> because nobody spent time on this. In that case will be easy implement
> this (some indication?)

This appears to be due to the conversion from the WEXT to cfg80211 a
long time back.  I can confirm that it's broken.

There's a nice comment in ibss.c::lbs_ibss_start_new():

/* TODO: mix in WLAN_CAPABILITY_PRIVACY */

which pretty much means it isn't there.  If you wanted to fix this, what
you'd do is you'd look at priv->wdev->connect_keys, and if that was !
NULL, you'd run through each of the 6 keys and if at least one key was
valid, you'd then set the PRIVACY bit in the beacon.  Then later after
the join was successful, the kernel already calls the functions for
uploading the keys to the driver
(net/wireless/util.c::cfg80211_upload_connect_keys()).

That's if you're *starting* a new adhoc network, which often you need to
do.  Joining an existing adhoc network (if you can see one in scan
results) should already work, unless libertas really really does want
the keys to be set before the join happens.  If that's the case, then
that would be a different fix.

Dan

