Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hyde.gogi.tv ([87.106.167.24]:57553 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760482Ab0HFBHN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 21:07:13 -0400
From: Daniel Haid <d.haid@gogi.tv>
To: linux-wireless@vger.kernel.org, Qasim Javed <qasimj@gmail.com>
Subject: Re: Capturing packets with bad FCS in monitor mode
Date: Fri, 6 Aug 2010 03:06:57 +0200
References: <201008051614.11546.d.haid@gogi.tv> <AANLkTikM_hyo71PyMLQ9z63FnOkusbKQb7OkRWfOvSTZ@mail.gmail.com>
In-Reply-To: <AANLkTikM_hyo71PyMLQ9z63FnOkusbKQb7OkRWfOvSTZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008060306.57963.d.haid@gogi.tv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> if (ah->opmode == NL80211_IFTYPE_MONITOR) {
>         if (rx_stats->rs_status &
>                 ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
>                 ATH9K_RXERR_CRC))
>         return false;
> 
> Clearly, this function will return false in case of a CRC error while
> receiving on a monitor interface.

Wait a moment, should it not be the other way around? ATH9K_RXERR_CRC
is removed from rx_stats->rs_status and the comment above
also says that DECRYPT and MIC errors are ignored normally, while
CRC is additionally ignored in monitor mode.

Are you 100% certain that you were able to receive corrupted
packets after removing ATH9K_RXERR_CRC above??
