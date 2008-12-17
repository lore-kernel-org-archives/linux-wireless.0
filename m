Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53585 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYLQPpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 10:45:18 -0500
Date: Wed, 17 Dec 2008 10:38:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	mickflemm@gmail.com, mcgrof@gmail.com, me@bobcopeland.com
Subject: Re: [RFC]: ath5k: enable TXOK IRQ
Message-ID: <20081217153829.GB3539@tuxdriver.com> (sfid-20081217_164523_222194_085A0751)
References: <493F5010.7030500@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <493F5010.7030500@trash.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2008 at 06:13:52AM +0100, Patrick McHardy wrote:
> I tried to use ath5k in AP mode with hostapd, but hostapd never
> added the authenticated and associated stations to the kernel.
> The reason is that ath5k didn't invoke the tx tasklet, so it
> did not call the ieee80211_tx_status() function and userspace
> didn't receive the radiotap message indicating success.
>
> The root cause appears to be that the TXOK interrupt is not
> enabled, so the tasklet is never scheduled. I'm not sure whether
> TXOK is really the correct one to handle ! IEEE80211_TX_CTL_NO_ACK,
> but it fixes the problem for me.

Any comments from the ath5k "usual suspects" on this one?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
