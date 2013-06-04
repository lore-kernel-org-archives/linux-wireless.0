Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab3FDO3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 10:29:41 -0400
Message-ID: <1370356174.8287.16.camel@jlt4.sipsolutions.net> (sfid-20130604_162951_845190_DD3D3980)
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Tue, 04 Jun 2013 16:29:34 +0200
In-Reply-To: <2224703.CMJXhTQ6XL@lx-vladimir>
References: <1370328271-9523-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <2446389.or6hSZ58yP@lx-vladimir>
	 <1370347656.8287.15.camel@jlt4.sipsolutions.net>
	 <2224703.CMJXhTQ6XL@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-04 at 17:03 +0300, Vladimir Kondratiev wrote:

> And, probes must be reported to the host in all cases, for wpa_s to have peer list.
> Need to add comment describing this.

I don't think that's necessarily true. wpa_s will pre-build a list, but
note that it doesn't make those peers as discovered and you can't really
do anything with them. As such, I would argue that reporting probe
requests ("probes") would be harmful and counter to one potential goal
of this patch (powersaving.)

johannes

