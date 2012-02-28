Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:60445 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab2B1S7M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 13:59:12 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Sam Leffler <sleffler@google.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 28 Feb 2012 10:58:01 -0800
Subject: RE: [PATCH 6/6] mwifiex: remove BSS entry before specific SSID scan
Message-ID: <477F20668A386D41ADCC57781B1F70430836762A37@SC-VEXCH1.marvell.com> (sfid-20120228_195916_772663_AC65CF01)
References: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
	<1330409056-4399-7-git-send-email-bzhao@marvell.com>
	<1330421310.3368.0.camel@jlt3.sipsolutions.net>
 <CA+yqC4b2Q321g6Mfu_6npjF63CqqArbarpJYAGwB2muJkrLOqg@mail.gmail.com>
In-Reply-To: <CA+yqC4b2Q321g6Mfu_6npjF63CqqArbarpJYAGwB2muJkrLOqg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Driver performs specific SSID scan operation when "iw dev <devname>
> > scan ssid <ssid>" command is fired.
> > Sometimes even if driver could not find the AP with requested SSID
> > in scanning, it is displayed in scan results based on history,
> > because scan table entries are valid in cfg80211 stack for 15 seconds.
> >
> > This patch adds code to remove respective scan table entry before
> > performing specific SSID scan to make sure that correct scan results
> > are displayed to user.
> NACK. This isn't the intended behaviour here. If any such behaviour is
> desired it should probably be implemented in wpa_s, or maybe in
> cfg80211, but certainly not in the driver where all it does is make
> different drivers behave differently.
> 
> We've talked about passing a flag in w/ the scan request that says "flush your bss cache
> first".  Seems like that'd do what's desired here (and could be used by wpa_supplicant to replace
> manually flushing stale entries).

Hi Sam,

Is there a patch available for testing?

Thanks,
Bing


