Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:40997 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933700AbbDJOQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 10:16:34 -0400
Date: Fri, 10 Apr 2015 17:16:30 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
 5.2 GHz band
Message-ID: <20150410141630.GA24572@w1.fi> (sfid-20150410_161637_960021_AFBA6A6A)
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
 <552400F4.5010701@candelatech.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com>
 <20150409073525.GA21000@w1.fi>
 <1428662388.1890.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428662388.1890.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 10, 2015 at 12:39:48PM +0200, Johannes Berg wrote:
> On Thu, 2015-04-09 at 10:35 +0300, Jouni Malinen wrote:
> > As far as
> > hwsim is concerned, I'm already using it to verify the negotiation part
> > for this (see ap_vht_on_24ghz test case).
> 
> Oh, I guess I can't apply this patch then. But perhaps we should make
> this an optional capability so we can create a new virtual radio
> with/without it.

Well.. It did not look like this patch on its own would actually break
the test since there is no reliable way of indicating support for this
special case nor really any part in the test to verify that the special
TX rates were used (rate control does not even support them for hwsim).

> > The main remaining question
> > for cfg80211/nl80211 is on whether we can come up with a clean way of
> > advertising driver capability for doing this.
> 
> I'm not even sure what the question really is. Really you want just high
> MCSes, but what should happen OTA? Is interoperability even *desired*,
> given that it will never be tested?

For now, it looks like there is interoperability between vendors as long
as there is agreement on which vendor specific extensions to use for
advertising it. hostapd has an implementation that matches the one used
by number of Broadcom devices. I'd say that interoperability is desired.
I'm not sure what you mean with interoperability never being tested,
though. There may not be a formal certification program for this, but
this has been tested.

-- 
Jouni Malinen                                            PGP id EFC895FA
