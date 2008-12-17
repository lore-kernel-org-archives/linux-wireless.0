Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38450 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbYLQQU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 11:20:59 -0500
Date: Wed, 17 Dec 2008 18:20:17 +0200
From: Jouni Malinen <j@w1.fi>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@gmail.com, jouni.malinen@atheros.com
Subject: Re: [RFC] Handle Channel Switch Announcement
Message-ID: <20081217162017.GA28712@jm.kir.nu> (sfid-20081217_172103_682831_632FF149)
References: <18761.4838.509784.281821@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <18761.4838.509784.281821@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2008 at 08:25:34PM +0530, Sujith wrote:
> This is an attempt to handle CSA elements from an AP and switch
> to the specified channel.
> 
> Only mode 1 is handled, i.e, we just stop transmission on receiving a CSA element.
> User space notification is not handled yet.

> diff --git a/include/net/wireless.h b/include/net/wireless.h
> + * @IEEE80211_CHAN_CSA_DISABLED: Disabled because a
> +	Channel Switch Announcement was received on this channel.

Why is this flag needed? Or well, the better question: Why is the
channel disabled? CSA may request the STA to stop transmitting _within
the BSS_ until the AP has changed channels (i.e., it could be possible
to use other BSSes even on the same channel). This notification can be
used for other things than just reporting a radar on the channel (e.g.,
the AP could move to a channel that has less traffic on it).

-- 
Jouni Malinen                                            PGP id EFC895FA
