Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:37011 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412Ab2HEMhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 08:37:06 -0400
Message-ID: <501E68EE.1060000@net.t-labs.tu-berlin.de> (sfid-20120805_143711_531141_B575853F)
Date: Sun, 05 Aug 2012 14:37:02 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: nbd@nbd.name, jirislaby@gmail.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix wrong per rate target power
 eeprom reads for AR5K_EEPROM_MODE_11A
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de> <501CD9F3.4000903@net.t-labs.tu-berlin.de> <CAFtRNNzV+vwCcg7APcjUUA4f7zhphH4=v4KshUq5XYKWHmBdhQ@mail.gmail.com> <501E539A.9060706@net.t-labs.tu-berlin.de> <CAFtRNNyXgrzsB8Od+qqLgRSb3o_KkxD4sG3UOzu5C1Sz06-GkA@mail.gmail.com>
In-Reply-To: <CAFtRNNyXgrzsB8Od+qqLgRSb3o_KkxD4sG3UOzu5C1Sz06-GkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick

> According to EEPROM docs there are 10 calibration piers on all chips
> after 5111 for 11a but some of them are not used and the way to test
> this is if frequency is zero. Now here is a bug in the EEPROM code
> that might result the wrong reads you get, check this out:
> 
> on ath5k_eeprom_read_freq_list we do this
> 
> if (!freq1)
>  break;
> 
> instead of this
> 
> if (!freq1)
>  continue;


That did the trick !
So reading 10 calibration piers and using the fix from above works in
terms of tx_power changes on CM9 and DCMA82 are properly used by the
hardware.

I will send a patch for that.


Greetings Thomas

