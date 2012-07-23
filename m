Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:54135 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481Ab2GWSZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 14:25:28 -0400
Message-ID: <500D9716.10300@net.t-labs.tu-berlin.de> (sfid-20120723_202531_618347_07A41264)
Date: Mon, 23 Jul 2012 20:25:26 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: jirislaby@gmail.com, johannes.berg@intel.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, nbd@nbd.name
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: fix phy_init() to respect user
 txpower changes
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de> <20120723164250.GA11893@localhost>
In-Reply-To: <20120723164250.GA11893@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

Bob Copeland schrieb:

> On Mon, Jul 23, 2012 at 06:01:15PM +0200, Thomas Huehn wrote:
>>  	/* Setup rate power table */
>> -	ath5k_setup_rate_powertable(ah, txpower, &rate_info, ee_mode);
>> +	ath5k_setup_rate_powertable(ah, ah->ah_txpower.txp_user_pwr, &rate_info, ee_mode);
> 
> txpower used to be .5 dB units -- is it still?

ah->ah_txpower.txp_user_pwr is now in 1dB units, as it is triggered from
mac802.11

>> -	ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
>> -			ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
>> +	ret = ath5k_hw_txpower(ah, channel);
>> +
> 
> Did this / 2 move elsewhere or was it wrong before?  Is txp_cur_pwr still
> used for anything?

the "/2" is not needed anymore as I also skipped the "*2" in
ath5k_hw_set_txpower_limit .. so I avoid this calculations.

Felix is goint to use txp_cur_pwr, so for now it is not used ... maybe
he can explain where it will be needed.

Greetings Thomas


