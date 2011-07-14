Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:46739 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab1GNMu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 08:50:57 -0400
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QhL1Q-0005WE-TM
	for linux-wireless@vger.kernel.org; Thu, 14 Jul 2011 14:28:05 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QhL1P-0008PD-Np
	for linux-wireless@vger.kernel.org; Thu, 14 Jul 2011 14:28:03 +0200
Date: Thu, 14 Jul 2011 14:28:03 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: carl9170 firmware: WoWLAN and adding fields to carl9170_tx_superdesc
Message-ID: <20110714122803.GA31692@zenon.in.qult.net> (sfid-20110714_145100_525642_F13AEBA6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm still working on an extension of the carl9170 firmware to enable TX
service time measurements.  This implies the addition of a u32 field to
carl9170_tx_superdesc to record the TSF value at the time the frame is
received by the firmware.

The problem with WoWLAN, more specifically with changes introduced by
af915846d44d23adc02c7ded807282d607b46faa, is that adding that field makes
carl9170_sram_reserved::cmd larger than CARL9170_MAX_CMD_LEN.

I still don't see an easy way out other than disabling WoWLAN altogether.  If
anyone has any suggestion, I'd be happy to read it.

BTW, I noticed something that may be a bug in wlan.c, in
wlan_wol_connection_monitor(void)'s definition:

  memset(nullf, 0, sizeof(nullf));

Shouldn't that be

  memset(nullf, 0, sizeof *nullf);

instead?

Cheers,

Ignacy

-- 
To err is human, to moo bovine.
