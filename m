Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36011 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbbAGMzQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 07:55:16 -0500
Message-ID: <1420635300.3407.5.camel@sipsolutions.net> (sfid-20150107_135521_682861_E85EFEF9)
Subject: Re: [PATCH] cfg80211: do not check for carrier during
 start_radar_detect
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Avinash Patil <patila@marvell.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 07 Jan 2015 13:55:00 +0100
In-Reply-To: <CALhHN=qA7icuY_MNvBebDsOMOkh6hEsWNkrZoGDGsQg+-f6Xog@mail.gmail.com> (sfid-20141201_081337_327722_EAB90EE5)
References: <CBACCFA0AEB13A41977475BCF3E896FC66736E7972@SC-VEXCH2.marvell.com>
	 <CALhHN=qA7icuY_MNvBebDsOMOkh6hEsWNkrZoGDGsQg+-f6Xog@mail.gmail.com>
	 (sfid-20141201_081337_327722_EAB90EE5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-01 at 08:13 +0100, Janusz Dziedzic wrote:

> Seems this patch unlock off-channel CAC (we are connected/ap started
> and detect radar on other channel), but seem mac80211 don't support
> this correctly now.

Come to think of it - I don't believe there's any way to do off-channel
CAC properly since you'd be out of your operating channel for like a
minute - might as well tear down the AP then.

johannes

