Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45528 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab0GZRK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 13:10:57 -0400
Received: by eya25 with SMTP id 25so520898eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 10:10:56 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 Jul 2010 19:10:55 +0200
Message-ID: <AANLkTimWoSTAtb0m9V=0CNowhy=KtpiKj-O3vdmV8qxB@mail.gmail.com>
Subject: [RFC] ath9k: improve aggregation throughput by using only first rate
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I've been running a lot of iperf on AR913x /
compat-wireless-2010-07-16 (w/ openwrt/trunk@22388).

I think there are some (in theory) simple improvements that can be
done to the tx aggregation / rate control logic. A proof of concept of
one such improvement is provided below. Basically, it's a hack that
makes ath9k output aggregates with only the first rate in the rate
series. The reasoning is that a failure is not a problem for
aggregates because there is software retry. Retrying in hardware at a
slower rate is counter productive. So, better to fail and do a
software retry at possibly another rate. Also, since the aggregate
size is often limited by the slowest rate in the MRR series (4 ms txop
limit) having a slow rate in the series may affect performance even if
it is never used by the hardware.

In my (not so scientific) tests max AP downstream throughput increases
about 30-40% with the patch below (from 33.9 to 55.7 Mbit/s with HT20
in noisy environment with 20 meters and a few walls between AP and
client).

Of course, if all rates in the series are high then this patch has no effect.

/Björn
---
diff -urpN a/drivers/net/wireless/ath/ath9k/xmit.c
b/drivers/net/wireless/ath/ath9k/xmit.c
--- a/drivers/net/wireless/ath/ath9k/xmit.c	2010-07-26 15:35:17.000000000 +0200
+++ b/drivers/net/wireless/ath/ath9k/xmit.c	2010-07-26 17:11:33.000000000 +0200
@@ -565,7 +565,7 @@ static u32 ath_lookup_rate(struct ath_so
 	 */
 	max_4ms_framelen = ATH_AMPDU_LIMIT_MAX;

-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < 1; i++) {
 		if (rates[i].count) {
 			int modeidx;
 			if (!(rates[i].flags & IEEE80211_TX_RC_MCS)) {
@@ -1553,6 +1553,9 @@ static void ath_buf_set_rate(struct ath_
 	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
 		ctsrate |= rate->hw_value_short;

+	if (bf_isaggr(bf))
+		rates[1].count = rates[2].count = rates[3].count = 0;
+
 	for (i = 0; i < 4; i++) {
 		bool is_40, is_sgi, is_sp;
 		int phy;
