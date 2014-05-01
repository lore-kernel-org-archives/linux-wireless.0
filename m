Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:7813 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaEAI06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 04:26:58 -0400
Message-ID: <53620550.3050001@broadcom.com> (sfid-20140501_102703_895372_89FA0CC2)
Date: Thu, 1 May 2014 10:26:56 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: net/wireless/chan.c: prohibited_flags wrongly set
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I was debugging issue with hostapd failing on setting channel when I 
came across this piece of code in chan.c:545:cfg80211_chandef_usable():

	if (width > 20)
		prohibited_flags |= IEEE80211_CHAN_NO_OFDM;

	/* 5 and 10 MHz are only defined for the OFDM PHY */
	if (width < 20)
		prohibited_flags |= IEEE80211_CHAN_NO_OFDM;

I suspect the first if statement to be wrong, but what should it be?

Regards,
Arend
