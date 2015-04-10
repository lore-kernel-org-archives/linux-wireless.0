Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58620 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbbDJKj4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 06:39:56 -0400
Message-ID: <1428662388.1890.8.camel@sipsolutions.net> (sfid-20150410_124001_790162_8B4B9A52)
Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
 5.2 GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 10 Apr 2015 12:39:48 +0200
In-Reply-To: <20150409073525.GA21000@w1.fi> (sfid-20150409_093533_890772_95B767FD)
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
	 <552400F4.5010701@candelatech.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com>
	 <20150409073525.GA21000@w1.fi> (sfid-20150409_093533_890772_95B767FD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-04-09 at 10:35 +0300, Jouni Malinen wrote:
> On Wed, Apr 08, 2015 at 06:29:38PM +0000, Peer, Ilan wrote:
> > According to the 802.11ac amendment: "The IEEE 802.11 VHT STA operates in frequency bands below 6 GHz excluding the 2.4 GHz band", so at least the spec. is clear about it. However, I guess it would be possible to enable VHT for 2.4 as well to enjoy some of benefits, but do you see a reason/use case to enable it also for hwsim?
> 
> It does not matter what the standard says on VHT in general; there are
> clearly already products out there that allow some capabilities defined
> in 802.11ac (mainly, 256-QAM) to be used on the 2.4 GHz band.

Sure.

> As far as
> hwsim is concerned, I'm already using it to verify the negotiation part
> for this (see ap_vht_on_24ghz test case).

Oh, I guess I can't apply this patch then. But perhaps we should make
this an optional capability so we can create a new virtual radio
with/without it.

> The main remaining question
> for cfg80211/nl80211 is on whether we can come up with a clean way of
> advertising driver capability for doing this.

I'm not even sure what the question really is. Really you want just high
MCSes, but what should happen OTA? Is interoperability even *desired*,
given that it will never be tested?

johannes

