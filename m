Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2FMIJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 04:09:58 -0400
Message-ID: <1339574996.4519.9.camel@jlt3.sipsolutions.net> (sfid-20120613_101002_916437_D75B84F0)
Subject: Re: [PATCH 3.5] mac80211: stop polling in disassociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	david.spinadel@intel.com
Date: Wed, 13 Jun 2012 10:09:56 +0200
In-Reply-To: <1339574896.4519.8.camel@jlt3.sipsolutions.net> (sfid-20120613_100827_682523_18C8085C)
References: <1339570296.4519.7.camel@jlt3.sipsolutions.net>
	 <CAB3XZEf++ayd3s1v61Z9BAeDEFVcehddaAPVabenm25Fhf_6Rw@mail.gmail.com>
	 (sfid-20120613_100002_998594_9796B48B) <1339574896.4519.8.camel@jlt3.sipsolutions.net>
	 (sfid-20120613_100827_682523_18C8085C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 10:08 +0200, Johannes Berg wrote:
> On Wed, 2012-06-13 at 11:00 +0300, Eliad Peller wrote:
> 
> > > @@ -1329,6 +1329,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
> > >        u32 changed = 0;
> > >        u8 bssid[ETH_ALEN];
> > >
> > > +       ieee80211_stop_poll(sdata);
> > > +
> > >        ASSERT_MGD_MTX(ifmgd);
> > 
> > it doesn't matter much, but maybe better add the call after the
> > function "prologue" (lockdep, WARN_ONs, ...)?
> 
> I think we shouldn't do it after the warnings since those affect the
> control flow. OTOH, they should never happen ...

I'll change it, makes it look better :-)

johannes

