Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0FXGDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 02:03:32 -0400
Subject: RE: [PATCH 1/3] Libertas: cfg80211 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kiran Divekar <dkiran@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C04D64A250E@SC-VEXCH1.marvell.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C04D64A250E@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 08:03:28 +0200
Message-ID: <1277359408.3870.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-23 at 22:38 -0700, Kiran Divekar wrote:

> > +drivers/net/wireless/libertas/cfg.c:1844:13: warning: incorrect type in
> > assignment (different base types)
> > +drivers/net/wireless/libertas/cfg.c:1844:13:    expected unsigned short
> > [unsigned] [usertype] capability
> > +drivers/net/wireless/libertas/cfg.c:1844:13:    got restricted __le16
> > [usertype] <noident>
> > +drivers/net/wireless/libertas/cmdresp.c:106:5: warning: symbol
> > 'lbs_ret_802_11d_domain_info' was not declared. Should it be static?
> > 
> 
> These errors did not show up during my compilation. I will now make
> sure to check with various kernel configs. Any other things should I
> test?

These are sparse errors, you need to

make C=2 CF=-D__CHECK_ENDIAN__ drivers/net/wireless/libertas/

johannes

