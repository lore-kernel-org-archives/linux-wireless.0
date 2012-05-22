Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2EVQwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 12:52:54 -0400
Date: Tue, 22 May 2012 11:52:51 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: BCM4331 tx failures after S3
Message-ID: <20120522165251.GA31347@thinkpad-t410> (sfid-20120522_185258_717960_720CAAA1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I've inquired about this issue on the list once before, but I thought
I'd try once again to see if Broadcom can offer any suggestions.

Recent MacBook Pros with BCM4331 wireless have a strange problem. Tx
doesn't work after S3, but only if no external power is applied during
the resume. mac80211 reports mostly timeouts for responses to probe
requests, but analysis with wireshark shows no frames from the BCM4331
on the air. The only way I've found to recover is to reload both b43 and
bcma; reloading b43 alone is not enough.

I've checked the values of MACCTL and the DMA TXCTL registers, since
these are the ones used by brcmsmac to mute tx, but those look okay. Any
suggestions of other things to check? My next step would be to start
looking at the state of the phy and radio, but since we don't have much
information about what the registers there actually do some suggestions
would be helpful.

Thanks,
Seth
