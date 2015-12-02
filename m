Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51994 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbbLBJ5S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 04:57:18 -0500
Message-ID: <1449050234.2449.7.camel@sipsolutions.net> (sfid-20151202_105729_730249_2C155C84)
Subject: Re: [PATCH v2] mac80211_hwsim: check ATTR_FREQ for wmediumd
 (netlink) packets
From: Johannes Berg <johannes@sipsolutions.net>
To: arwelle@cert.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 02 Dec 2015 10:57:14 +0100
In-Reply-To: <1449008032-6541-1-git-send-email-arwelle@cert.org>
References: <1449008032-6541-1-git-send-email-arwelle@cert.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-12-01 at 17:13 -0500, arwelle@cert.org wrote:
> From: Adam Welle <arwelle@cert.org>
> 
> If a packet is received from netlink with the frequency value set it
> is
> checked against the current radio's frequency and discarded if
> different.
> The frequency is also checked against data2->tmp_chan if non-zero to
> support
> the off-channel/scan case.
> 
Applied. I added locking and made a change to accept both the off-
channel and non-offchannel since the internal datapath also does that
and we don't stop other operation for off-channel.

johannes
