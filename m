Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:56360 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062Ab2GYWBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 18:01:06 -0400
Message-ID: <50106C9F.3050504@net.t-labs.tu-berlin.de> (sfid-20120726_000111_306590_CA2E88AE)
Date: Thu, 26 Jul 2012 00:01:03 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: jirislaby@gmail.com, johannes.berg@intel.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, nbd@nbd.name
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix wrong per rate target power
 eeprom reads for AR5K_EEPROM_MODE_11A
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de> <CAFtRNNx+YgGgFp_owGQJcsQVqTuOeWk2J0MwjKMtcUgRq_DF0w@mail.gmail.com>
In-Reply-To: <CAFtRNNx+YgGgFp_owGQJcsQVqTuOeWk2J0MwjKMtcUgRq_DF0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

Nick Kossifidis schrieb:

> Thanks for catching this but the bug is elsewhere:

> So guess why the last 2 "invalid" power gain values have the same
> power levels for all rates ? They are for XR mode (they've put it
> there on the eeprom because XR mode also operates at 5GHz) and since
> XR stuff is stripped off Madwifi (at least the public HAL) that's why
> it only reads 8 of the piers.
> 
> Now notice that the last 2 readings on your previous post start from a
> different frequency and most important that 5360 < 5825  and that
> makes sense since the idea is to have only 2 points to interpolate
> between them for the whole XR range. So we have 2 frequency "ranges"
> to search, the one  is the 11a mode from 4920 to 5825 and the other
> one is for XR mode from 5360 to 5720. When the first range ends the
> other starts.
> 
> The bug is here:
> 
> ath5k_get_rate_pcal_data:
> 2704         max = ee->ee_rate_target_pwr_num[mode] - 1;
> [...]
> 2713         if (target > rpinfo[max].freq) {
> 2714                 idx_l = idx_r = max;
> 2715                 goto done;
> 2716         }
> 
> So please instead of tweaking the EEPROM code just change
> max = ee->ee_rate_target_pwr_num[mode] - 1;
> to
> max = ee->ee_rate_target_pwr_num[mode] - 3;
> in case of AR5K_MODE_11A 


The calibration data for 802.11a in the standard conform mode should
only consider 8 reads from the eeprom, thats why I introduced this new
define... a "-3" is from my view of readability not as traceable.
Any other non standard mode as you mentioned XR as one of, could just
ready its necessary lines of the eeprom ones it get supported in ath5k.

Greetings Thomas
