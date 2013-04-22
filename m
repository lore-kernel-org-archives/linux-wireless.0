Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50549 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3DVK0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 06:26:09 -0400
Received: by mail-wi0-f172.google.com with SMTP id hm14so868567wib.17
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 03:26:08 -0700 (PDT)
Date: Mon, 22 Apr 2013 12:21:44 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v5 1/3] mac80211: improve the rate control API
Message-ID: <20130422102144.GA26212@magnum.frso.rivierawaves.com> (sfid-20130422_122614_010851_EBA29E6F)
References: <1366625393-11647-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366625393-11647-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 22, 2013 at 12:09:51PM +0200, Felix Fietkau wrote:
> Allow rate control modules to pass a rate selection table to mac80211
> and the driver. This allows drivers to fetch the most recent rate
> selection from the sta pointer for already buffered frames. This allows
> rate control to respond faster to sudden link changes and it is also a
> step towards adding minstrel_ht support to drivers like iwlwifi.
> 
> When a driver sets IEEE80211_HW_SUPPORTS_RC_TABLE, mac80211 will not
> fill info->control.rates with rates from the rate table (to preserve
> explicit overrides by the rate control module). The driver then
> explicitly calls ieee80211_get_tx_rates to merge overrides from
> info->control.rates with defaults from the sta rate table.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
Looks ok to me.
 
Karl
