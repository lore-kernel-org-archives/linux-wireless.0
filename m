Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20496 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3FDQrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 12:47:25 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
Date: Tue, 4 Jun 2013 19:47:20 +0300
Message-ID: <2442077.aHiBPHBLmq@lx-vladimir> (sfid-20130604_184728_858908_C61975EC)
In-Reply-To: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com>
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 04, 2013 05:35:30 PM Malinen, Jouni wrote:
> 
> On 6/4/13 5:29 PM, "Johannes Berg" <johannes@sipsolutions.net> wrote:
> 
> >On Tue, 2013-06-04 at 17:03 +0300, Vladimir Kondratiev wrote:
> >
> >> And, probes must be reported to the host in all cases, for wpa_s to
> >>have peer list.
> >> Need to add comment describing this.
> >
> >I don't think that's necessarily true. wpa_s will pre-build a list, but
> >note that it doesn't make those peers as discovered and you can't really
> >do anything with them. As such, I would argue that reporting probe
> >requests ("probes") would be harmful and counter to one potential goal
> >of this patch (powersaving.)
> 
> In general, I'd agree. However, I would like to get information of any
> peer device being in active PBC mode. This would require either getting
> those Probe Request frames or alternatively that being tracked in
> kernel/driver/firmware with some access for wpa_supplicant to fetch
> information of all STAs (list of MAC Address + UUID) that have indicated
> active PBC mode within last 120 seconds.
> 
> - Jouni

I am a bit confused. I supposed that if devices A and B (not in a group yet)
try to discover each other, it works like the following

A ---- probe-req  ---> B (now B knows A)
A <--- probe-resp ---- B (now A knows B)

But if device is discovered by probe-resp only, it mean this should be

A ---- probe-req  ---> B
A <--- probe-resp ---- B (now A knows B)
A <--- probe-req  ---- B
A ---- probe-resp ---> B (now B knows A)


What is the case?

Thanks, Vladimir

