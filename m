Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab3BKQm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 11:42:26 -0500
Message-ID: <1360600938.8738.34.camel@jlt4.sipsolutions.net> (sfid-20130211_174232_146320_7AAEDB66)
Subject: Re: About iwl4965 AP mode support
From: Johannes Berg <johannes@sipsolutions.net>
To: Heiher <admin@heiher.info>
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 17:42:18 +0100
In-Reply-To: <CAHirt9hpnpBb5K31rgeAp1mFROPw2dTDmAZMyC1NLF+3+mKEUg@mail.gmail.com> (sfid-20130211_173108_743034_073582DA)
References: <CAHirt9hpnpBb5K31rgeAp1mFROPw2dTDmAZMyC1NLF+3+mKEUg@mail.gmail.com>
	 (sfid-20130211_173108_743034_073582DA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 00:31 +0800, Heiher wrote:
> Hello,
> 
> I modifed iwl4965 kernel driver by this patch iwl4965-ap-mode.diff.
> the wifi station can connect to this access point after hostapd
> service started and ping client address from access point is ok. but
> the problem is the wifi connection not stable, the connection will
> automatically disconnect.
> 
> Please help me.. Thanks!

Can't. The device doesn't support TX-after-DTIM-beacon for proper
multicast powersave support. The driver also doesn't manage sleeping
stations properly, I think, but it's pretty pointless to attempt it due
to the first issue.

johannes

