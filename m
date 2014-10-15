Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53925 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOGea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 02:34:30 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: "sujith@msujith.org" <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: Reduce max roc duration
Date: Wed, 15 Oct 2014 06:34:09 +0000
Message-ID: <D063E0FD.44033%jouni@qca.qualcomm.com> (sfid-20141015_083435_774075_00CEF64B)
References: <1413338387-30475-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1413338387-30475-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 15/10/14 3:59 am, "Sujith Manoharan" <sujith@msujith.org> wrote:

>MCC is currently used in CUS227, an Allplay
>device. Since audio streaming will be affected
>with long offchannel periods, reduce the max.
>offchannel duration to 200ms.
>diff --git a/drivers/net/wireless/ath/ath9k/init.c
>b/drivers/net/wireless/ath/ath9k/init.c
>@@ -789,7 +789,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc,
>struct ieee80211_hw *hw)
>-		hw->wiphy->max_remain_on_channel_duration = 10000;
>+		hw->wiphy->max_remain_on_channel_duration = 200;

This looks like a bad idea as the default value. Wouldn't this break a lot
of use cases where longer wait is needed? Please keep in mind that
remain-on-channel is used for non-P2P use cases as well and there are
known P2P devices that won't be able to reply in 200 ms to messages in
many cases. I would not reduce this value below 1000 ms and really, if
there is need to reduce remain-on-channel operations while there is a
concurrent connection, that should be done dynamically at runtime, e.g.,
in wpa_supplicant, rather than the driver hardcoding a very small maximum
value.

- Jouni

