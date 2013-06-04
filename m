Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3FDMHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 08:07:43 -0400
Message-ID: <1370347656.8287.15.camel@jlt4.sipsolutions.net> (sfid-20130604_140746_669851_D97DF3AD)
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Tue, 04 Jun 2013 14:07:36 +0200
In-Reply-To: <2446389.or6hSZ58yP@lx-vladimir>
References: <1370328271-9523-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1370328271-9523-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A01ACFCDFB@HASMSX105.ger.corp.intel.com>
	 <2446389.or6hSZ58yP@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > +struct cfg80211_p2p_find_params {
> > 
> > The parameters are missing the listen channel (which is needed to the listen phase).
> 
> There are n_channels and channels that define set of social channels
> to operate on. It applies to both listen and search.

I don't think that's true -- you only respond on the listen channel but
send probe requests on all the channels?

> > > +	attr = info->attrs[NL80211_ATTR_IE_PROBE_RESP];
> > > +	if (attr) {
> > > +		params.probe_resp_ie_len = nla_len(attr);
> > > +		params.probe_resp_ie = nla_data(attr);
> > > +	}
> > 
> > Is it valid to get Probe response IEs even if the driver did not report support for it?
> 
> One can't do p2p_find if it does not reply to P2P discovery probes.
> It is unrelated to answering probes in AP mode - driver may leave this
> to supplicant.

I think what Ilan is asking is whether you should reject the probe_resp
attribute if NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD isn't set. I'm fine
with just ignoring it (as is done now) though, might make wpa-s easier.

johannes

