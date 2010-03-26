Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab0CZVKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 17:10:47 -0400
Subject: Re: Mesh mode broken since 2.6.34-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: =?UTF-8?Q?=D0=9B=D0=B5=D0=B4=D0=BE=D0=B2=D1=81=D0=BA=D0=B8=D1=85_?=
	 =?UTF-8?Q?=D0=9D=D0=B8=D0=BA=D0=BE=D0=BB=D0=B0=D0=B9_?=
	 =?UTF-8?Q?=D0=92=D0=B0=D0=BB=D0=B5=D1=80=D1=8C=D0=B5=D0=B2=D0=B8=D1=87?=
	<nledovskih@mail.ru>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org,
	"Porsch, Marco" <marco.porsch@siemens.com>,
	"steve.derosier" <steve.derosier@gmail.com>
In-Reply-To: <445f43ac1003261114h55918152rd76be84c97716c99@mail.gmail.com>
References: <20100324120645.5b43757c.nledovskih@mail.ru>
	 <445f43ac1003241816p2d00b79br224a155b605ce7ac@mail.gmail.com>
	 <445f43ac1003261114h55918152rd76be84c97716c99@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 14:10:55 -0700
Message-ID: <1269637855.4342.157.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Javier,

> commit 8404080568613d93ad7cf0a16dfb68459b42a264
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Mon Feb 15 12:46:39 2010 +0200
> 
>     mac80211: reject unhandled action frames
> 
>     802.11-2007 7.3.1.11 mandates that we need to
>     reject action frames we don't handle by setting
>     the 0x80 bit in the category and returning them
>     to the sender, so do that. In AP mode, hostapd
>     is responsible for this.
> 
>     Additionally, drop completely malformed action
>     frames or ones that should've been encrypted as
>     unusable, userspace shouldn't see those.
> 
>     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> After that commit we observe invalid action category codes (0x9e) in
> response to valid peer link open action frames (0x1e) and so no peer
> links are established.  We don't have a fix at this time.

Whooops, good catch, this actually affects mlme.c as well! I'll fix
this, but I'm unlikely to get to it today and am travelling over the
weekend. For reference, the problem is that in rx.c we reject unknown
action frames in ieee80211_rx_h_action(), but the mesh/mlme code only
gets to see the action frames it wants in ieee80211_rx_h_mgmt() which
comes after rx_h_action. The proper fix will probably be to make
ieee80211_rx_h_action() aware of the frames that mesh/mlme wants to
handle it and not reject then.

johannes

