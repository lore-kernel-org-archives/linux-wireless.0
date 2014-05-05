Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbaEEM6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 08:58:03 -0400
Message-ID: <1399294659.22235.9.camel@jlt4.sipsolutions.net> (sfid-20140505_145820_382931_1ECE9807)
Subject: Re: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Date: Mon, 05 May 2014 14:57:39 +0200
In-Reply-To: <87y4ymn69s.fsf@qca.qualcomm.com>
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
	 <1397760423-11455-2-git-send-email-bzhao@marvell.com>
	 <87a9bb5c2c.fsf@purkki.adurom.net> <20140425013756.GA3410@tuxdriver.com>
	 <477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com>
	 <1398413370.4152.0.camel@jlt4.sipsolutions.net>
	 <8738gvp8md.fsf@qca.qualcomm.com>
	 <1398846593.5408.0.camel@jlt4.sipsolutions.net>
	 <20140430132246.GB3635@tuxdriver.com> <87y4ymn69s.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-30 at 19:14 +0300, Kalle Valo wrote:

> >> We have it in iwlwifi as well - we were considering a generic uevent but
> >> beyond that I don't think there's much that could be done?
> >
> > There is an ethtool op for that, no?
> 
> Do you mean this one:
> 
>  * @get_dump_flag: Get dump flag indicating current dump length, version,
>  * 		   and flag of the device.
>  * @get_dump_data: Get dump data.
>  * @set_dump: Set dump specific flags to the device.
> 
> 	int	(*get_dump_flag)(struct net_device *, struct ethtool_dump *);
> 	int	(*get_dump_data)(struct net_device *,
> 				 struct ethtool_dump *, void *);
> 	int	(*set_dump)(struct net_device *, struct ethtool_dump *);
> 
> Yeah, maybe we could use that in wireless as well.

What was the intended use case for this though? Neither the header file
nor the ethtool documentation seem particularly clear, other than saying
"firmware dump" - we'll want to include driver data as well though?

johannes

