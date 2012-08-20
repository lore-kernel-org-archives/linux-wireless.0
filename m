Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2HTLQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:16:36 -0400
Message-ID: <1345461391.4459.7.camel@jlt3.sipsolutions.net> (sfid-20120820_131640_056372_48F52C80)
Subject: Re: [cfg80211] Issue with simultaneous AP-STA operation in
 mwifiex/cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <avinashapatil@gmail.com>
Cc: linux-wireless@vger.kernel.org, Avinash Patil <patila@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>
Date: Mon, 20 Aug 2012 13:16:31 +0200
In-Reply-To: <CAJwzM1nGny-JBD8hwKXsrERko0cGvuJB_nD2dbPrPmzF-T49Tg@mail.gmail.com> (sfid-20120810_080731_101463_8799AA08)
References: <CAJwzM1nGny-JBD8hwKXsrERko0cGvuJB_nD2dbPrPmzF-T49Tg@mail.gmail.com>
	 (sfid-20120810_080731_101463_8799AA08)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-08-10 at 11:37 +0530, Avinash Patil wrote:
> Hi All,
> 
> Lately simultaneous AP-STA functionality in mwifiex driver is not
> working. I feel this has something to do with recent changes in
> cfg80211.
> 
> If we associate mwifiex STA to external AP first and then try to start
> mwifiex AP using hostapd(on different channel), we get –EBUSY error
> from cfg80211. This happens from path
> nl80211_start_ap->cfg80211_can_use_chan.  cfg80211_can_use_chan
> returns EBUSY error. In our design if mwifiex STA is already
> associated on some different channel, AP follows this channel and BSS
> is started using STA channel settings. If we start hostapd on same
> channel, BSS is successfully started, but association requests from
> external station result in failure.
> 
> Please let me know if we are missing something while registering
> n_iface and iface combinations. num_different_channels in
> ieee80211_iface_combination has been advertised as 1.

Well, if the number of different channels is 1, why would you expect to
be able to start an AP on a different channel than the STA is currently
using? Hostapd should know (needs to, I think) what channel is actually
being used, so you should start it on the right channel I think?

I don't know why association requests would fail.

johannes

