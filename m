Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:59604 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941Ab2G2LLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 07:11:48 -0400
Message-ID: <50151A71.9010306@net.t-labs.tu-berlin.de> (sfid-20120729_131200_895250_E7216C3E)
Date: Sun, 29 Jul 2012 13:11:45 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 3/4] ath5k: Preserve tx power level requested
 from above on phy_init
References: <1343485971-31360-1-git-send-email-mickflemm@gmail.com> <1343485971-31360-3-git-send-email-mickflemm@gmail.com> <501404BE.7040606@net.t-labs.tu-berlin.de> <5014065B.7070909@net.t-labs.tu-berlin.de> <CAFtRNNzPnh_C2JqC4WjKrChn=QPcC4UG-8PigyGp4WLXuCb5GQ@mail.gmail.com>
In-Reply-To: <CAFtRNNzPnh_C2JqC4WjKrChn=QPcC4UG-8PigyGp4WLXuCb5GQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

 
> Anyway if readability is the issue we can just do something like
> 
> int txpower_halfdb = 0;
> 
> [...]
> 
> if(ah->power_level) {
>  txpower_halfdb = ah->power_level * 2;
> } else {
>  txpower_halfdb = AR5K_TUNE_MAX_TXPOWER;
> }
> 
> and then it'll look like this
> 
> ret = ath5k_hw_txpower(ah, channel, txpower_halfdb);


I like this way you proposed here. But it is quite personal and compact
wise the other version is in lead.

> > 
> (wouldn't it be weird if someone from above asked us
> what tx power was requested and we reply with max tx power ?).

you mean in case someone from above did never requested something but
ask us what was requested and we tell him that nothing was requested
thats why we use max tx_power ... makes more sense ? :)

I think once the reporting from the driver to mac80211 about the current
tx_power is there, it will be solved anyway.

Greetings Thomas
