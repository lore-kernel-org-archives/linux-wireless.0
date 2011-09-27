Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34594 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1I0Nxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 09:53:43 -0400
Date: Tue, 27 Sep 2011 19:24:23 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <johannes@sipsolutions.net>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] mac80211: Send nullfunc frames at lower rate
Message-ID: <20110927135422.GA29536@vmraj-lnx.users.atheros.com> (sfid-20110927_155347_358620_357CB441)
References: <1317039804-8521-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4E807F71.1010809@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E807F71.1010809@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2011 at 07:34:41AM -0600, Felix Fietkau wrote:
> On 2011-09-26 6:23 AM, Rajkumar Manoharan wrote:
> >Recently mac80211 was changed to use nullfunc instead of probe
> >request for connection monitoring for tx ack status reporting
> >hardwares. These nullfunc data frames are being sent at higer
> >rates and also as aggregated ones. This could probably delays
> >the nullfunc ack so the connection is more frequently getting
> >disconnected as max retries are reached. In order to improve
> >the connectivity send the nullfunc at lower rate.
> I don't think nullfunc frames should be sent at the lowest rate. If
> they fail frequently, then the rate control module is doing
> something crappy and should be fixed. So far I haven't seen any
> nullfunc reliablity issues with minstrel_ht.
> Also, as far as I know, mac80211 sends non-QoS nullfunc frames, so
> they cannot get aggregated either.
>
Yes. you are right. it is not aggregated. An issue was observed when
the STA is roaming so frequesntly and it is on idle state without any
transmission. In such case the rate control is not learned completely.
By the time the connection was terminated so offenly due to not
receiving ack for null frames. On the same situaltion, sending probe
requests instead of nullfunc helps to retain the connection.

--
Rajkumar
