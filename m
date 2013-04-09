Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935614Ab3DIK3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 06:29:21 -0400
Message-ID: <1365503356.8465.37.camel@jlt4.sipsolutions.net> (sfid-20130409_122925_200868_8AD8574F)
Subject: Re: [PATCH] mac80211: always pick a basic rate to tx RTS/CTS for
 pre-HT rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Tue, 09 Apr 2013 12:29:16 +0200
In-Reply-To: <1365156384-6699-1-git-send-email-karl.beldan@gmail.com> (sfid-20130405_121029_391208_2FD323E8)
References: <1365156384-6699-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130405_121029_391208_2FD323E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-05 at 12:06 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When the 1st rate control entry is a pre-HT rate we want to set
> rts_cts_rate_idx "as the fastest basic rate that is not faster than the
> data rate"(code comments).
> But in case some bss allowed rate indexes are lower than the lowest bss
> basic rate, if the rate control selects a rate among the formers for its
> 1st rate control entry, rts_cts_rate_idx remains 0 and is not a basic
> rate index.
> This commit sets rts_cts_rate_idx to the lowest bss basic rate index in
> this situation.

I guess it's a good thing you're looking at this code. However, I'm not
sure what you're doing here is correct. In this case, the PHY mandatory
rates should be used. See 9.7.6.5.2 "Selection of a rate or MCS":

        To allow the transmitting STA to calculate the contents of the
        Duration/ID field, a STA responding to a received frame
        transmits its control response frame at a primary rate, or at an
        alternate rate, or at an MCS, as specified by the following
        rules:

              * If a CTS or ACK control response frame is carried in a
                non-HT PPDU, the primary rate is defined to be the
                highest rate in the BSSBasicRateSet parameter that is
                less than or equal to the rate (or non-HT reference
                rate; see 9.7.9) of the previous frame. If no rate in
                the BSSBasicRateSet parameter meets these conditions,
                the primary rate is defined to be the highest mandatory
                rate of the attached PHY that is less than or equal to
                the rate (or non-HT reference rate; see 9.7.9) of the
                previous frame. The STA may select an alternate rate
                according to the rules in 9.7.6.5.4. The STA shall
                transmit the non-HT PPDU CTS or ACK control response
                frame at either the primary rate or the alternate rate,
                if one exists.

johannes

