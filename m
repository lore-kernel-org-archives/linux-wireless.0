Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44718 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0H0TDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 15:03:16 -0400
Received: by yxg6 with SMTP id 6so1234320yxg.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Aug 2010 12:03:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282934606-4169-1-git-send-email-lrodriguez@atheros.com>
References: <1282934606-4169-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 27 Aug 2010 12:02:55 -0700
Message-ID: <AANLkTi=6WGrMJ7SNpoXhF77F76sxVr0Hp+T6QO21+Frr@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix drop of multicast / broadcast data during scan
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Amod Bodas <Amod.Bodas@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 11:43 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> mac80211's scan implementation puts the burden of processing the DTIM
> count on drivers to accurately disallow scanning during certain wait
> constraints. ath9k was allowing to change channel while a few of these
> wait constraints were still in effect causing some drop of buffered
> broadcast and multicast traffic. Fix this by checking for the wait
> constraints prior to switching channels.
>
> This is tested against a Cisco E3000 AP configued with a DTIM Interval of 2
> and beacon interval of 1000. Then setup ath9k to receive multicast
> traffic:
>
>  user@ath9k-RX-box $ iperf -s -u -B 224.0.55.55 -i 1
>
> On the transmit multicast box connected to the same AP:
>
>  user@ath9k-TX-box $ while true ; do iperf -c 224.0.55.55 \
>        -u -T 32 -t 3 -i 1 -b 10M -t 1000; sleep 2 ; done
>
> Without this patch we would otherwise loose that data. You can verify we run into
> this by enabling the ATH_DBG_PS (0x800) when loading ath9k.
>
> Cc: stable@kernel.org
> Cc: Amod Bodas <Amod.Bodas@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Sorry ignore this, Jouni noted this would break handling of off
channel operation, amongst other things. Will work on the more proper
solution by letting drivers inform mac80211 of these wait constraints.

  Luis
