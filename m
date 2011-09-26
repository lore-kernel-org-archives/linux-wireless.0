Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51144 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab1IZNeu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 09:34:50 -0400
Message-ID: <4E807F71.1010809@openwrt.org> (sfid-20110926_153453_454445_B6F1FB09)
Date: Mon, 26 Sep 2011 07:34:41 -0600
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v3] mac80211: Send nullfunc frames at lower rate
References: <1317039804-8521-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1317039804-8521-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-26 6:23 AM, Rajkumar Manoharan wrote:
> Recently mac80211 was changed to use nullfunc instead of probe
> request for connection monitoring for tx ack status reporting
> hardwares. These nullfunc data frames are being sent at higer
> rates and also as aggregated ones. This could probably delays
> the nullfunc ack so the connection is more frequently getting
> disconnected as max retries are reached. In order to improve
> the connectivity send the nullfunc at lower rate.
I don't think nullfunc frames should be sent at the lowest rate. If they 
fail frequently, then the rate control module is doing something crappy 
and should be fixed. So far I haven't seen any nullfunc reliablity 
issues with minstrel_ht.
Also, as far as I know, mac80211 sends non-QoS nullfunc frames, so they 
cannot get aggregated either.

- Felix
