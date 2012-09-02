Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab2IBVr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 17:47:57 -0400
Message-ID: <1346622503.10113.2.camel@jlt4.sipsolutions.net> (sfid-20120902_234928_831962_18D05B7A)
Subject: Re: [PATCH] carl9170: connect to 11w protected networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Sun, 02 Sep 2012 23:48:23 +0200
In-Reply-To: <E1T89yV-0007Cn-JT@debian64.localnet> (sfid-20120902_151319_118701_3604D3F3)
References: <E1T89yV-0007Cn-JT@debian64.localnet>
	 (sfid-20120902_151319_118701_3604D3F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-02 at 14:25 +0200, Christian Lamparter wrote:
> Previously, it was not possible to connect to
> networks which requires 11w to be supported by
> the stations.
> 
> While the documentation hints that there's some
> hardware support for offloading MFP "decryption",
> this simple implementation relies on the mac80211
> stack to do the actual crypto operations.

Maybe we need to clarify the documentation...

The problem with MFP is that now unicast management frames are encrypted
with CCMP. If the device has HW crypto on RX or TX, it may not implement
it correctly due to the different header munging needed for management
frames over data frames.

You should verify that unicast management frames are properly encrypted
and decrypted by the hardware (or punted to software on RX like you do
on TX). The danger is that the hardware corrupts CCMP encrypted RX mgmt
frames and software can't recover.

johannes

