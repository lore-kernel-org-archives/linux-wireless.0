Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:56444 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab2GYXkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 19:40:40 -0400
Message-ID: <501083F6.8060002@net.t-labs.tu-berlin.de> (sfid-20120726_014043_983373_A44E51A6)
Date: Thu, 26 Jul 2012 01:40:38 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: jirislaby@gmail.com, johannes.berg@intel.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, nbd@nbd.name
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: fix phy_init() to respect user
 txpower changes
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de> <CAFtRNNwY-1JLEJa_qZpUfsyQVdUQLO3CWcEB9xef-g5jPzndNQ@mail.gmail.com> <50107C35.9050807@net.t-labs.tu-berlin.de> <CAFtRNNz2qG5Fsjd1WVfA-BOSPGZ=WvMzrMwyqn8d6tfiBpkSVw@mail.gmail.com>
In-Reply-To: <CAFtRNNz2qG5Fsjd1WVfA-BOSPGZ=WvMzrMwyqn8d6tfiBpkSVw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

Nick Kossifidis schrieb:

> 2012/7/26 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:

> There is nothing in your patch that suggests that's related to this.
> Anyway there's a simple way to fix this:
> 
> Just move this:
> 
> 3575         /* Min/max in 0.25dB units */
> 3576         ah->ah_txpower.txp_min_pwr = 2 * rates[7];
> 3577         ah->ah_txpower.txp_cur_pwr = 2 * rates[0];
> 3578         ah->ah_txpower.txp_ofdm = rates[7];
> 
> above the for loop and you are done.
> 
> Note rates[i] don't hold tx power values, they hold indices to the
> channel powertable.
> 


Are you agreeing that current ath5k txpower handling set from user space
is not working and we need to fix it ?
Beside that, what about a channel switch and wrongly re-use txp_cur_pwr
on a channel witch other max power levels ?

Lets wait on Felix opinion what he has in mind.

Greetings Thomas
