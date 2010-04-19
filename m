Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45933 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0DSR5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 13:57:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 5/9] ath9k: reduce the bits_per_symbol table size, support more streams
Date: Mon, 19 Apr 2010 19:57:33 +0200
Message-Id: <1271699857-12366-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1271699857-12366-4-git-send-email-nbd@openwrt.org>
References: <1271699857-12366-1-git-send-email-nbd@openwrt.org>
 <1271699857-12366-2-git-send-email-nbd@openwrt.org>
 <1271699857-12366-3-git-send-email-nbd@openwrt.org>
 <1271699857-12366-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of increasing bits_per_symbol for supporting more streams, keep
it single-stream only and multiply the values by the numer of streams.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4078982..2237658 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -34,7 +34,7 @@
 
 #define OFDM_SIFS_TIME    	    16
 
-static u32 bits_per_symbol[][2] = {
+static u16 bits_per_symbol[][2] = {
 	/* 20MHz 40MHz */
 	{    26,   54 },     /*  0: BPSK */
 	{    52,  108 },     /*  1: QPSK 1/2 */
@@ -44,14 +44,6 @@ static u32 bits_per_symbol[][2] = {
 	{   208,  432 },     /*  5: 64-QAM 2/3 */
 	{   234,  486 },     /*  6: 64-QAM 3/4 */
 	{   260,  540 },     /*  7: 64-QAM 5/6 */
-	{    52,  108 },     /*  8: BPSK */
-	{   104,  216 },     /*  9: QPSK 1/2 */
-	{   156,  324 },     /* 10: QPSK 3/4 */
-	{   208,  432 },     /* 11: 16-QAM 1/2 */
-	{   312,  648 },     /* 12: 16-QAM 3/4 */
-	{   416,  864 },     /* 13: 64-QAM 2/3 */
-	{   468,  972 },     /* 14: 64-QAM 3/4 */
-	{   520, 1080 },     /* 15: 64-QAM 5/6 */
 };
 
 #define IS_HT_RATE(_rate)     ((_rate) & 0x80)
@@ -601,7 +593,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	u32 nsymbits, nsymbols;
 	u16 minlen;
 	u8 flags, rix;
-	int width, half_gi, ndelim, mindelim;
+	int width, streams, half_gi, ndelim, mindelim;
 
 	/* Select standard number of delimiters based on frame length alone */
 	ndelim = ATH_AGGR_GET_NDELIM(frmlen);
@@ -641,7 +633,8 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	if (nsymbols == 0)
 		nsymbols = 1;
 
-	nsymbits = bits_per_symbol[rix][width];
+	streams = HT_RC_2_STREAMS(rix);
+	nsymbits = bits_per_symbol[rix % 8][width] * streams;
 	minlen = (nsymbols * nsymbits) / BITS_PER_BYTE;
 
 	if (frmlen < minlen) {
@@ -1533,8 +1526,9 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 	pktlen = bf_isaggr(bf) ? bf->bf_al : bf->bf_frmlen;
 
 	/* find number of symbols: PLCP + data */
+	streams = HT_RC_2_STREAMS(rix);
 	nbits = (pktlen << 3) + OFDM_PLCP_BITS;
-	nsymbits = bits_per_symbol[rix][width];
+	nsymbits = bits_per_symbol[rix % 8][width] * streams;
 	nsymbols = (nbits + nsymbits - 1) / nsymbits;
 
 	if (!half_gi)
@@ -1543,7 +1537,6 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 		duration = SYMBOL_TIME_HALFGI(nsymbols);
 
 	/* addup duration for legacy/ht training and signal fields */
-	streams = HT_RC_2_STREAMS(rix);
 	duration += L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
 
 	return duration;
-- 
1.6.4.2

