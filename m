Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47351 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbbFQLBv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 07:01:51 -0400
Message-ID: <1434538909.1884.39.camel@sipsolutions.net> (sfid-20150617_130154_729165_1E60D297)
Subject: Re: [PATCH V3] mac80211: wowlan: suspend: Fix power save state
 stuck in ACTIVE caused by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 17 Jun 2015 13:01:49 +0200
In-Reply-To: <CABPxzYL0rnht72K1fLcpyjC=eOM4nHxzHQRpD47iE6J=J-3sOg@mail.gmail.com> (sfid-20150617_122259_357472_BB8516CF)
References: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1434530870.1884.12.camel@sipsolutions.net>
	 <CABPxzYL0rnht72K1fLcpyjC=eOM4nHxzHQRpD47iE6J=J-3sOg@mail.gmail.com>
	 (sfid-20150617_122259_357472_BB8516CF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 15:52 +0530, Krishna Chaitanya wrote:

> > I still don't like it. I also don't believe that what you're writing is
> > actually true. The only problem I can see is that it leads to higher
> > power consumption *while the system is suspended* - at resume time we
> > send a packet and thus kick the timers...
> "If" we send a packet, but until them the system will still be
> active.

But we *always* send a packet:

ieee80211_reconfig:
...
        /*
         * The sta might be in psm against the ap (e.g. because
         * this was the state before a hw restart), so we
         * explicitly send a null packet in order to make sure
         * it'll sync against the ap (and get out of psm).
         */
        if (!(local->hw.conf.flags & IEEE80211_CONF_PS)) {
                list_for_each_entry(sdata, &local->interfaces, list) {
                        if (sdata->vif.type != NL80211_IFTYPE_STATION)
                                continue;
                        if (!sdata->u.mgd.associated)
                                continue;

                        ieee80211_send_nullfunc(local, sdata, 0);
                }
        }



Then again, you're talking about WoWLAN, but then ...

johannes

