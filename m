Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:39679 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaFMXPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 19:15:00 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so3501097wes.14
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2014 16:14:59 -0700 (PDT)
Message-ID: <539B85F0.3090004@gmail.com> (sfid-20140614_011504_664717_150B64C7)
Date: Sat, 14 Jun 2014 01:14:56 +0200
From: Mathy Vanhoef <vanhoefm@gmail.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 2/2] ath5k: capture CCK and OFDM restarts
References: <539B7019.1050801@gmail.com> <539B7639.30104@openwrt.org>
In-Reply-To: <539B7639.30104@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/06/2014 0:07, Felix Fietkau wrote:
> On 2014-06-13 23:41, Mathy Vanhoef wrote:
>> Hi all,
>>
>> This patch allows users to see CCK and OFDM restarts when FIF_FCSFAIL is set.
>> Without this patch only the stronger frame (causing the restart) would be
>> visible.
>>
>> The patch has been tested using our reactive jammer. The prefix of the weaker
>> frame is being correctly passed on as a frame with bad CRC!
>> --
>> From: "Mathy Vanhoef" <vanhoefm@gmail.com>
>>
>> Treat frames that underwent a CCK or OFDM restart as frames with an invalid CRC.
>>
>> Signed-off-by: Mathy Vanhoef <vanhoefm@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath5k/base.c | 14 +++++++++++++-
>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>> index 39ba642..1bbc850 100644
>> --- a/drivers/net/wireless/ath/ath5k/base.c
>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>> @@ -1462,7 +1462,19 @@ ath5k_receive_frame_ok(struct ath5k_hw *ah, struct ath5k_rx_status *rs)
>>  			ah->stats.rxerr_phy++;
>>  			if (rs->rs_phyerr > 0 && rs->rs_phyerr < 32)
>>  				ah->stats.rxerr_phy_code[rs->rs_phyerr]++;
>> -			return false;
>> +
>> +			/*
>> +			 * Threat packets that underwent a CCK of OFDM reset as having a bad CRC.
>> +			 * These restarts happen when the radio resynchronizes to a stronger frame
>> +			 * while receiving a weaker frame. Here we receive the prefix of the weak
>> +			 * frame. Since these are incomplete packets, mark their CRC as invalid.
>> +			 */
>> +			if (rs->rs_phyerr == AR5K_RX_PHY_ERROR_OFDM_RESTART ||
>> +			    rs->rs_phyerr == AR5K_RX_PHY_ERROR_CCK_RESTART) {
>> +				rs->rs_status |= AR5K_RXERR_CRC;
>> +				rs->rs_status &= (~AR5K_RXERR_PHY);
> Unnecessary braces
> 
>> +			}
> What about the return statement you removed, shouldn't you add that back
> for the 'else' case?
> 
> - Felix
> 

Just saw a spelling mistake in the comment, s/Threat/Treat.

The parenthesis around `(~AR5K_RXERR_PHY)` can indeed be removed. I suppose it's best to keep the return statement (I don't know precisely why it appears so early in the function, but it likely has a good reason). Updated patch is included below.
--
From: "Mathy Vanhoef" <vanhoefm@gmail.com>

Treat frames that underwent a CCK or OFDM restart as frames with an invalid CRC.

Signed-off-by: Mathy Vanhoef <vanhoefm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4b18434..6e7c636 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1457,7 +1457,20 @@ ath5k_receive_frame_ok(struct ath5k_hw *ah, struct ath5k_rx_status *rs)
 			ah->stats.rxerr_phy++;
 			if (rs->rs_phyerr > 0 && rs->rs_phyerr < 32)
 				ah->stats.rxerr_phy_code[rs->rs_phyerr]++;
-			return false;
+
+			/*
+			 * Treat packets that underwent a CCK of OFDM reset as having a bad CRC.
+			 * These restarts happen when the radio resynchronizes to a stronger frame
+			 * while receiving a weaker frame. Here we receive the prefix of the weak
+			 * frame. Since these are incomplete packets, mark their CRC as invalid.
+			 */
+			if (rs->rs_phyerr == AR5K_RX_PHY_ERROR_OFDM_RESTART ||
+			    rs->rs_phyerr == AR5K_RX_PHY_ERROR_CCK_RESTART) {
+				rs->rs_status |= AR5K_RXERR_CRC;
+				rs->rs_status &= ~AR5K_RXERR_PHY;
+			} else {
+				return false;
+			}
 		}
 		if (rs->rs_status & AR5K_RXERR_DECRYPT) {
 			/*
-- 
1.8.1.2
