Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:60132 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3DTR22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Apr 2013 13:28:28 -0400
Received: by mail-we0-f171.google.com with SMTP id i48so4765485wef.30
        for <linux-wireless@vger.kernel.org>; Sat, 20 Apr 2013 10:28:27 -0700 (PDT)
Date: Sat, 20 Apr 2013 19:28:15 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v4 1/3] mac80211: improve the rate control API
Message-ID: <20130420172815.GB767@gobelin> (sfid-20130420_192841_355792_D53BE442)
References: <1366385329-42690-1-git-send-email-nbd@openwrt.org>
 <20130420172247.GA767@gobelin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130420172247.GA767@gobelin>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 20, 2013 at 07:22:48PM +0200, Karl Beldan wrote:
> If we need to send 'low' rates (i.e those selected by *send_low) then 'low'
> rates get mixed with the rate table rates after fill_sta_table.
> If the driver doesn't advertise IEEE80211_HW_SUPPORTS_RC_TABLE, the
> solution could be to set info->control.rates[i > 0].idx to -1 in
> __rate_control_send_low, otherwise the driver would have to perform a
> check like rate_control_send_low already did.
>  
Another idea would be to add a 'low' member in the rate table struct so
that we don't merge the rates when desired so ..
 
Karl
