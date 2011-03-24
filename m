Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57210 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1CXQLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 12:11:32 -0400
Received: by qyg14 with SMTP id 14so74466qyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 09:11:31 -0700 (PDT)
Message-ID: <4D8B6D2D.3090505@lwfinger.net>
Date: Thu, 24 Mar 2011 11:11:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roland Vossen <rvossen@broadcom.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: More log spam from brcm80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roland,

My logs are getting spammed with lots of "Short CCK" messages that come from the 
following code fragment:

                 if (IS_CCK(rspec)) {
                         if (rxh->PhyRxStatus_0 & PRXS0_SHORTH)
                                 WL_ERROR("Short CCK\n");
                         rx_status->flag |= RX_FLAG_SHORTPRE;
                 } else if (IS_OFDM(rspec)) {
                         rx_status->flag |= RX_FLAG_SHORTPRE;
                 } else {
                         WL_ERROR("%s: Unknown modulation\n", __func__);
                 }

Logging this condition for debugging might be appropriate, but I do not think it 
necessary for general use.

Larry
