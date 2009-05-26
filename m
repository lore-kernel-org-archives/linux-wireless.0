Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44023 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbZEZSWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 14:22:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 11:22:52 -0700
Subject: Re: [ath9k-devel] WMM settings and AP performance
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jeff Hansen <x@jeffhansen.com>
In-Reply-To: <1243361510.2923.10.camel@jm-desktop>
References: <Pine.LNX.4.64.0905251926300.11772@ren>
	 <20090526174640.GC9370@tesla>  <1243361510.2923.10.camel@jm-desktop>
Content-Type: text/plain
Date: Tue, 26 May 2009 21:22:47 +0300
Message-ID: <1243362167.2923.17.camel@jm-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 11:11 -0700, Jouni Malinen wrote:
> On Tue, 2009-05-26 at 10:46 -0700, Luis Rodriguez wrote:
> > On Mon, May 25, 2009 at 06:52:41PM -0700, Jeff Hansen wrote:

> That 25/30 Mbps to 2 Mbps is quite a huge difference and in order for
> QoS parameters to cause something like this, they would need to be
> seriously wrong..

And well, it turns out that the values are indeed seriously wrong.. cw
min and max values are swapped by
b4af0b7ffa5f448bd12f81d2539ee2155919d493.

Jeff: if you have a chance, you could try swapping the cw_max = aCWmin
and cw_min = aCWmax value to actually set cw_max = aCWmax and cw_min =
aCWmin.. In addition to this, I would actually recommend adding the
explicit tx_queue_data* parameters into hostapd.conf even if you are not
using WMM. This should work around the current bug and it will also set
the parameters in a way which are more suitable for an AP (the defaults
set in mac80211 are for station mode). In other words, add following
into hostapd.conf:

tx_queue_data3_aifs=7
tx_queue_data3_cwmin=15
tx_queue_data3_cwmax=1023
tx_queue_data3_burst=0

tx_queue_data2_aifs=3
tx_queue_data2_cwmin=15
tx_queue_data2_cwmax=63
tx_queue_data2_burst=0

tx_queue_data1_aifs=1
tx_queue_data1_cwmin=7
tx_queue_data1_cwmax=15
tx_queue_data1_burst=3.0

tx_queue_data0_aifs=1
tx_queue_data0_cwmin=3
tx_queue_data0_cwmax=7
tx_queue_data0_burst=1.5

- Jouni


