Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18932 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2IYQzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 12:55:23 -0400
Date: Tue, 25 Sep 2012 09:56:30 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] cfg80211: Fix regulatory check for 60GHz band
 frequencies
Message-ID: <20120925165630.GG3354@lenteja.do-not-panic.com> (sfid-20120925_185604_701460_7B194E91)
References: <1348386594-6067-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1348386594-6067-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1348558107.10041.19.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1348558107.10041.19.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 25, 2012 at 09:28:27AM +0200, Johannes Berg wrote:
> On Sun, 2012-09-23 at 09:49 +0200, Vladimir Kondratiev wrote:
> > Without a fix for this even though channels 1-3 are allowed world
> > wide on the rule (57240 - 63720 @ 2160), channel 2 at 60480 MHz
> > will end up getting disabled given that it is 3240 MHz from
> > both the frequency rule start and end frequency. Fix this by
> > using 2 GHz separation assumption for the 2.4 and 5 GHz bands
> > but for 60 GHz use a 10 GHz separation before assuming a rule
> > is not part of the band.
> 
> Luis, given that you think the regulatory code in the kernel is 802.11
> specific, why are we inferring these rules from the frequencies rather
> than using the 802.11 specific information about the band that it
> represents? :-D

Its a good point freq_reg_info() is at the crux of where we do are still
agnostic to 802.11. To make this 802.11 specific and easier to read I
suspect we can require passing the chan struct and then we'd use a switch
statement for the band.

  Luis
