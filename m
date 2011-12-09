Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3919 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1LIJQV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 04:16:21 -0500
Message-ID: <4EE1D1D3.9090505@broadcom.com> (sfid-20111209_101635_943114_717329EA)
Date: Fri, 9 Dec 2011 10:16:03 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Francesco Gringoli" <francesco.gringoli@ing.unibs.it>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Performance of BCM43224 (14e4:4353)
References: <4EE15A4E.1090500@lwfinger.net>
In-Reply-To: <4EE15A4E.1090500@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 01:46 AM, Larry Finger wrote:
> Guys,
> 
> I just added the patches that let brcmsmac use bcma, and tested the TX and RX 
> rates using netperf. The results are
> 
> Driver			RX		TX
> 
> brcmsmac		21.7		6.2
> b43			15.0		6.0
> wl			43.5		73.5
> 
> The AP is running in 802.11n mode and has throughput of 40-60 Mbps in both 
> directions with an RTL8192CE, thus both open-source drivers have room for 
> improvement.
> 
> I am using the following firmware:
> b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
> 
> 
> With b43 and mac80211 debugging turned on, I see a lot of
> 
> wlan13: detected beacon loss from AP - sending probe request
> 
> Larry
> 

Hi Larry

Thanks for trying. I used iperf for my throughput testing. It has two
biderectional flavours: simultaneous (-d) and individual (-r):
-d: 39 Mbps
-r: 65 Mbps

There are some more bcma related patches to be sent out, but I don't
expect that it will change your benchmark results (as mine were similar
if not identical at each commit).

Gr. AvS

