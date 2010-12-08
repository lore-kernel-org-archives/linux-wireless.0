Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17794 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab0LHHTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 02:19:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 23:19:00 -0800
Date: Wed, 8 Dec 2010 12:48:49 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2.6.37 v2 1/2] ath9k: fix beacon resource related race
 condition
Message-ID: <20101208071848.GA17780@vmraj-lnx.users.atheros.com>
References: <1291723939-19262-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1291723939-19262-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 07, 2010 at 05:42:18PM +0530, Rajkumar Manoharan wrote:
> The beacon tasklet is accesssing the bslot info for beacon generation.
> Meanwhile the same slot can be freed on interface deletion.
> Current the remove_interface disables the beacon alert after freeing the slot.
> This may leads to null pointer access.
> 
> This patch disables SWBA and kills the beacon tasklet to prevent access
> to the slot to be freed. After releasing the slot, swba will be enabled again
> upon the availablity of beaconing interfaces.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
John,

I respin the patches on 2.6.37-rc5-wl and send it again. Sorry for inconvenience.

--
Rajkumar
 
