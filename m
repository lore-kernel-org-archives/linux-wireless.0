Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:55002 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab0EZRp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:45:58 -0400
Received: by pxi18 with SMTP id 18so2635034pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 10:45:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFD555C.4060205@nets.rwth-aachen.de>
References: <4BFD04A4.4000403@nets.rwth-aachen.de> <4BFD555C.4060205@nets.rwth-aachen.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 10:45:37 -0700
Message-ID: <AANLkTimnQMwO6FccrpLXyewYOiHL-XTAphgZgBFza1jP@mail.gmail.com>
Subject: Re: regulatory problems with ath5k
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 10:07 AM, Arnd Hannemann
<hannemann@nets.rwth-aachen.de> wrote:
> Hi,
>
> FWI: I believe this whole regulatory framework is pretty broken in 2.6.34
> If I associate with a 802.11g accesspoint with one NIC , I'm not allowed
> to use 802.11a on my other NIC at all.
>
> [   23.352168] wlan0: associated
> [   23.355993] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   23.375106] cfg80211: Calling CRDA for country: DE
> [   23.412542] cfg80211: Current regulatory domain updated by AP to: DE
> [   23.431728]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [   23.454319]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 1800 mBm)
>
> # iw reg get
> country 98:
>    (2402 - 2482 @ 40), (N/A, 18)
>
> ???

No, although that may be your regulatory domain cfg80211 will not
disable 5 GHz if you already had it enabled and your AP provided a
country IE with only 2 GHz rules. Check 'iw list' both before and
after you associate.

  Luis
