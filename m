Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933690AbcK2O7t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 09:59:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2016-11-29
Date: Tue, 29 Nov 2016 16:59:44 +0200
Message-ID: <87r35utjq7.fsf@kamboji.qca.qualcomm.com> (sfid-20161129_155958_854731_5267EB90)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

if there's still time here's one more patch to 3.9. I think this is good
to have in 3.9 as it fixes an issue where we were printing uninitialised
memory in mwifiex. I had this in wireless-drivers already for some time
as I was waiting for other fixes and nothing serious actually came up.

If this doesn't make it to 3.9 that's not a problem, I'll just merge
this to wireless-drivers-next. Let me know what you prefer.

Kalle

The following changes since commit d3532ea6ce4ea501e421d130555e59edc2945f99:

  brcmfmac: avoid maybe-uninitialized warning in brcmf_cfg80211_start_ap (2016-10-27 18:04:54 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2016-11-29

for you to fetch changes up to fcd2042e8d36cf644bd2d69c26378d17158b17df:

  mwifiex: printk() overflow with 32-byte SSIDs (2016-11-17 13:16:52 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.9

mwifiex

* properly terminate SSIDs so that uninitalised memory is not printed

----------------------------------------------------------------
Brian Norris (1):
      mwifiex: printk() overflow with 32-byte SSIDs

 drivers/net/wireless/marvell/mwifiex/cfg80211.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)
