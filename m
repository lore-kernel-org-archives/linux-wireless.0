Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43170 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2DZRG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 13:06:29 -0400
From: "Giori, Kathy" <kgiori@qca.qualcomm.com>
To: Harshal Chhaya <harshal@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: Support for AR9342 in ath9k?
Date: Thu, 26 Apr 2012 17:06:28 +0000
Message-ID: <20FE3948A2672041B9064A92744BD275E77F23@nasanexd02b.na.qualcomm.com> (sfid-20120426_190633_206846_37BB74E7)
References: <CAJ8GFOjMHjWwq2rAYT+M5cFmkwHL3z_8mPqvpYXwE=C65Y7hag@mail.gmail.com>
In-Reply-To: <CAJ8GFOjMHjWwq2rAYT+M5cFmkwHL3z_8mPqvpYXwE=C65Y7hag@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Harshal Chhaya
> Sent: Thursday, April 26, 2012 8:22 AM
> To: linux-wireless
> Subject: Support for AR9342 in ath9k?
> 
> Hello,
> 
> I am looking for information on the level of support for AR9342 chip in 'ath9k'.
> 
> The page at http://linuxwireless.org/en/users/Drivers/ath9k/todo
> indicates that the 'todo' list is still pretty large but I also found many patches (e.g.
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/68431)
> that add support for this chip.
> 
> Is there enough support for AR9342 in 'ath9k' to use it as a dual-band AP? Does
> Qualcomm Atheros have their own software package for AP functionality for this
> chip?
> 
> Thanks,
> - Harshal

Harshal,

Yes, for AR934x SoCs, Qualcomm Atheros supports both the ath9k upstream driver and a non-Linux-specific (but also runs on Linux) Wi-Fi driver. The ath9k todo page is out of date. Sorry about that -- hopefully we can help clean that up soon. I think the main functionality that is lacking when using the ath9k driver is that for 5GHz channel operation, DFS logic in Linux is incomplete. Zefir Kurtisi did a great job adding DFS support to ath9k (radar detection and pattern matching), but now it needs to connect to logic within mac80211 and above to satisfy the various regional specifications (FCC, ETSI, Japan). TI (Victor G) posted some RFC patches for that upper layer logic several weeks back, but I haven't seen much activity on it for a while. Hopefully DFS support will be available soon.

In addition to upstream driver support, one of our goals at Qualcomm Atheros is better baseline support of our platforms by implementing upstream BSP code and validating basic board support with OpenWrt. We'd like you to be able to grab any Qualcomm Atheros AP reference design and flash/boot it with the latest stable version of OpenWrt (AA at the moment). Wouldn't that be handy?

It is important that customers and developers like you ask specifically about using ath9k (or OpenWrt or whatever it is you need) and explain why that support is important to you. With that input we can justify directing more internal developer resources to work on the upstream Linux components. Suggestions, recommendations, queries therefore most welcome. :)

Hope that helps. Let us know how we can do even better.
kathy
