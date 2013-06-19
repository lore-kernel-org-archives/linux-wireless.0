Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2176 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab3FSP0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 11:26:14 -0400
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC] P2P find phase offload
Date: Wed, 19 Jun 2013 18:26:11 +0300
Message-ID: <62351675.buL3FVoAHm@lx-vladimir> (sfid-20130619_172639_552853_C18521B2)
In-Reply-To: <1370358191-7103-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1370358191-7103-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In discussion about P2P find phase offload, I see one bit that was not cleared,
and want to discuss it prior to coding: probe replying policy.

option 1: all or nothing. If device indicates NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD, it should
answer all matching probes, and wpa_s should never answer probes. If device don't indicate offload,
it never answer probes and wpa_s do answer all matching probes.

option 2: flexible. If device indicates NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD, it may answer some
matching probes, and wpa_s should answer ones that device missed for some reason. To enable this,
add 'flags' parameter to cfg80211_rx_mgmt() saying whether frame was replied by device/driver.

Real question here is whether there are devices that can answer probes, but not always.
If such devices are real, option 2 is better. I know that for 60g, I'd like to add some more
bits to 'flags' from option 2, so I am biased to this option.

Comments?
