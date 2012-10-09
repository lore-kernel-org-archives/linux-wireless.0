Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2JIStk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 14:49:40 -0400
Message-ID: <1349808612.4683.21.camel@jlt4.sipsolutions.net> (sfid-20121009_204943_864624_76935D52)
Subject: Re: [PATCH] mac80211: check if key has TKIP type before updating IV
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Date: Tue, 09 Oct 2012 20:50:12 +0200
In-Reply-To: <20121002193422.GA12214@redhat.com>
References: <20121002193422.GA12214@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-02 at 21:34 +0200, Stanislaw Gruszka wrote:
> This patch fix corruption which can manifest itself by following crash
> when switching on rfkill switch with rt2x00 driver:
> https://bugzilla.redhat.com/attachment.cgi?id=615362
> 
> Pointer key->u.ccmp.tfm of group key get corrupted in:
> 
> ieee80211_rx_h_michael_mic_verify():
> 
>         /* update IV in key information to be able to detect replays */
>         rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip_iv32;
>         rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip_iv16;
> 
> because rt2x00 always set RX_FLAG_MMIC_STRIPPED, even if key is not TKIP.
> 
> We already check type of the key in different path in
> ieee80211_rx_h_michael_mic_verify() function, so adding additional
> check here is reasonable.
> 
> Cc: stable@vger.kernel.org # 3.0+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Looks fine, John, could you also pick this up for 3.7?

johannes


