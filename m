Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50201 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3FEHKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 03:10:55 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
Date: Wed, 5 Jun 2013 10:10:50 +0300
Message-ID: <2109265.XIVW7kjjZK@lx-vladimir> (sfid-20130605_091109_057489_521DEE70)
In-Reply-To: <20130604183023.GB6172@jouni.qca.qualcomm.com>
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com> <2442077.aHiBPHBLmq@lx-vladimir> <20130604183023.GB6172@jouni.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 04, 2013 09:30:23 PM Jouni Malinen wrote:
> On Tue, Jun 04, 2013 at 07:47:20PM +0300, Vladimir Kondratiev wrote:
> > I am a bit confused. I supposed that if devices A and B (not in a group yet)
> > try to discover each other, it works like the following
> > 
> > A ---- probe-req  ---> B (now B knows A)
> > A <--- probe-resp ---- B (now A knows B)
> 
> This depends on what exactly you mean with "discover". Sure, it is known
> that there is a P2P peer in the environment if a Probe Request frame
> with P2P IE is received from it. However, that does not necessarily mean
> we know enough of that peer to initiate new P2P operations.
> 
> > But if device is discovered by probe-resp only, it mean this should be
> > 
> > A ---- probe-req  ---> B
> > A <--- probe-resp ---- B (now A knows B)
> > A <--- probe-req  ---- B
> > A ---- probe-resp ---> B (now B knows A)
> 
> Probe Response frames include more information about the peer and that
> allows wpa_supplicant to complete the peer entry. This is the point when
> the peer is fully known and indicated to upper layers. The Probe Request
> frame RX case is just used internally within wpa_supplicant. (For
> completeness, number of other frames, i.e., P2P Action frames, can also
> complete the P2P peer entry, so this does not need to be Probe
> Response).

Thanks for clarification. So, I see that wpa_s wants all probe responses and
may want either all or selected probes, depending on the driver's capability
(NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD) and its own reasons.

Then, I think it would be appropriate to say following in the comment for
start_p2p_find (no code changes, it is only expectations for the friver behavior):

---cut---
While performing P2P discovery, driver should report all received
probe-request and probe-response frames via cfg80211_rx_mgmt,
accordingly to the rx mgmt filter, as set by mgmt_frame_register().
When reporting probes, driver/firmware may do its best to filter out
probes that would not be replied with probe-resp accordingly to the
P2P rules for active device configuration.
---cut---

This makes possible for wpa_s to choose exact configuration, and good
power saving is possible provided firmware answer probes.

Comments?

Thanks, Vladimir
