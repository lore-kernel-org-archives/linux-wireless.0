Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.sdf.org ([192.94.73.20]:54459 "EHLO sdf.lonestar.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932363AbcHCXlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 19:41:36 -0400
From: Alan Curry <rlwinm@sdf.org>
Message-Id: <201608032325.u73NPQ3w016047@sdf.org> (sfid-20160804_014219_711644_7131EF16)
Subject: Re: PROBLEM: network data corruption (bisected to e5a4b0bb803b)
In-Reply-To: <1882749.mb7lsAROoU@debian64>
To: Christian Lamparter <chunkeey@googlemail.com>
Date: Wed, 3 Aug 2016 23:25:26 +0000 (UTC)
CC: Alan Curry <rlwinm@sdf.org>, Al Viro <viro@zeniv.linux.org.uk>,
	alexmcwhirter@triadic.us, David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> 
> One thing I noticed in your previous post is that you "might" not have
> draft-802.11n enabled. Do you see any "disabling HT/VHT due to WEP/TKIP use."
> in your dmesg logs? If so, check if you can force your AP to use WPA2
> with CCMP/AES only.
> 

Yes, I've had that message. The reason wan't on the AP though. My
wpa_supplicant.conf only had TKIP enabled, because that's what was in the
sample configuration file I started with. Adding CCMP there worked, and in
that mode I'm no longer getting any corrupted packets.

If I'd paid attention to the encryption options when setting up this network
originally, I would have had CCMP the whole time, with no corrupted packets,
and never would have found the iov iterator bug...

-- 
Alan Curry
