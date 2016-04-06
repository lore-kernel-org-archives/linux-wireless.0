Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:3025 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933798AbcDFKBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 06:01:47 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Subject: RE: [PATCHv3 RESEND 01/11] cfg80211: add start / stop NAN commands
Date: Wed, 6 Apr 2016 10:01:42 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EAA5605@hasmsx107.ger.corp.intel.com> (sfid-20160406_120151_081444_D32E227C)
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
 <20160406095528.GD10595@jouni.qca.qualcomm.com>
In-Reply-To: <20160406095528.GD10595@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Tue, Mar 29, 2016 at 12:34:59PM +0300, Emmanuel Grumbach wrote:
> > This allows user space to start/stop NAN interface.
> > A NAN interface is like P2P device in a few aspects: it doesn't have a
> > netdev associated to it.
> > Add the new interface type and prevent operations that can't be
> > executed on NAN interface like scan.
> 
> What is the need for this new NAN interface from the view point of
> supporting NAN discovery?

I guess you can ask the same question for P2P device. They are both
very similar. No traffic, discovery only. So all the reasons to have a P2P
device interface apply here as well.

> Are you planning to use the same iface type
> eventually for supporting data traffic over NAN interface as well?

We don't really know yet. The plan is to have another interface type.
Probably one instance per Nan Data Path or the interface type.

> 
> > + * @start_nan: Start the NAN interface.
> > + * @stop_nan: Stop the NAN interface.
> 
> >  struct cfg80211_ops {
> > +	int	(*start_nan)(struct wiphy *wiphy, struct wireless_dev
> *wdev,
> > +			     struct cfg80211_nan_conf *conf);
> > +	void	(*stop_nan)(struct wiphy *wiphy, struct wireless_dev
> *wdev);
> 
> And similarly from 4/11:
> +	int	(*nan_change_conf)(struct wiphy *wiphy,
> +				   struct wireless_dev *wdev,
> +				   struct cfg80211_nan_conf *conf,
> +				   u32 changes);
> 
> There is no matching cookie (such as transaction id) in these requests to the
> driver, are you expecting synchronous response from the driver for these
> requests? Or would some kind of event after the operation has been
> completed be possible?

Yes - these are expected to be synchronous since they don't involve network
transactions. Does your solution require this operation to be asynchronous? I
find a bit weird to make a local operation asynchronous though.

> 
> --
> Jouni Malinen                                            PGP id EFC895FA
