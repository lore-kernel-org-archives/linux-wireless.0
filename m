Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48201 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbbCKQXA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 12:23:00 -0400
Message-ID: <1426090976.1904.7.camel@sipsolutions.net> (sfid-20150311_172305_318231_2BEF2ACD)
Subject: Re: [PATCH] ath10k: strip qos data bit always
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Wed, 11 Mar 2015 17:22:56 +0100
In-Reply-To: <1426080326-14764-1-git-send-email-michal.kazior@tieto.com> (sfid-20150311_142751_625852_7560ADDB)
References: <1426080326-14764-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150311_142751_625852_7560ADDB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 14:25 +0100, Michal Kazior wrote:
> NativeWifi tx mode expects QoS Data frames to be
> delivered as Data frames with QoS part (e.g. tid)
> being delievered out-of-band in fw tx command.
> 
> The QoS bit wasn't stripped before submitting to
> firmware.
> 
> Stripping fixes two known problems:
> 
>  * qca6174 IOT with some APs, e.g.
>    Cisco AIR-AP 1252 (which would crash after
>    ath10k association). Some ath9k APs would
>    crash as well.

It would probably be interesting to figure out why and fix that - this
is clearly a major issue.

johannes

