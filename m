Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49269 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbcGRTQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:16:00 -0400
Message-ID: <1468869356.2944.5.camel@sipsolutions.net> (sfid-20160718_211604_265748_95FC39D3)
Subject: Re: [PATCH v2] cfg80211: Allow differnt beacon interval if driver
 supports
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Date: Mon, 18 Jul 2016 21:15:56 +0200
In-Reply-To: <9831c426-ae04-a85f-9173-bcea30c489d7@broadcom.com> (sfid-20160718_211359_195109_EC0150EB)
References: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com>
 <1468868209.2944.1.camel@sipsolutions.net>
	 <9831c426-ae04-a85f-9173-bcea30c489d7@broadcom.com>
	 (sfid-20160718_211359_195109_EC0150EB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-07-18 at 21:13 +0200, Arend Van Spriel wrote:
> 
> On 18-7-2016 20:56, Johannes Berg wrote:
> > On Mon, 2016-07-18 at 19:23 +0530, Purushottam Kushwaha wrote:
> > > Driver may allow support for different beacon interval on virtual
> > > interfaces.
> > > Allow if such support is advertised by driver. This adds new
> > > ext_feature as NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.
> > 
> > We have NL80211_IFACE_COMB_STA_AP_BI_MATCH in interface
> > combinations,
> > perhaps it would make sense to also put this flag there?
> 
> Hi Johannes,
> 
> Was looking at the same thing. The description of that flag was a bit
> unclear to me.
> 
> """
>  * @beacon_int_infra_match: In this combination, the beacon intervals
>  *      between infrastructure and AP types must match. This is
> required
>  *      only in special cases.
> """
> 
> It is not explicitly stated but it implies the STA vif is connected,
> right.

Yes.

Forget this flag. I don't think any driver sets it - it was a hack for
iwldvm. I also don't think any userspace cares about it, and it likely
never really worked. What if the STA vif reconnects anyway?

I was merely pointing this out wrt. the grouping and where to put
something new.

> Probably going off-topic here, but I am also wondering about the
> use-case of the above patch. I have been looking at M-BSS. Toward
> user-space these are AP interfaces, but like described in
> hostapd.conf
> example a number of AP configuration items are required to be equal.
> Now
> we also have chipsets with two 802.11 cores and on each an AP could
> be
> setup with independent beacon interval. So to make the distinction
> would
> it make sense to introduce MBSS_AP iftype? Or does AP_VLAN cover the
> MBSS use-case?
> 

I don't think AP_VLAN does, but isn't a mesh portal simply a mesh point
interface and an AP interface?

johannes
