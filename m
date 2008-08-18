Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:52357 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758AbYHRAXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 20:23:08 -0400
Message-ID: <48A8C0E9.6030300@lwfinger.net> (sfid-20080818_022313_097663_63BA8E3D)
Date: Sun, 17 Aug 2008 19:23:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-17
References: <20080817185605.GC30679@tuxdriver.com> <20080817.151251.204370966.davem@davemloft.net>
In-Reply-To: <20080817.151251.204370966.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> Their commit messages reference SHA IDs but do not give a commit
> header line text reference as well.
> 
>       p54: Fix regression due to commit b19fa1f

John,

This commit message should fix the above patch:
=============

From: Christian Lamparter <chunkeey@web.de>

Commit b19fa1f, entitled "net: Delete NETDEVICES_MULTIQUEUE kconfig
option" breaks p54pci and p54usb.

Additionally, the old logic always tx'ed cts frames (if enabled)
with a short preamble when [rate > 3]. (i.e. with any 802.11g rate).
Of course this isn't that bad, but it's still wrong!

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: <stable@kernel.org>         [2.6.25.x, 2.6.26.x]
---

Larry
