Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33378 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1IGGeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 02:34:04 -0400
Received: by mail-gy0-f174.google.com with SMTP id 6so4481462gya.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2011 23:34:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315375544-94891-1-git-send-email-nbd@openwrt.org>
References: <1315375544-94891-1-git-send-email-nbd@openwrt.org>
Date: Wed, 7 Sep 2011 08:34:04 +0200
Message-ID: <CAGXE3d84CJhpKcDjutEggNR7M_u9L+sO7z-LC_orQEhRR7kB4w@mail.gmail.com> (sfid-20110907_083410_474489_1D54CA7A)
Subject: Re: [PATCH v2] mac80211: retry sending failed BAR frames later
 instead of tearing down aggr
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 7, 2011 at 8:05 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Unfortunately failed BAR tx attempts happen more frequently than I
> expected, and the resulting aggregation teardowns cause performance
> issues, as the aggregation session does not always get re-established
> properly.
> Instead of tearing down the entire aggr session, we can simply store the
> SSN of the last failed BAR tx attempt, wait for the first successful
> tx status event, and then send another BAR with the same SSN.
>
> Also fix an endian bug on accessing the control field of the BAR

Thanks for the endian fix!

[...]

> @@ -246,6 +278,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>                }
>
>                if (!acked && ieee80211_is_back_req(fc)) {
> +                       u16 control;
> +
>                        /*
>                         * BAR failed, let's tear down the BA session as a
>                         * last resort as some STAs (Intel 5100 on Windows)

The comment should be updated as well.

Helmut
