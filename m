Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3FWHAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jun 2013 03:00:50 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: RE: [RFC] P2P find phase offload
Date: Sun, 23 Jun 2013 07:00:46 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A01AD20CB4@HASMSX106.ger.corp.intel.com> (sfid-20130623_090106_699933_0DC57362)
References: <1370358191-7103-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <62351675.buL3FVoAHm@lx-vladimir>
In-Reply-To: <62351675.buL3FVoAHm@lx-vladimir>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Overall, looks like option 2 is more favorable due to the flexibility, and below is an example for where this flexibility might be useful.

The wpa_supplicant has logic to determine if to respond to a probe request or not based on the local device ID and local device types, and will not respond to probe requests if:

1. The probe request contains a device ID IE and the device ID does not match the local one.
2. The probe request contains specific devices types, and the requested device types do not match the local ones.

Based on the p2p_find offload API you defined, the FW/driver will lack the information of the local Device ID and local device types, so in such cases the FW/driver will not know if it should reply to the response or not. 

Obviously, the lacking information could be added to the API, but in its absence, it would be useful to have the flexibility of the flag.

Hope this help a bit,

Ilan.

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Vladimir Kondratiev
> Sent: Wednesday, June 19, 2013 18:26
> To: Johannes Berg
> Cc: linux-wireless@vger.kernel.org; Luis R . Rodriguez; John W . Linville; Jouni
> Malinen
> Subject: [RFC] P2P find phase offload
> 
> Hi,
> 
> In discussion about P2P find phase offload, I see one bit that was not cleared,
> and want to discuss it prior to coding: probe replying policy.
> 
> option 1: all or nothing. If device indicates
> NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD, it should answer all matching
> probes, and wpa_s should never answer probes. If device don't indicate offload,
> it never answer probes and wpa_s do answer all matching probes.
> 
> option 2: flexible. If device indicates
> NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD, it may answer some
> matching probes, and wpa_s should answer ones that device missed for some
> reason. To enable this, add 'flags' parameter to cfg80211_rx_mgmt() saying
> whether frame was replied by device/driver.
> 
> Real question here is whether there are devices that can answer probes, but
> not always.
> If such devices are real, option 2 is better. I know that for 60g, I'd like to add
> some more bits to 'flags' from option 2, so I am biased to this option.
> 
> Comments?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
