Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:57274 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbXKUIBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 03:01:13 -0500
Received: by mu-out-0910.google.com with SMTP id i10so2492953mue
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2007 00:01:07 -0800 (PST)
Message-ID: <c85cb4470711210001n7f0780d4v7e79424c4026a849@mail.gmail.com> (sfid-20071121_080117_117739_004021C2)
Date: Wed, 21 Nov 2007 10:01:06 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <11955780202087-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11955780202087-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/07, Ron Rindjunsky <ron.rindjunsky@intel.com> wrote:
> This patch restructures the Rx handlers chain by incorporating previously
> handlers ieee80211_rx_h_802_1x_pae and ieee80211_rx_h_drop_unencrypted
> into ieee80211_rx_h_data, already in 802.3 form. this scheme follows more
> precisely after the IEEE802.11 data plane archituecture, and will prevent
> code duplication to IEEE8021.11n A-MSDU handler.

Sorry for the slip, I will issue the *correct* patch :)

> -                    (rx->sdata->eapol == 0 || !ieee80211_is_eapol(rx->skb)))) {
> +                    (rx->sdata->eapol ||
