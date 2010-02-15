Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38868 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab0BONkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 08:40:42 -0500
Date: Mon, 15 Feb 2010 15:40:23 +0200
From: Jouni Malinen <j@w1.fi>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Improved IBSS merges
Message-ID: <20100215134023.GA11947@jm.kir.nu>
References: <1266190435-2355-1-git-send-email-benoit.papillault@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266190435-2355-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 15, 2010 at 12:33:54AM +0100, Benoit Papillault wrote:
> According to $11.1.4 from IEEE 802.11-2007, TSF is reset (drv_reset_tsf)
> on MLME-JOIN, ie only when a new IBSS is created or if an existing IBSS
> is joined, but not on IBSS merges.

While that may indeed be what the standard says, drv_reset_tsf() may be
needed to allow the driver to actually learn the new timestamp correctly
in the case of merge. Have you verified that the drivers that support
IBSS do indeed update their timestamps without that call in case there
is a large difference in the timestamp values that the separate IBSSes
used before the merge?

-- 
Jouni Malinen                                            PGP id EFC895FA
