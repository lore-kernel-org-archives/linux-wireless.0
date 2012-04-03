Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2DCMGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 08:06:48 -0400
Message-ID: <1333454805.3574.14.camel@jlt3.sipsolutions.net> (sfid-20120403_140651_648547_5B4897F9)
Subject: Re: 802.11ac support
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh <maheshp@posedge.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Chakra Parvathaneni <chakra@posedge.com>
Date: Tue, 03 Apr 2012 14:06:45 +0200
In-Reply-To: <eab3dfdc8ebc87ec08ca64db9f237d90@posedge.com> (sfid-20120402_104501_564453_6BF9F70F)
References: <f17c700977012ada368da4f339b9c639@posedge.com>
	 <1329933458.4657.2.camel@jlt3.sipsolutions.net>
	 <1329937072.4657.4.camel@jlt3.sipsolutions.net>
	 <4F471F40.8060503@posedge.com>
	 <1330070145.3426.8.camel@jlt3.sipsolutions.net>
	 <4F4772AB.9000305@posedge.com>
	 <CAJ-VmomfVCc0oQMjfwsrheC+Z2k3+-czo4F9GeeO=upHiHnQxg@mail.gmail.com>
	 (sfid-20120225_202329_108179_7C3BAD32) <1330205424.3509.5.camel@jlt3.sipsolutions.net>
	 <eab3dfdc8ebc87ec08ca64db9f237d90@posedge.com>
	 (sfid-20120402_104501_564453_6BF9F70F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-02 at 14:07 +0530, Mahesh wrote:

> I had analysed mac80211 code to see what changes are required for 11ac 
> support. Attached word doc describes mac80211 modules in detail and last 
> section describing what changes we need for 11ac. This is a proposal.
> Please review and let me know your opinion.

You really shouldn't try to send word documents to the list, they won't
arrive anyway. Also, it's bad form to send out documents that say
"confidential" all over them ...
Most people also probably don't care about your analysis of what
mac80211 already does.

In any case, here's my list of things I think will/may need to be done
for 11ac in the stack:
 * extend regulatory framework (cfg80211)
 * advertise VHT capabilities (nl80211/cfg80211/mac80211 & each driver)
 * advertise VHT in scan (mac80211)
 * advertise VHT in assoc req (mac80211)
 * advertise VHT in P2P probe responses (wpa_supplicant)
 * advertise VHT in AP/GO mode beacons/probe responses
   (wpa_supplicant/hostapd)
 * handle per-station VHT capa (mac80211, wpa_s)
 * extended CSA (mac80211)
 * VHT transmit power envelope/extended power constraint (mac80211)
 * quiet channels?
 * HT/VHT basic rate handling?
 * neighbor reports?
 * beamforming action frame support? (mac80211)

johannes

