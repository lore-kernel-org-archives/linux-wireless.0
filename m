Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:36983 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243Ab2HELGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 07:06:04 -0400
Message-ID: <501E539A.9060706@net.t-labs.tu-berlin.de> (sfid-20120805_130646_562259_FFDB4BB0)
Date: Sun, 05 Aug 2012 13:06:02 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: nbd@nbd.name, jirislaby@gmail.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix wrong per rate target power
 eeprom reads for AR5K_EEPROM_MODE_11A
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de> <501CD9F3.4000903@net.t-labs.tu-berlin.de> <CAFtRNNzV+vwCcg7APcjUUA4f7zhphH4=v4KshUq5XYKWHmBdhQ@mail.gmail.com>
In-Reply-To: <CAFtRNNzV+vwCcg7APcjUUA4f7zhphH4=v4KshUq5XYKWHmBdhQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

> There is nothing suspicious about it, it's what EEPROM docs say:
> 
> a) For 11a mode there are 10 calibration peers 


As I tested AR5413, AR5414 and AR5213 there are only 8 eeprom lines for
802.11a that provide valid per rate target power levels. I am curious if
this also holds for other chips.

> Also what do you mean wrong curve and how did you actually test your
> card and measured the tx power ?
> 


My first patch only changed the read iterations in function
ath5k_eeprom_read_target_rate_pwr_info() from 10 reads to 8. Having only
this, I measured received rssi values while changing the tx_power on a
sender. I did not observe any changes in rssi, so I went back to the
code to investigate.
And the function ath5k_eeprom_init_11a_pcal_freq() (my hardware eeprom
version is > 3.3) there is ath5k_eeprom_read_freq_list(..,10,..) called,
and those 10 iterations produce 2 wrong frequency peer values. If there
are only 8 iterations used, I am able to measure a 15 dB variation in
rssi values at the receiver side, while changing the tx_power on the
sender. For the chips I tested, ath5k_eeprom_read_freq_list() should
only read 8 pears for 802.11a.

With 'suspicious' I meant e.g. function
ath5k_eeprom_init_11a_pcal_freq(), as it checks the eeprom version and
if > 3.3 it calls
ath5k_eeprom_init_11a_pcal_freq(..,AR5K_EEPROM_N_5GHZ_CHAN,..), in the
else case, it reads 10 hardcoded freq.pears .. I am questioning if this
is correct, so maybe someone has the chance to test this.


Greetings Thomas
