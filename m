Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:48765 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0B0FpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 00:45:01 -0500
Received: from [192.168.0.22] (unknown [72.92.88.10])
	by smtprelay1.cesmail.net (Postfix) with ESMTPSA id A0C9034C69
	for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 00:44:44 -0500 (EST)
Subject: Using asynchonous block cipher for CCMP
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Feb 2010 00:44:34 -0500
Message-Id: <1267249474.6278.23.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm looking for ways to accelerate CCMP on Intel IXP425.

drivers/crypto/ixp4xx_crypto.c implements only asynchronous block
ciphers, and the reason appears to be that the crypto processor uses DMA
and interrupts to communicate with the CPU, which would make synchronous
encryption ineffective.

It turns out that mac80211 uses plain AES for CCMP.  However, it uses an
asynchronous block cipher "ecb(arc4)" for WEP and TKIP.

I'd like to make CCMP use an asynchronous block cipher.  Has anyone
attempted that?  Are there any issues I should be aware of?

-- 
Regards,
Pavel Roskin
