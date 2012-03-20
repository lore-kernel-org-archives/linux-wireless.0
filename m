Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59943 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab2CTWW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 18:22:59 -0400
Message-ID: <4F690340.5090102@openwrt.org> (sfid-20120320_232303_033279_6A6003DB)
Date: Tue, 20 Mar 2012 23:22:56 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: avg-signal is weird in ath9k in 3.3.0
References: <4F68DEE8.60506@candelatech.com>
In-Reply-To: <4F68DEE8.60506@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-20 8:47 PM, Ben Greear wrote:
> I'm testing out some code to get a stations's avg-signal through ethtool-stats,
> and both it and /proc/net/wireless show ranges bouncing all over
> (from around -48 to -110) on an interface running heavy traffic.
> 
> Are there any known bugs in 3.3.0 related to this?
As far as I know, this bug has always been there (RSSI values for A-MPDU
subframes are invalid, except for the last subframe).
I've sent fixes for this, which will show up in 3.4

- Felix
