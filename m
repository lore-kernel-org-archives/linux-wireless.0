Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31340 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3FDOfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 10:35:32 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	qca_vkondrat <qca_vkondrat@qca.qualcomm.com>
CC: "Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
Date: Tue, 4 Jun 2013 14:35:30 +0000
Message-ID: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com> (sfid-20130604_163537_329243_0AA83F3C)
In-Reply-To: <1370356174.8287.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 6/4/13 5:29 PM, "Johannes Berg" <johannes@sipsolutions.net> wrote:

>On Tue, 2013-06-04 at 17:03 +0300, Vladimir Kondratiev wrote:
>
>> And, probes must be reported to the host in all cases, for wpa_s to
>>have peer list.
>> Need to add comment describing this.
>
>I don't think that's necessarily true. wpa_s will pre-build a list, but
>note that it doesn't make those peers as discovered and you can't really
>do anything with them. As such, I would argue that reporting probe
>requests ("probes") would be harmful and counter to one potential goal
>of this patch (powersaving.)

In general, I'd agree. However, I would like to get information of any
peer device being in active PBC mode. This would require either getting
those Probe Request frames or alternatively that being tracked in
kernel/driver/firmware with some access for wpa_supplicant to fetch
information of all STAs (list of MAC Address + UUID) that have indicated
active PBC mode within last 120 seconds.

- Jouni

