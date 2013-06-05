Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:63898 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3FEIyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 04:54:03 -0400
Received: by mail-ie0-f170.google.com with SMTP id e14so3065502iej.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 01:54:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370371064-6903-1-git-send-email-linux@rempel-privat.de>
References: <51ADBC01.6090202@blackshift.org>
	<1370371064-6903-1-git-send-email-linux@rempel-privat.de>
Date: Wed, 5 Jun 2013 10:54:02 +0200
Message-ID: <CAGXE3d8YC-PVVfxNrbK4vYcxRAqe+zzwRCfJQuLk7merQsKE8Q@mail.gmail.com> (sfid-20130605_105414_311356_18655218)
Subject: Re: [PATCH] ath9k_htc: fix skb_under_panic error
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Jun 4, 2013 at 8:37 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> This error seems to be really rare, and we do not know real couse of it.
> But, in any case, we should check size of head before reducing it.

We had a similar issue in rt2x00 quite some time ago.

In general mac80211 should always reserve enough headroom as requested by
the driver in hw->extra_tx_headroom. However, there is a chance that a frame is
send to the driver again (see ieee80211_handle_filtered_frame). But if the frame
payload (or head) was moved due to padding and was not restored before calling
ieee80211_tx_status by the driver the second trip through the driver has reduced
headroom and could lead to such an error.

Quickly checking ath9k_htc it seems as if ath9k_htc_tx adds some padding
but ath9k_htc_tx_process does not remove the padding when passing the frame
back to mac80211.

Helmut
