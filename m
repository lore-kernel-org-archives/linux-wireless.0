Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35328 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933277Ab0CKQrn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 11:47:43 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NplXk-0005Mh-Qk
	for linux-wireless@vger.kernel.org; Thu, 11 Mar 2010 17:47:29 +0100
Received: from 56-12.dial.nortenet.pt ([212.13.56.12])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 17:47:28 +0100
Received: from subscriptions by 56-12.dial.nortenet.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 17:47:28 +0100
To: linux-wireless@vger.kernel.org
From: doddel <subscriptions@stroomer.com>
Subject: Re: ath9k: ar9220 does rx but no tx on antenna B
Date: Thu, 11 Mar 2010 16:46:57 +0000 (UTC)
Message-ID: <loom.20100311T174521-389@post.gmane.org>
References: <loom.20100308T002346-575@post.gmane.org> <69e28c911003071558v75cfe8aeq77644796a990434a@mail.gmail.com> <loom.20100308T101424-116@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some further experimentation revealed that in case of the ar9220 as applied on
the miniPCI board R52N (mikrotik) the observed behaviour is caused by ath9k's
function ath_update_chainmask (main.c) which sets the rx/tx_chainmasks to 1 in
case of any legacy (non-HT) mode. On the R52N the two antenna connectors
correspond 1:1 to the two RF processing chains which this function selects: 1
(legacy) or 3 (1+2) for HT.
Signals from chain 2 still are still received in legacy mode when it has an
antenna on chain 2 even though chain 1 is selected because the driver does not
disable fast diversity and the external RF circuitry remains active. But
transmission does only happen through chain 1.
Register values set at AR_PHY_SWITCH_CHAIN_0 and at AR_PHY_SWITCH_CHAIN_0+offset
on basis of eeprom info are identical, effectively eliminating the default
antenna setting as a means to distinguish between antennas. This is right in
this case as there are no antennas to switch between per RF processing chain.
Ath9k's decision to make HT modes force multiple antenna use is an
over-simplification. Communication with MCS index 0-7 (max. 150 Mbps@40MHz)
require only a single spatial stream and therefor can work with a single antenna.
Conclusions: 
Selection of a single antenna has to be done via setting the chainmask, while
optionally disabling diversity reception.
The number of available antennas and available parallel processing chains,
whichever the least, will determine the max. MCS index possible. 
A single antenna must be allowed for HT modes as up to MCS index 7 they can
still function. 
For protection of the non-terminated power amplifier(s) it is better to only
activate the txchains that have antennas i.s.o. all available chains.
An idea perhaps is to define a user setting antenna_mode with the bits [3:0]
defined as in ath5k and bits [7:4] an optional map of connected antennas; in
case [7:4]=0 the assumption could be fast diversity / mimo and antennas present
to the full of hardware capabilities. 

