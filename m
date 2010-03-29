Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45406 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0C2SLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 14:11:52 -0400
Received: by bwz1 with SMTP id 1so3787371bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 11:11:51 -0700 (PDT)
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH V2 1/2] mac80211: support paged rx SKBs
References: <1269852146-11727-1-git-send-email-yi.zhu@intel.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 29 Mar 2010 21:11:48 +0300
In-Reply-To: <1269852146-11727-1-git-send-email-yi.zhu@intel.com> (Zhu Yi's message of "Mon\, 29 Mar 2010 16\:42\:25 +0800")
Message-ID: <878w9bknff.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi <yi.zhu@intel.com> writes:

> Mac80211 drivers can now pass paged SKBs to mac80211 via
> ieee80211_rx{_irqsafe}. The implementation currently use
> skb_linearize() in a few places i.e. management frame
> handling, software decryption, defragmentation and A-MSDU
> process. We will optimize them one by one later.

[...]

> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1822,7 +1822,10 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw);
>   * ieee80211_rx - receive frame
>   *
>   * Use this function to hand received frames to mac80211. The receive
> - * buffer in @skb must start with an IEEE 802.11 header.
> + * buffer in @skb must start with an IEEE 802.11 header. In case of a
> + * paged @skb is used, the driver is recommended to put the ieee80211
> + * header of the frame on the linear part of the @skb to avoid memory
> + * allocation and/or memcpy by the stack.

This is much better now. Thank you.

-- 
Kalle Valo
