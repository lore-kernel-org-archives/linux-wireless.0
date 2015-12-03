Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59627 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759139AbbLCJKi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 04:10:38 -0500
Message-ID: <1449133834.2181.7.camel@sipsolutions.net> (sfid-20151203_101056_870257_E749585C)
Subject: Re: [PATCH v2] mac80211_hwsim: check ATTR_FREQ for wmediumd
 (netlink) packets
From: Johannes Berg <johannes@sipsolutions.net>
To: "Adam R. Welle" <arwelle@cert.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 03 Dec 2015 10:10:34 +0100
In-Reply-To: <2DE9F46DD36D2A458CD6347950113F25350A9B@marathon>
References: <1449008032-6541-1-git-send-email-arwelle@cert.org>
	 <1449050234.2449.7.camel@sipsolutions.net>
	 <2DE9F46DD36D2A458CD6347950113F25350A9B@marathon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-12-02 at 19:30 +0000, Adam R. Welle wrote:
> > Applied. I added locking and made a change to accept both the off-
> > channel and non-offchannel since the internal datapath also does
> > that
> > and we don't stop other operation for off-channel.
> 
> Does your change only throw away packets when tmp_chan is set? I was
> under the impression that most of the time tmp_chan would be null.
> 
Yeah, umm, that expression was wrong. Thanks.

It should be

                if (rx_status.freq != data2->channel->center_freq &&
                    (!data2->tmp_chan ||
                     rx_status.freq != data2->tmp_chan->center_freq)) {

I'll fix it.

johannes
