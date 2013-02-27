Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34003 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3B0MYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 07:24:15 -0500
To: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC] P2P find offload
Date: Wed, 27 Feb 2013 14:24:11 +0200
Message-ID: <3408094.SIuA27EmQ5@lx-vladimir> (sfid-20130227_132419_778216_5846EB15)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Intro:

P2P scan consists of scan and find phases.
Scan is just usual scan.
Find phase consists of search and listen states.
Currently, 'search' state implemented as 'scan'
and 'listen' state implemented as 'remain on channel'

Recently spec for 60GHz band added, defining new procedures.
For 60GHz devices, spec defined search state in the way that can't be
simulated by the scan. On the 60GHz band, device in the 'search' state
transmits specially crafted DMG beacon frames, while in scan state it does
not transmit DMG beacon frames.

GO resolution for 60GHz devices performed based on 'PCP factor' calculated
by certain bits of probe request/response frames. GO negotiation frames are
sent, but used to negotiate the rest of parameters like operational channel.

Proposal:

Enable p2p find phase offload to the driver.
Add methods for the struct cfg80211_ops, like

	int	(*start_p2p_find)(struct wiphy *wiphy,
				  struct cfg80211_p2p_find_params *params);
	void	(*stop_p2p_find)(struct wiphy *wiphy);

where struct cfg80211_p2p_find_params includes info elements
to be added for probe request and probe response frames;
social channels etc.

wpa_supplicant will call these methods through nl80211.

Driver responsible for toggling between search and listen states,
reporting probe request/response frames to the user space.

Driver/firmware may answer to the probe request frames on itself,
in this case probe requests are still reported.

To satisfy requirements for 60GHz band, additional attribute 'pcp_resolution'
shall be added to the reported frames, indicating result of the PCP resolution.
This attribute carries result of PCP factor comparison between probe request
and response, as defined in the spec for 60GHz. It is enum having values
'undefined', 'win' and 'lose'.
For the 2.4GHz band devices, PCP resolution is not used and pcp_resolution
attribute set to 'undefined'

Rationale:

- For all devices, this allows for better time utilization since
there is no need to 'close' each phase and return back to the idle state.

- Option to answer probe request in the driver/firmware allows to use firmware
capabilities.

- Enabler for 60GHz devices.

Comments?

Thanks, Vladimir.

