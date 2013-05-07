Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab3EGQff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 12:35:35 -0400
Message-ID: <1367944528.8328.64.camel@jlt4.sipsolutions.net> (sfid-20130507_183543_773490_C3D73E03)
Subject: Re: [PATCH v6] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Tue, 07 May 2013 18:35:28 +0200
In-Reply-To: <3561208.okpkftdEFW@lx-vladimir>
References: <1367235610-10375-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1367235610-10375-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1367935836.8328.45.camel@jlt4.sipsolutions.net>
	 <3561208.okpkftdEFW@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-07 at 19:27 +0300, Vladimir Kondratiev wrote:

> > starting the p2p find? I mean, it seems that should implicitly enable
> > the filter? Or is there a reason you think this command would be useful
> > _without_ enabling the filter??
> 
> Packet filtering already managed by the wpa_sup; and is kind of orthogonal
> to the p2p flows. Yes, wpa_sup need to assemble reasonable combinations to
> make whole system work. I want wpa_sup to take care of packet filtering;
> it deals with filtering within the cfg80211_rx_mgmt().
> 
> wpa_sup may have its own idea for filtering, it may be more restrictive
> then just pass all probe-request and probe-response frames.
> 
> Technically it is possible to call cfg80211_mlme_register_mgmt and
> cfg80211_mlme_unregister_socket, but then I need to save nlportid, and it
> becomes more complicated then it is when wpa_sup takes care of filtering.

Yeah, never mind. That isn't really filtering but the reporting, which
may be tied to filtering internally to the driver (but that makes sense,
if nobody cares about the frame it can drop them.)

> > Please clarify whether or not this should be called when a stop is
> > explicitly requested by userspace. I don't think it's all that useful,
> > and if required maybe cfg80211 should send the event itself instead of
> > having the driver do it?
> 
> There may be delay between request from wpa_sup and actual end of p2p find.
> I want wpa_sup to know when p2p find actually get finished; for timing/race
> reasons.

Yes, but I think you should then document that the driver must call this
even when requested by cfg80211 to stop.

johannes

