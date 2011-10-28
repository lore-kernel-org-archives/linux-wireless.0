Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab1J1IBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 04:01:25 -0400
Subject: RE: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not
 wait for ACK
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20111021142322.229128720@sipsolutions.net>
	 ( sfid-20111021_162510_209354_8FBBB6EB) <1319743973.32221.4.camel@jlt3.sipsolutions.net>
	 <400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 10:01:20 +0200
Message-ID: <1319788880.3914.4.camel@jlt3.sipsolutions.net> (sfid-20111028_100128_417197_BD2DC968)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 00:48 -0700, Arend Van Spriel wrote:
> > Sent: donderdag 27 oktober 2011 21:33
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > For probe responses it can be useful to not wait for ACK
> > to save airtime, so allow userspace to request not waiting
> > with a new nl80211 flag.
> > 
> > Since mac80211 needs to be updated for the new function
> > prototype anyway implement it right away -- it's just a
> > few lines of code.

> I would expect this to affect the duration field in the
> 802.11 header to indicate the shorter use of the medium.
> Going through your patch I am not sure this is done.

Hmmm. You're right, but that's something we already need to fix in many
cases -- as the duration field is overwritten by most hardware these
days, we haven't always maintained it very well.

Your driver seems to be the exception to this -- maybe you can look into
fixing up the duration calculations? Also for 11n which isn't taken into
account at all today.

johannes

