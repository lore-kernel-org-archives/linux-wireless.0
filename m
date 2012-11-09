Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2KIIih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 03:38:37 -0500
Message-ID: <1352450346.9238.9.camel@jlt4.sipsolutions.net> (sfid-20121109_093848_878401_4945E353)
Subject: 60 GHz interface types (was: [PATCH v5 1/2] wireless: Driver for
 60GHz card wil6210)
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>, j@w1.fi
Date: Fri, 09 Nov 2012 09:39:06 +0100
In-Reply-To: <1351701417-3140-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1351701417-3140-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1351701417-3140-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-31 at 18:36 +0200, Vladimir Kondratiev wrote:
> Card wil6210 by Wilocity supports operation on the 60GHz band
> 
> This development snapshot supports:
> 
> - STA, PCP and monitor modes

Ok so I have a more fundamental question/comment/issue.

802.11ad obviously distinguishes between a regular BSS, IBSS, and the
new PBSS. We also differentiate between BSS and IBSS in our interface
types, so I have a feeling that maybe we should also differentiate here,
and not re-use the NL80211_IFTYPE_AP/... interface types.

It seems that then we'd also need a PBSS_P2P_CLIENT and PBSS_P2P_GO,
which is a bit odd, but then again we also do that for P2P_CLIENT vs.
normal managed and P2P_GO vs. AP.

I'm not sure if we're ever going to see chipsets that have 60GHz and
2.4/5 GHz combined, and are not going to just register two wiphy's with
the system for that, but if there was then this would certainly help
with interface combinations etc.

Even if there isn't, it could help tools like network-manager not manage
the 60 GHz device (without having to add special checks), which I
suspect is what you'd want? Not really sure though.

Thoughts?

johannes

