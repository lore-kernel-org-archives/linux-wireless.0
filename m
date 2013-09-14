Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:33026 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab3INQKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Sep 2013 12:10:17 -0400
Message-ID: <52348A2D.8000008@ilande.co.uk> (sfid-20130914_181021_916749_6696CDA8)
Date: Sat, 14 Sep 2013 17:09:17 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: rtl8192cu: notes on investigating power issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

I spent some time yesterday evening adding various debugging statements 
around the driver to get a feel for what was happening, with some 
success. Included below are my notes from testing.

The key appears to be the calculation of the dig (transmitter gain?) 
value, for which the function chain looks like this:

1) rtl92c_dm_ctrl_initgain_by_rssi() sets the dig value

This value controls the power output from the transmitter and should lie 
between DM_DIG_MIN and DM_DIG_MAX (note the *higher* the number, the 
*lower* the power output). Setting the penultimate line to read 
"digtable->cur_igvalue = DM_DIG_MIN" appears to force maximum power and 
actually gives me a working connection.

Displaying various values in this function showed that the problem was 
that I had an exceptionally high value of digtable->rssi_val_min which 
was much higher than DM_DIG_MAX and so had the effect of disabling the 
radio.

2) rtl92c_dm_dynamic_bb_powersaving() sets digtable->rssi_val_min

This is actually done by a simple assignment "dm_pstable->rssi_val_min = 
rtlpriv->dm.undec_sm_pwdb".

3) _rtl92c_process_pwdb() sets rltpriv->dm.undec_sm_pwdb

This value is updated by comparing the existing value with the current 
value of pstats->rx_pwdb_all. If there is a difference, then slide the 
new value towards pstats->rx_pwdb_all and then use it to update 
rltpriv->dm.undec_sm_pwdb.

4) _rtl92c_query_rxphystatus() sets pstats->rx_pwdb_all

pstats->rx_pwdb_all was set to be a percentage conversion of the current 
antenna power read from the radio.

What was happening in my case:

1) pstats->rx_pwdb_all was mostly set to 100 (%) due to high signal strength

2) rltpriv->dm.undec_sm_pwdb would then slide towards a high value 
(around 0x40-0x4d) within a few seconds

3) Hence digtable->rssi_val_min would tend to hover at around the same level

4) digtable->cur_igvalue would be set to the same high value (> 0x3f or 
DM_DIG_MAX), therefore disabling the radio and disconnecting from the AP


Unfortunately I'm not particularly familiar with these types of power 
calculations (and there weren't many comments explaining how they 
worked), but the one thing that didn't seem right is that 
pstats->rx_pwdb_all claims to be a *percentage* and yet 
rtl92c_dm_dynamic_bb_powersaving() uses it as the basis to set the 
*value* of dm_pstable->rssi_val_min.


ATB,

Mark.
