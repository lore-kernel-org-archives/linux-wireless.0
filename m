Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:11453 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYFIRyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 13:54:23 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2196761wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 10:54:21 -0700 (PDT)
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213033579.22220.8.camel@johannes.berg>
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)  <1212997265.698.55.camel@johannes.berg>
	 <1213029086.5974.21.camel@brick>
	 (sfid-20080609_183129_796413_B211C17A)  <1213032085.22220.1.camel@johannes.berg>
	 <1213033412.5974.28.camel@brick>
	 (sfid-20080609_194341_412413_70F0E00E)  <1213033579.22220.8.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 10:54:19 -0700
Message-Id: <1213034059.5974.33.camel@brick> (sfid-20080609_195426_396927_1EA7AAE1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 19:46 +0200, Johannes Berg wrote:
> On Mon, 2008-06-09 at 10:43 -0700, Harvey Harrison wrote:
> > On Mon, 2008-06-09 at 19:21 +0200, Johannes Berg wrote:
> > > On Mon, 2008-06-09 at 09:31 -0700, Harvey Harrison wrote:
> > > > 
> > > > As this helper only checks for the one bit being set, I chose _has_.
> > > 
> > > Hmm. As far as I can tell, it checks that the frame is a QoS controlled
> > > data frame. Hence, it explicitly checks that it _is_ a data frame and
> > > _has_ the QoS bit, but in 802.11 lingo I think that means it _is_ a
> > > "data+qos" frame.
> > > 
> > 
> > Well, it's not a big deal...what name do you want and I'll change it.
> 
> I'd prefer _is_qos_data because _data_has_qos makes me think I have to
> ensure that the frame is a data frame before passing it in, i.e. it will
> return undefined results for a management/control frame.

Well, the way the other functions of the same type:

ieee80211_ctl_is_ack
ieee80211_mgmt_is_beacon

check not only that the ftype is exactly ctl/mgmt and that it is of
stype ack/beacon.  I chose ieee80211_data_has_qos because it checks
the ftype _is_ data _and_ that it _has_ qos included.  I think my
naming is more consistent with this.

Do you still think it should be changed?

Cheers,

Harvey

