Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760785Ab2FDPw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 11:52:27 -0400
Message-ID: <1338825141.4512.14.camel@jlt3.sipsolutions.net> (sfid-20120604_175230_665236_F743A0D9)
Subject: Re: [RFC] cfg80211: Fix incompatible interfaces combination
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 04 Jun 2012 17:52:21 +0200
In-Reply-To: <1338824836-2283-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1338824836-2283-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-04 at 21:17 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> *if any interface type is not advertised by the driver
> via ieee80211_iface_combination make sure we will have it
> as a single interface only. lets that we will not add
> an incompatible interface if some other interface is
> already present. we cannot add any other interface,
> if the already present interface is an incompatible
> interface. for example in ath9k we don't advertise ADHOC in
> ieee80211_iface_combination structure in the driver,
> so it can only exist as an single interface

I'm not sure I understand what you're changing here?

> *if the driver is not advertising interface combination just
> return so that we don't break their multivif operation.

Actually, we want to break multivif for drivers that don't advertise it.

johannes

