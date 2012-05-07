Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:52018 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab2EGTGy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 15:06:54 -0400
Date: Mon, 7 May 2012 21:06:48 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt28xx: Revert
 eccc068e8e84c8fe997115629925e0422a98e4de which causes txpower to be stuck
 at 0
Message-ID: <20120507190648.GA5472@yumi.tdiedrich.de> (sfid-20120507_210658_330271_C1D6818B)
References: <20120506153806.GF2774@yumi.tdiedrich.de>
 <CAGXE3d8X3FLoUEjmg+13ggCzVdDHncpr7uwwLweSb+4r87jRpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d8X3FLoUEjmg+13ggCzVdDHncpr7uwwLweSb+4r87jRpQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa wrote:
> Luis, with rt2800 we are not really able to provide an accurate max tx power :(
> so, can we restore the previous behavior in reg.c? Or maybe do something like
> 
> if (chan->max_reg_power)
>   chan->max_power = min(chan->max_power, chan->max_reg_power);
> 
> Tobias, does that work for you as well?

Nope, the problem is that chan->max_power is 0, so this will work:

if (chan->max_power == 0)
  chan->max_power = chan->max_reg_power;
else
  chan->max_power = min(chan->max_power, chan->max_reg_power);

Also, in the if-branch above that chan->max_reg_power is never set, I
wonder if that should be

chan->max_power = chan->orig_mpwr = chan->max_reg_power =
  (int) MBM_TO_DBM(power_rule->max_eirp);

instead of

chan->max_power = chan->orig_mpwr =
  (int) MBM_TO_DBM(power_rule->max_eirp);

(But I don't seem to hit that if-block juding from some printks I added)

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
