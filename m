Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3FEHxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 03:53:05 -0400
Message-ID: <1370418780.8920.19.camel@jlt4.sipsolutions.net> (sfid-20130605_095309_615193_752A2BA5)
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Date: Wed, 05 Jun 2013 09:53:00 +0200
In-Reply-To: <2109265.XIVW7kjjZK@lx-vladimir>
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com>
	 <2442077.aHiBPHBLmq@lx-vladimir>
	 <20130604183023.GB6172@jouni.qca.qualcomm.com>
	 <2109265.XIVW7kjjZK@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-05 at 10:10 +0300, Vladimir Kondratiev wrote:

> Then, I think it would be appropriate to say following in the comment for
> start_p2p_find (no code changes, it is only expectations for the friver behavior):
> 

> While performing P2P discovery, driver should report all received
> probe-request and probe-response frames via cfg80211_rx_mgmt,
> accordingly to the rx mgmt filter, as set by mgmt_frame_register().

Well, realistically there will be a frame registration for probe
requests, so stating that is kinda pointless, but OK.

> When reporting probes, driver/firmware may do its best to filter out
> probes that would not be replied with probe-resp accordingly to the
> P2P rules for active device configuration.

This I think should be more specific. "[W]ould not be replied" is
clearly one step, but in an environment where you actually want to
offload the P2P probe responses that is pretty much useless. I'd rather
say something like:

---
When probe response offload it supported, the device should not report
probe requests to the host that it already responded to. It must report
(and therefore not respond to) probe requests that indicate the sending
device is in active PBC mode (specifically, <...add more details...>).
It may also drop invalid or malformed probe requests or ones that would
not be replied to for other reasons.
---

I think this would be a reasonable tradeoff. It means that if a probe
request is actually reported, wpa_supplicant must reply to it, and we
don't have to get into the business of having to decide whether or not
it needs to respond.

Alternatively, we could specify that the device _must_ respond if
offload is supported, and then report it.

However, we need to clearly specify this so that we don't get two
responses, one from the device and one from wpa_s. If there's no way to
specify this, we need to introduce a "reply already sent" flag into the
frame reporting.

johannes

