Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:57257 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbaHZCND (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 22:13:03 -0400
Date: Mon, 25 Aug 2014 22:07:21 -0400
From: Jim Rees <rees@umich.edu>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi 35% loss rate after v3.16-rc5
Message-ID: <20140826020721.GA1490@umich.edu> (sfid-20140826_041309_535661_8FD908EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've got a Thinkpad x220 with iwlwifi Ultimate-N 6300 AGN. After v3.16-rc5
it became unusable due to 35% packet loss rate. If I revert these commits,
it works again:

dc271ee iwlwifi: mvm: disable CTS to Self
43d826c iwlwifi: dvm: don't enable CTS to self
e48393e iwlwifi: mvm: Fix broadcast filtering
a42c9fc Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag"
b3c063a iwlwifi: update the 7265 series HW IDs
8987941 iwlwifi: mvm: rework sched scan channel configuration

I can bisect further if that would be useful. Dmesg is here:
http://pastebin.com/wD3UMxUL

It's still broken in 3.17.0-rc2. Any suggestions?
