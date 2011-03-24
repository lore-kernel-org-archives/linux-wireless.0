Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1709 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1CXQe3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 12:34:29 -0400
Message-ID: <4D8B728D.8030400@broadcom.com>
Date: Thu, 24 Mar 2011 17:34:21 +0100
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: More log spam from brcm80211
References: <4D8B6D2D.3090505@lwfinger.net>
In-Reply-To: <4D8B6D2D.3090505@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

did you already try my preliminary patch (email that I sent you 
yesterday) for the previous log spam problem ?

Regarding this new problem: I will get back to you shortly.

Bye, Roland.


On 03/24/2011 05:11 PM, Larry Finger wrote:
> Roland,
>
> My logs are getting spammed with lots of "Short CCK" messages that come from the
> following code fragment:
>
>                   if (IS_CCK(rspec)) {
>                           if (rxh->PhyRxStatus_0&  PRXS0_SHORTH)
>                                   WL_ERROR("Short CCK\n");
>                           rx_status->flag |= RX_FLAG_SHORTPRE;
>                   } else if (IS_OFDM(rspec)) {
>                           rx_status->flag |= RX_FLAG_SHORTPRE;
>                   } else {
>                           WL_ERROR("%s: Unknown modulation\n", __func__);
>                   }
>
> Logging this condition for debugging might be appropriate, but I do not think it
> necessary for general use.
>
> Larry
>


