Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaA0IT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 03:19:28 -0500
Message-ID: <1390810765.4251.0.camel@jlt4.sipsolutions.net> (sfid-20140127_091932_164272_39E841C8)
Subject: Re: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute
 confusion
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Date: Mon, 27 Jan 2014 09:19:25 +0100
In-Reply-To: <CAB3XZEc94pTAMXWPYeWhu7o_YLEnD1_9O035-+YXYiR0Uij28w@mail.gmail.com> (sfid-20140126_095646_302413_1A037FFE)
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEc94pTAMXWPYeWhu7o_YLEnD1_9O035-+YXYiR0Uij28w@mail.gmail.com>
	 (sfid-20140126_095646_302413_1A037FFE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-01-26 at 10:56 +0200, Eliad Peller wrote:

> this means that min-rssi-only sched scan request will be seen as
> req->n_match_sets = 1 with empty SSID?

Yes.

> i don't think that's desirable (at least the current documentation
> assumes n_match_sets=0 for this case).

I don't think that's true? I looked at the drivers that use this and
they all skip empty SSIDs, except the one that I fixed.

johannes

