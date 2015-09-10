Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57935 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbIJHWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 03:22:48 -0400
Message-ID: <1441869764.2108.1.camel@sipsolutions.net> (sfid-20150910_092251_568918_2A7419FC)
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Thu, 10 Sep 2015 09:22:44 +0200
In-Reply-To: <20150909164945.GA4062@localhost> (sfid-20150909_184950_812635_9318273F)
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
	 <1440673024-13696-4-git-send-email-me@bobcopeland.com>
	 <87oahc9g9h.fsf@kamboji.qca.qualcomm.com>
	 <87fv2o9cvl.fsf@kamboji.qca.qualcomm.com> <20150909164945.GA4062@localhost>
	 (sfid-20150909_184950_812635_9318273F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-09 at 12:49 -0400, Bob Copeland wrote:
> On Wed, Sep 09, 2015 at 12:10:38PM +0300, Kalle Valo wrote:
> > > I did a quick smoke test and saw the splat below. It's this 
> > > warning from
> > > cfg80211:
> > > 
> > > 			/*
> > > 			 * Don't advertise an unsupported type
> > > 			 * in a combination.
> > > 			 */
> > > 			if (WARN_ON((wiphy->interface_modes & 
> > > types) != types))
> > > 				return -EINVAL;
> 
> OK, this happens when mesh is configured out (we mask off the mesh
> interface_modes internally but not the types).  Sent an updated 
> version with appropriate ifdefs added.

Yeah this is an unfortunate quirk in the APIs ... I think adding the
ifdefs to the driver is the best thing to do.

johannes
