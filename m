Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19761 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1IZPJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 11:09:14 -0400
Date: Mon, 26 Sep 2011 20:39:50 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Felix Fietkau <nbd@openwrt.org>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] mac80211: Send nullfunc frames at lower rate
Message-ID: <20110926150949.GB9947@vmraj-lnx.users.atheros.com> (sfid-20110926_170917_993185_5030C047)
References: <1317039804-8521-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4E807F71.1010809@openwrt.org>
 <20110926134552.GC2273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110926134552.GC2273@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2011 at 03:45:53PM +0200, Stanislaw Gruszka wrote:
> On Mon, Sep 26, 2011 at 07:34:41AM -0600, Felix Fietkau wrote:
> > On 2011-09-26 6:23 AM, Rajkumar Manoharan wrote:
> > >Recently mac80211 was changed to use nullfunc instead of probe
> > >request for connection monitoring for tx ack status reporting
> > >hardwares. These nullfunc data frames are being sent at higer
> > >rates and also as aggregated ones. This could probably delays
> > >the nullfunc ack so the connection is more frequently getting
> > >disconnected as max retries are reached. In order to improve
> > >the connectivity send the nullfunc at lower rate.
> > I don't think nullfunc frames should be sent at the lowest rate. If
> > they fail frequently, then the rate control module is doing
> > something crappy and should be fixed. So far I haven't seen any
> > nullfunc reliablity issues with minstrel_ht.
> > Also, as far as I know, mac80211 sends non-QoS nullfunc frames, so
> > they cannot get aggregated either.
> 
> Perhaps nullfunc should be send at lowest rate only when it is
> used for connection monitoring, but I'm not sure if we can easily
> distinguish that.
>
I completely agree with you. If there are options to do that in simpler
way, that could be the better solution :)

--
Rajkumar
