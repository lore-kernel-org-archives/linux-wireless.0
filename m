Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40557 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaJOIL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 04:11:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21566.11399.974541.319894@gargle.gargle.HOWL> (sfid-20141015_101204_890099_92A352AA)
Date: Wed, 15 Oct 2014 13:42:55 +0530
To: "Malinen\, Jouni" <jouni@qca.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: Reduce max roc duration
In-Reply-To: <D063E0FD.44033%jouni@qca.qualcomm.com>
References: <1413338387-30475-1-git-send-email-sujith@msujith.org>
	<D063E0FD.44033%jouni@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please drop this patch.

Sujith

Malinen, Jouni wrote:
> 
> 
> On 15/10/14 3:59 am, "Sujith Manoharan" <sujith@msujith.org> wrote:
> 
> >MCC is currently used in CUS227, an Allplay
> >device. Since audio streaming will be affected
> >with long offchannel periods, reduce the max.
> >offchannel duration to 200ms.
> >diff --git a/drivers/net/wireless/ath/ath9k/init.c
> >b/drivers/net/wireless/ath/ath9k/init.c
> >@@ -789,7 +789,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc,
> >struct ieee80211_hw *hw)
> >-		hw->wiphy->max_remain_on_channel_duration = 10000;
> >+		hw->wiphy->max_remain_on_channel_duration = 200;
> 
> This looks like a bad idea as the default value. Wouldn't this break a lot
> of use cases where longer wait is needed? Please keep in mind that
> remain-on-channel is used for non-P2P use cases as well and there are
> known P2P devices that won't be able to reply in 200 ms to messages in
> many cases. I would not reduce this value below 1000 ms and really, if
> there is need to reduce remain-on-channel operations while there is a
> concurrent connection, that should be done dynamically at runtime, e.g.,
> in wpa_supplicant, rather than the driver hardcoding a very small maximum
> value.
> 
> - Jouni
> 
