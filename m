Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39007 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbaJTT31 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 15:29:27 -0400
Message-ID: <1413833356.32358.4.camel@jlt4.sipsolutions.net> (sfid-20141020_212930_875648_972DCD3E)
Subject: Re: [ath9k-devel] IBSS network crashes after one device leaves
 network
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: "Li, Hongchun" <lihongchun@cn.fujitsu.com>,
	"(ath9k-devel@lists.ath9k.org)" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 20 Oct 2014 21:29:16 +0200
In-Reply-To: <54455DDF.50305@rempel-privat.de> (sfid-20141020_211003_234775_62CEB57E)
References: <C7367401563A9D46BC5A92B9456C061D48D210@G08CNEXMBPEKD03.g08.fujitsu.local>
	 <54455DDF.50305@rempel-privat.de> (sfid-20141020_211003_234775_62CEB57E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 21:09 +0200, Oleksij Rempel wrote:
> Hi Johannes,
> 
> since this function was added by you, may be you can help here (commit
> f09603a259). ath9k_htc support max 8 STAs in AP or ADHOC mode.  If more
> then 8 stations connected, driver will return error, but
> sta_info_insert_drv_state() setting it to zero.
> What was initial purpose of this?

The reason for this is that it's pointless to do anything else - the
station will try to communicate with us since there's no protocol that
allows rejecting the link. We therefore don't fail here, and try to
communicate with the station anyway - that might end up with not having
proper rate scaling etc. but is still better.

johannes


