Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38308 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab3DTRXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Apr 2013 13:23:04 -0400
Received: by mail-wi0-f169.google.com with SMTP id h11so2571545wiv.2
        for <linux-wireless@vger.kernel.org>; Sat, 20 Apr 2013 10:23:02 -0700 (PDT)
Date: Sat, 20 Apr 2013 19:22:48 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v4 1/3] mac80211: improve the rate control API
Message-ID: <20130420172247.GA767@gobelin> (sfid-20130420_192314_410268_50086B0D)
References: <1366385329-42690-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366385329-42690-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we need to send 'low' rates (i.e those selected by *send_low) then 'low'
rates get mixed with the rate table rates after fill_sta_table.
If the driver doesn't advertise IEEE80211_HW_SUPPORTS_RC_TABLE, the
solution could be to set info->control.rates[i > 0].idx to -1 in
__rate_control_send_low, otherwise the driver would have to perform a
check like rate_control_send_low already did.
 
Karl
