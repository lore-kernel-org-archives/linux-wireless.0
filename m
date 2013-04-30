Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:63879 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759146Ab3D3Ih1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 04:37:27 -0400
Message-ID: <517F82C5.6020000@tieto.com> (sfid-20130430_103736_835865_972CD9EB)
Date: Tue, 30 Apr 2013 10:37:25 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Fragmented RX with CCMP in mac80211
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

mac80211 does some checks for defragmentation if the cipher is CCMP and 
if a frame has the Protected bit set.

If a driver offloads decryption should it also strip the protected flag 
to avoid this check (it fails for our driver if we don't strip the flag)?

b43 seems to strip the Protected bit flag.


-- Pozdrawiam / Best regards, Michal Kazior.
