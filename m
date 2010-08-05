Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57441 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab0HEW61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 18:58:27 -0400
Received: by wwj40 with SMTP id 40so8388665wwj.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 15:58:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201008051614.11546.d.haid@gogi.tv>
References: <201008051614.11546.d.haid@gogi.tv>
Date: Thu, 5 Aug 2010 17:58:26 -0500
Message-ID: <AANLkTikM_hyo71PyMLQ9z63FnOkusbKQb7OkRWfOvSTZ@mail.gmail.com>
Subject: Re: Capturing packets with bad FCS in monitor mode
From: Qasim Javed <qasimj@gmail.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

I am using the same card and the ath9k driver. I was also not able to
receive frames with CRC errors by setting the fcsfail flag while
creating the monitor mode interface. I looked up the code and found
that ath9k ignores frames with CRC errors in monitor mode.

The ath9k_rx_accept function in common.c has the following condition

if (ah->opmode == NL80211_IFTYPE_MONITOR) {
        if (rx_stats->rs_status &
                ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
                ATH9K_RXERR_CRC))
        return false;

Clearly, this function will return false in case of a CRC error while
receiving on a monitor interface.

For your info, this function is called by ath9k_rx_skb_preprocess
which in turn is invoked in ath9k_rx_tasklet.

In order to receive frames with CRC errors in monitor mode, I just
removed ATH9K_RXERR_CRC from the above snippet, recompiled and
reloaded ath9k and was able to receive frames with CRC errors.

I hope that helps.

-Qasim

On Thu, Aug 5, 2010 at 9:14 AM, Daniel Haid <d.haid@gogi.tv> wrote:
>
> Hello,
>
> is it possible to receive packets with bad FCS in monitor mode (ath9k driver)?
> There is a comment in ath9k/common.c which says that a bad checksum is
> ignored in monitor mode, but I have so far never been able to receive a
> packet with bad FCS (I do not know how to generate such packets,
> so I might just be too lucky that all packets are received unimpaired).
>
> Does ath9k hardware drop packets with bad FCS directly? If so, can
> it be disabled?
>
> Best regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
