Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:40783 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbbDIHf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 03:35:28 -0400
Date: Thu, 9 Apr 2015 10:35:25 +0300
From: Jouni Malinen <j@w1.fi>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
 5.2 GHz band
Message-ID: <20150409073525.GA21000@w1.fi> (sfid-20150409_093533_890772_95B767FD)
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
 <552400F4.5010701@candelatech.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 08, 2015 at 06:29:38PM +0000, Peer, Ilan wrote:
> According to the 802.11ac amendment: "The IEEE 802.11 VHT STA operates in frequency bands below 6 GHz excluding the 2.4 GHz band", so at least the spec. is clear about it. However, I guess it would be possible to enable VHT for 2.4 as well to enjoy some of benefits, but do you see a reason/use case to enable it also for hwsim?

It does not matter what the standard says on VHT in general; there are
clearly already products out there that allow some capabilities defined
in 802.11ac (mainly, 256-QAM) to be used on the 2.4 GHz band. As far as
hwsim is concerned, I'm already using it to verify the negotiation part
for this (see ap_vht_on_24ghz test case). The main remaining question
for cfg80211/nl80211 is on whether we can come up with a clean way of
advertising driver capability for doing this.

-- 
Jouni Malinen                                            PGP id EFC895FA
