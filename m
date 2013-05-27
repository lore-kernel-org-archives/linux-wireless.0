Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3E0N72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 09:59:28 -0400
Message-ID: <1369663161.14740.13.camel@jlt4.sipsolutions.net> (sfid-20130527_155930_938836_6099C316)
Subject: Re: P2P Device support: how to deal with p2p_no_group_iface option
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jithu Jance <jithu@broadcom.com>
Date: Mon, 27 May 2013 15:59:21 +0200
In-Reply-To: <51A36603.7020403@broadcom.com>
References: <51A09F43.5030004@broadcom.com>
	 <1369645418.8229.17.camel@jlt4.sipsolutions.net>
	 <51A36603.7020403@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-27 at 15:56 +0200, Arend van Spriel wrote:

> > I don't think I'd do either of those. Not creating P2P_DEVICE will
> > simply not work with drivers expecting it, and changing iftype to/from
> > P2P-Device isn't supported since it would delete/create the netdev.
> 
> So should we check that in cfg80211 upon wiphy_register().

Check what?

> > I don't really see much choice but reject (or ignore) this option for
> > drivers using P2P_DEVICE. Why would anyone *really* want P2P operation
> > on wlan0 when another interface can be used?
> 
> In this mac80211_hwsim is a special case. We could make P2P_DEVICE 
> support in mac80211_hwsim optional using module parameter to allow 
> testing both cases.

Yes, that we could do.

johannes

