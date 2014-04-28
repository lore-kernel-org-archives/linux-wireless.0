Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbaD1Pqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 11:46:44 -0400
Message-ID: <1398699982.4132.1.camel@jlt4.sipsolutions.net> (sfid-20140428_174647_065920_FAF317DA)
Subject: Re: [PATCH 2/3] mac80211: Support dynamic AP mode channel width
 changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 28 Apr 2014 17:46:22 +0200
In-Reply-To: <CA+BoTQ=gP49PDuyYovQmc-jtFwKN6JDOToSsT20ssnJZGaqieQ@mail.gmail.com> (sfid-20140428_105724_959492_6ACA3997)
References: <20140428082225.GA15459@jouni.qca.qualcomm.com>
	 <CA+BoTQ=gP49PDuyYovQmc-jtFwKN6JDOToSsT20ssnJZGaqieQ@mail.gmail.com>
	 (sfid-20140428_105724_959492_6ACA3997)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-28 at 10:57 +0200, Michal Kazior wrote:

> > +static int ieee80211_set_ap_channel(struct wiphy *wiphy,
> > +                                   struct net_device *dev,
> > +                                   struct cfg80211_chan_def *chandef)
> > +{
> > +       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> > +       int ret;
> > +       u32 changed = 0;
> > +
> 
> Shouldn't interface combinations be verified here? What if there was a
> bandwidth upgrade (after a downgrade) but in the meantime a vif with a
> to-be incompatible chandef was brought up?

Yeah that seems like a potential issue.

> I think the existing usage
> of ieee80211_vif_change_bandwidth() in ieee80211_config_bw() already
> suffers from this problem or am I missing something?

That sounds like you're arguing it should be fixed in a separate patch
to ieee80211_vif_change_bandwidth()? :)

johannes

