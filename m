Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35654 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbbHMMcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:32:06 -0400
Received: by lbcbn3 with SMTP id bn3so25967757lbc.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 05:32:04 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: arnd@arndb.de, twilightrook@gmail.com, vvanpo@gmail.com,
	linux-wireless@vger.kernel.org, oscarrydberg@gmail.com,
	joseph.salisbury@canonical.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 0/2] ath10k: add qca6164 support
Date: Thu, 13 Aug 2015 14:32:25 +0200
Message-Id: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com> (sfid-20150813_143210_497246_8406BFBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

Looks like ath10k is very close to finally support
qca6164. Recent discussion[1] led to a working
prototype[2][3].

I'm CCing everyone I've found in my mailbox that
complained about QCA6164 not working. Hopefully I
did not miss anyone.

I would really like to know if this patchset (in
its current shape and form) of mine works for any
of you who owns QCA6164. If it doesn't please try
Patch [1/2] only.

Today Kalle posted QCA6174 (which is actually
QCA61X4) firmware binary for ath10k[4]. Please use
it to test QCA6164 (i.e. don't use sumdog's
firmware nor your own assembled one).

However QCA6164 requires a different board.bin
file[3]. This requires some additional changes in
ath10k to support sanely but *for now* you can use
board file vvanpo extracted from window driver[5]
and place it as:

  /lib/firmware/ath10k/QCA6174/hw2.1/board-pci-168c:0041:17aa:3545.bin

This should work. If it doesn't, try replacing the
existing board.bin - if you'll need to do please
let me/us know and post the boot string which
looks like this:

  ath10k_pci 0000:03:00.0: qca6174 hw2.1 (0x05010000, 0x003405ff, 168c:0041:17aa:3545 fallback) fw killer-n1525-fw api 5 htt-ver 0.0 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1 features

My guess is some devices may have different
subsystem product/vendor ids. It'll be good to
know at least a subset of those for reference.

[1]: http://lists.infradead.org/pipermail/ath10k/2015-August/005752.html
[2]: https://github.com/atondwal/linux/commits/fork-ath
[3]: http://lists.infradead.org/pipermail/ath10k/2015-August/005811.html
[4]: http://lists.infradead.org/pipermail/ath10k/2015-August/005825.html
[5]: https://github.com/atondwal/ath10k-firmware/blob/88fca85ef59d708b9874e5b7885416b58aef9ee7/ath10k/QCA6164/hw2.1/board.bin


Michal Kazior (2):
  ath10k: add qca6164 support
  ath10k: rename qca6174 to qca61x4

 drivers/net/wireless/ath/ath10k/core.c      | 71 +++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/core.h      |  1 +
 drivers/net/wireless/ath/ath10k/hw.c        |  4 +-
 drivers/net/wireless/ath/ath10k/hw.h        | 70 +++++++++++++-------------
 drivers/net/wireless/ath/ath10k/pci.c       | 77 +++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.h       |  2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h   |  4 +-
 drivers/net/wireless/ath/ath10k/targaddrs.h |  4 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h   |  2 +-
 9 files changed, 130 insertions(+), 105 deletions(-)

-- 
2.1.4

