Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LPNYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 08:24:18 -0500
Message-ID: <1387200253.4665.32.camel@jlt4.sipsolutions.net> (sfid-20131216_142422_356730_77600D96)
Subject: Re: [PATCH 1/3] mac80211_hwsim: fix duplicate beacons on TSF adjust
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <twpedersen@gmail.com>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 16 Dec 2013 14:24:13 +0100
In-Reply-To: <1387198425.4665.28.camel@jlt4.sipsolutions.net> (sfid-20131216_135353_726110_E7D17A88)
References: <1387142056-21850-1-git-send-email-twpedersen@gmail.com>
	 (sfid-20131215_221521_503492_4ACF474E) <1387198425.4665.28.camel@jlt4.sipsolutions.net>
	 (sfid-20131216_135353_726110_E7D17A88)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 13:53 +0100, Johannes Berg wrote:
> On Sun, 2013-12-15 at 13:14 -0800, Thomas Pedersen wrote:
> > From: Thomas Pedersen <thomas@cozybit.com>
> > 
> > There was some bug when rescheduling the next beacon from
> > the beacon tasklet after adjusting TSF which would cause
> > the beacon timer to trigger twice. Beaconing at "old" TBT
> > (previously scheduled interface TBTT) with new timestamp
> > was incorrect anyway.
> > 
> > Instead, reschedule the beacon straight away when
> > adjusting TSF.
> 
> Applied.

Nope, never mind - this caused the wpa_s test cases to crash the kernel.

johannes

