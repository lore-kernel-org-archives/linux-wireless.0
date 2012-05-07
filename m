Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57908 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab2EGJZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 05:25:15 -0400
Received: by yhmm54 with SMTP id m54so3965240yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 02:25:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120506153806.GF2774@yumi.tdiedrich.de>
References: <20120506153806.GF2774@yumi.tdiedrich.de>
Date: Mon, 7 May 2012 11:25:14 +0200
Message-ID: <CAGXE3d8X3FLoUEjmg+13ggCzVdDHncpr7uwwLweSb+4r87jRpQ@mail.gmail.com> (sfid-20120507_112520_322167_2C4D1BD4)
Subject: Re: [OpenWrt-Devel] [PATCH] rt28xx: Revert eccc068e8e84c8fe997115629925e0422a98e4de
 which causes txpower to be stuck at 0
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Cc: linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 6, 2012 at 5:38 PM, Tobias Diedrich
<ranma+openwrt@tdiedrich.de> wrote:
> Revert eccc068e8e84c8fe997115629925e0422a98e4de which causes txpower
> to be stuck at 0.
>
> Recent OpenWRT has txpower stuck at 0 for at least rt28xx, and I
> found this commit as the root cause:
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
>
> Before reverting this "iw phy phy0 info" would show "0.0 dBm" as
> maximum transmit power for all frequencies.
>
> After reverting this (and with regdomain set to CH) it is back to
> the expected 20 dBm.
>
>
> Signed-off-by: Tobias Diedrich <ranma+openwrt@tdiedrich.de>

Ok, the problem seems to come from the fact that rt2800 doesn't
register a per channel
max power to mac80211.

Luis, with rt2800 we are not really able to provide an accurate max tx power :(
so, can we restore the previous behavior in reg.c? Or maybe do something like

if (chan->max_reg_power)
  chan->max_power = min(chan->max_power, chan->max_reg_power);

Tobias, does that work for you as well?

Thanks,
Helmut
