Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:54659 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0INRaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 13:30:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 10:29:59 -0700
From: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
To: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 14 Sep 2010 22:55:41 +0530
Subject: RE: [PATCH] ath9k_hw: Enable fastcc support for AR7010
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C0@CHEXMB-01.global.atheros.com>
References: <1284454614-19944-1-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1284454614-19944-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Can you drop this patch ?
The same patch was already sent. Sorry for the inconvenience.

Thanks,
Rajkumar
________________________________________
From: Rajkumar Manoharan
Sent: Tuesday, September 14, 2010 2:26 PM
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org; Rajkumar Manoharan
Subject: [PATCH] ath9k_hw: Enable fastcc support for AR7010

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index afadade..0a61f42 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1258,7 +1258,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
            (chan->channel != ah->curchan->channel) &&
            ((chan->channelFlags & CHANNEL_ALL) ==
             (ah->curchan->channelFlags & CHANNEL_ALL)) &&
-           !AR_SREV_9280(ah)) {
+           (!AR_SREV_9280(ah) || AR_DEVID_7010(ah))) {

                if (ath9k_hw_channel_change(ah, chan)) {
                        ath9k_hw_loadnf(ah, ah->curchan);
--
1.7.2.3