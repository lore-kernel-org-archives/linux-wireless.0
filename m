Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59830 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759212AbcCDJjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 04:39:09 -0500
Message-ID: <1457084342.28365.140.camel@coelho.fi> (sfid-20160304_103919_519041_D6F73073)
From: Luca Coelho <luca@coelho.fi>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 04 Mar 2016 11:39:02 +0200
In-Reply-To: <20160304091528.GA3666@jouni.qca.qualcomm.com>
References: <1456517569-27235-1-git-send-email-jouni@qca.qualcomm.com>
	 <1457078876.28365.124.camel@coelho.fi>
	 <20160304091528.GA3666@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 1/3] cfg80211: Allow a scan request for a specific
 BSSID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-03-04 at 09:15 +0000, Malinen, Jouni wrote:
> On Fri, Mar 04, 2016 at 10:07:56AM +0200, Luca Coelho wrote:
> > On Fri, 2016-02-26 at 22:12 +0200, Jouni Malinen wrote:
> > > This is an optimization and as such, it is acceptable for some of
> > > the
> > > drivers not to support the mechanism. If not supported, the
> > > wildcard
> > > BSSID will be used and more responses may be received.
> > 
> > Receiving more responses than what we asked for is always possible,
> > because we don't filter out other things we may receive at the same
> > time.  It's like requesting for a specific SSID, it just means that
> > the
> > SSID will be used in the probe requests, but it doesn't guarantee
> > that
> > other results will not be returned.
> 
> Sure. This "more responses" is referring to not being able to get the
> benefit from saved airtime; not on what we might add into the
> cfg80211
> BSS table. We don't even have an explicit mechanism for reporting
> results from a single scan iteration.

Right.


> > > diff --git a/include/uapi/linux/nl80211.h
> > > b/include/uapi/linux/nl80211.h
> > > @@ -322,7 +322,9 @@
> > >   * @NL80211_CMD_GET_SCAN: get scan results
> > >   * @NL80211_CMD_TRIGGER_SCAN: trigger a new scan with the given
> > > parameters
> > >   *	%NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether
> > > to send the
> > > - *	probe requests at CCK rate or not.
> > > + *	probe requests at CCK rate or not. %NL80211_ATTR_MAC
> > > can be used to
> > > + *	specify a BSSID to scan for; if not included, the
> > > wildcard BSSID will
> > > + *	be used.
> > 
> > Maybe you could be explicit here about the possibility of receiving
> > more results than requested?
> 
> Which "receiving" are you referring to here? I don't see much point
> in
> documenting the airtime optimization here and as far as receiving
> results through nl80211 is concerned, the only option for it today is
> to
> use NL80211_CMD_GET_SCAN and that returns the current contents of the
> BSS table rather than returns from any specific scan, so I'm not sure
> what exactly you would like to add here.
> 
> I was going to note that this is similar to how
> NL80211_ATTR_SCAN_SSIDS
> is documented, but actually, that one is not mentioned at all with
> NL80211_CMD_TRIGGER_SCAN currently.. Nor is the details of what
> NL80211_CMD_GET_SCAN returns.

Okay, fair enough.  It's true that understanding how the scan API works
from the nl80211 documentation is pretty hard today.  That's what I
wanted to address, but this should probably be another task in itself.
;)

Reviewed-by: Luca Coelho <luciano.coelho@intel.com>

--
Cheers,
Luca.
