Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:49221 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942Ab3E0NKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 09:10:00 -0400
Received: by mail-ea0-f175.google.com with SMTP id h10so3810617eaj.34
        for <linux-wireless@vger.kernel.org>; Mon, 27 May 2013 06:09:59 -0700 (PDT)
Message-ID: <1369660192.8283.24.camel@canaries64> (sfid-20130527_151006_264582_43FB5AF2)
Subject: [PATCH 5/5] staging: vt6656: rf.c: Remove camel case from local
 variables
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 14:09:52 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes;
Static declaration
abyAL2230InitTable -> al2230_init_table
abyAL2230ChannelTable0 -> al2230_channel_table0
abyAL2230ChannelTable1 -> al2230_channel_table1

abyAL7230InitTable -> al7230_init_table_amode
abyAL7230ChannelTable0 -> al7230_channel_table0
abyAL7230ChannelTable1 -> al7230_channel_table1
abyAL7230ChannelTable2 -> al7230_channel_table2

abyVT3226_InitTable -> at3226_init_table
abyVT3226D0_InitTable -> at3226d0_init_table
abyVT3226_ChannelTable0 -> vt3226_channel_table0
abyVT3226_ChannelTable1 -> vt3226_channel_table1

abyVT3342A0_InitTable -> vt3342a0_init_table
abyVT3342_ChannelTable0 -> vt3342_channel_table0
abyVT3342_ChannelTable1 -> vt3342_channel_table1

Constant declaration
dwVT3226D0LoCurrentTable -> vt3226d0_lo_current_table

dwAL2230PowerTable -> al2230_power_table


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 76 ++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 6deeffe..d27fa43 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -64,7 +64,7 @@ static int          msglevel                =MSG_LEVEL_INFO;
 #define VT3342_PWR_IDX_LEN    64
 //}}
 
-u8 abyAL2230InitTable[CB_AL2230_INIT_SEQ][3] = {
+static u8 al2230_init_table[CB_AL2230_INIT_SEQ][3] = {
     {0x03, 0xF7, 0x90},
     {0x03, 0x33, 0x31},
     {0x01, 0xB8, 0x02},
@@ -82,7 +82,7 @@ u8 abyAL2230InitTable[CB_AL2230_INIT_SEQ][3] = {
     {0x00, 0x58, 0x0F}
     };
 
-u8 abyAL2230ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
+static u8 al2230_channel_table0[CB_MAX_CHANNEL_24G][3] = {
     {0x03, 0xF7, 0x90}, // channel = 1, Tf = 2412MHz
     {0x03, 0xF7, 0x90}, // channel = 2, Tf = 2417MHz
     {0x03, 0xE7, 0x90}, // channel = 3, Tf = 2422MHz
@@ -99,7 +99,7 @@ u8 abyAL2230ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
     {0x03, 0xE7, 0xC0}  // channel = 14, Tf = 2412M
     };
 
-u8 abyAL2230ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
+static u8 al2230_channel_table1[CB_MAX_CHANNEL_24G][3] = {
     {0x03, 0x33, 0x31}, // channel = 1, Tf = 2412MHz
     {0x0B, 0x33, 0x31}, // channel = 2, Tf = 2417MHz
     {0x03, 0x33, 0x31}, // channel = 3, Tf = 2422MHz
@@ -118,7 +118,7 @@ u8 abyAL2230ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
 
 // 40MHz reference frequency
 // Need to Pull PLLON(PE3) low when writing channel registers through 3-wire.
-u8 abyAL7230InitTable[CB_AL7230_INIT_SEQ][3] = {
+static u8 al7230_init_table[CB_AL7230_INIT_SEQ][3] = {
     {0x20, 0x37, 0x90}, // Channel1 // Need modify for 11a
     {0x13, 0x33, 0x31}, // Channel1 // Need modify for 11a
     {0x84, 0x1F, 0xF2}, // Need modify for 11a: 451FE2
@@ -141,7 +141,7 @@ u8 abyAL7230InitTable[CB_AL7230_INIT_SEQ][3] = {
     {0x1A, 0xBA, 0x8F} // Need modify for 11a: 12BACF
     };
 
-u8 abyAL7230InitTableAMode[CB_AL7230_INIT_SEQ][3] = {
+static u8 al7230_init_table_amode[CB_AL7230_INIT_SEQ][3] = {
     {0x2F, 0xF5, 0x20}, // Channel184 // Need modify for 11b/g
     {0x00, 0x00, 0x01}, // Channel184 // Need modify for 11b/g
     {0x45, 0x1F, 0xE2}, // Need modify for 11b/g
@@ -160,7 +160,7 @@ u8 abyAL7230InitTableAMode[CB_AL7230_INIT_SEQ][3] = {
     {0x12, 0xBA, 0xCF} // Need modify for 11b/g
     };
 
-u8 abyAL7230ChannelTable0[CB_MAX_CHANNEL][3] = {
+static u8 al7230_channel_table0[CB_MAX_CHANNEL][3] = {
     {0x20, 0x37, 0x90}, // channel =  1, Tf = 2412MHz
     {0x20, 0x37, 0x90}, // channel =  2, Tf = 2417MHz
     {0x20, 0x37, 0x90}, // channel =  3, Tf = 2422MHz
@@ -226,7 +226,7 @@ u8 abyAL7230ChannelTable0[CB_MAX_CHANNEL][3] = {
     {0x2F, 0xF6, 0x10} // channel = 165, Tf = 5825MHz (56)
     };
 
-u8 abyAL7230ChannelTable1[CB_MAX_CHANNEL][3] = {
+static u8 al7230_channel_table1[CB_MAX_CHANNEL][3] = {
     {0x13, 0x33, 0x31}, // channel =  1, Tf = 2412MHz
     {0x1B, 0x33, 0x31}, // channel =  2, Tf = 2417MHz
     {0x03, 0x33, 0x31}, // channel =  3, Tf = 2422MHz
@@ -290,7 +290,7 @@ u8 abyAL7230ChannelTable1[CB_MAX_CHANNEL][3] = {
     {0x02, 0xAA, 0xB1}  // channel = 165, Tf = 5825MHz (56)
     };
 
-u8 abyAL7230ChannelTable2[CB_MAX_CHANNEL][3] = {
+static u8 al7230_channel_table2[CB_MAX_CHANNEL][3] = {
     {0x7F, 0xD7, 0x84}, // channel =  1, Tf = 2412MHz
     {0x7F, 0xD7, 0x84}, // channel =  2, Tf = 2417MHz
     {0x7F, 0xD7, 0x84}, // channel =  3, Tf = 2422MHz
@@ -355,7 +355,7 @@ u8 abyAL7230ChannelTable2[CB_MAX_CHANNEL][3] = {
     };
 
 ///{{RobertYu:20051111
-u8 abyVT3226_InitTable[CB_VT3226_INIT_SEQ][3] = {
+static u8 at3226_init_table[CB_VT3226_INIT_SEQ][3] = {
     {0x03, 0xFF, 0x80},
     {0x02, 0x82, 0xA1},
     {0x03, 0xC6, 0xA2},
@@ -369,7 +369,7 @@ u8 abyVT3226_InitTable[CB_VT3226_INIT_SEQ][3] = {
     {0x02, 0x00, 0x2A}
     };
 
-u8 abyVT3226D0_InitTable[CB_VT3226_INIT_SEQ][3] = {
+static u8 at3226d0_init_table[CB_VT3226_INIT_SEQ][3] = {
     {0x03, 0xFF, 0x80},
     {0x03, 0x02, 0x21}, //RobertYu:20060327
     {0x03, 0xC6, 0xA2},
@@ -383,7 +383,7 @@ u8 abyVT3226D0_InitTable[CB_VT3226_INIT_SEQ][3] = {
     {0x02, 0x01, 0xAA}  //RobertYu:20060523
     };
 
-u8 abyVT3226_ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
+static u8 vt3226_channel_table0[CB_MAX_CHANNEL_24G][3] = {
     {0x01, 0x97, 0x83}, // channel = 1, Tf = 2412MHz
     {0x01, 0x97, 0x83}, // channel = 2, Tf = 2417MHz
     {0x01, 0x97, 0x93}, // channel = 3, Tf = 2422MHz
@@ -400,7 +400,7 @@ u8 abyVT3226_ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
     {0x03, 0x37, 0xC3}  // channel = 14, Tf = 2484MHz
     };
 
-u8 abyVT3226_ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
+static u8 vt3226_channel_table1[CB_MAX_CHANNEL_24G][3] = {
     {0x02, 0x66, 0x64}, // channel = 1, Tf = 2412MHz
     {0x03, 0x66, 0x64}, // channel = 2, Tf = 2417MHz
     {0x00, 0x66, 0x64}, // channel = 3, Tf = 2422MHz
@@ -419,7 +419,7 @@ u8 abyVT3226_ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
 ///}}RobertYu
 
 //{{RobertYu:20060502, TWIF 1.14, LO Current for 11b mode
-u32 dwVT3226D0LoCurrentTable[CB_MAX_CHANNEL_24G] = {
+const u32 vt3226d0_lo_current_table[CB_MAX_CHANNEL_24G] = {
     0x0135C600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW, // channel = 1, Tf = 2412MHz
     0x0135C600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW, // channel = 2, Tf = 2417MHz
     0x0235C600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW, // channel = 3, Tf = 2422MHz
@@ -438,7 +438,7 @@ u32 dwVT3226D0LoCurrentTable[CB_MAX_CHANNEL_24G] = {
 //}}
 
 //{{RobertYu:20060609
-u8 abyVT3342A0_InitTable[CB_VT3342_INIT_SEQ][3] = { /* 11b/g mode */
+static u8 vt3342a0_init_table[CB_VT3342_INIT_SEQ][3] = { /* 11b/g mode */
     {0x03, 0xFF, 0x80}, //update for mode//
     {0x02, 0x08, 0x81},
     {0x00, 0xC6, 0x02},
@@ -461,7 +461,7 @@ u8 abyVT3342A0_InitTable[CB_VT3342_INIT_SEQ][3] = { /* 11b/g mode */
  // channel56, 5280MHz  0x00C402 for disable Frac
  // other channels 0x00C602
 
-u8 abyVT3342_ChannelTable0[CB_MAX_CHANNEL][3] = {
+static u8 vt3342_channel_table0[CB_MAX_CHANNEL][3] = {
     {0x02, 0x05, 0x03}, // channel = 1, Tf = 2412MHz
     {0x01, 0x15, 0x03}, // channel = 2, Tf = 2417MHz
     {0x03, 0xC5, 0x03}, // channel = 3, Tf = 2422MHz
@@ -527,7 +527,7 @@ u8 abyVT3342_ChannelTable0[CB_MAX_CHANNEL][3] = {
     {0x00, 0x06, 0x03}  // channel = 165, Tf = 5825MHz (56), TBD
     };
 
-u8 abyVT3342_ChannelTable1[CB_MAX_CHANNEL][3] = {
+static u8 vt3342_channel_table1[CB_MAX_CHANNEL][3] = {
     {0x01, 0x99, 0x94}, // channel = 1, Tf = 2412MHz
     {0x02, 0x44, 0x44}, // channel = 2, Tf = 2417MHz
     {0x02, 0xEE, 0xE4}, // channel = 3, Tf = 2422MHz
@@ -597,7 +597,7 @@ u8 abyVT3342_ChannelTable1[CB_MAX_CHANNEL][3] = {
  *
 -*/
 
-const u32 dwAL2230PowerTable[AL2230_PWR_IDX_LEN] = {
+const u32 al2230_power_table[AL2230_PWR_IDX_LEN] = {
     0x04040900+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW,
     0x04041900+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW,
     0x04042900+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW,
@@ -802,7 +802,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 			return false;
 
 		ret &= IFRFbWriteEmbedded(priv,
-			dwAL2230PowerTable[priv->byCurPwr]);
+			al2230_power_table[priv->byCurPwr]);
 
 		if (rate <= RATE_11M)
 			ret &= IFRFbWriteEmbedded(priv, 0x0001b400 +
@@ -816,7 +816,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 			return false;
 
 		ret &= IFRFbWriteEmbedded(priv,
-			dwAL2230PowerTable[priv->byCurPwr]);
+			al2230_power_table[priv->byCurPwr]);
 
 		if (rate <= RATE_11M) {
 			ret &= IFRFbWriteEmbedded(priv, 0x040c1400 +
@@ -880,14 +880,14 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
 						priv->vnt_mgmt.uScanChannel);
 				ret &= IFRFbWriteEmbedded(priv,
-					dwVT3226D0LoCurrentTable[priv->
+					vt3226d0_lo_current_table[priv->
 						vnt_mgmt.uScanChannel - 1]);
 			} else {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
 						priv->vnt_mgmt.uCurrChannel);
 				ret &= IFRFbWriteEmbedded(priv,
-					dwVT3226D0LoCurrentTable[priv->
+					vt3226d0_lo_current_table[priv->
 						vnt_mgmt.uCurrChannel - 1]);
 			}
 
@@ -979,41 +979,41 @@ void RFbRFTableDownload(struct vnt_private *priv)
 		length1 = CB_AL2230_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &abyAL2230InitTable[0][0];
-		addr2 = &abyAL2230ChannelTable0[0][0];
-		addr3 = &abyAL2230ChannelTable1[0][0];
+		addr1 = &al2230_init_table[0][0];
+		addr2 = &al2230_channel_table0[0][0];
+		addr3 = &al2230_channel_table1[0][0];
 		break;
 	case RF_AIROHA7230:
 		length1 = CB_AL7230_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL * 3;
 		length3 = CB_MAX_CHANNEL * 3;
-		addr1 = &abyAL7230InitTable[0][0];
-		addr2 = &abyAL7230ChannelTable0[0][0];
-		addr3 = &abyAL7230ChannelTable1[0][0];
+		addr1 = &al7230_init_table[0][0];
+		addr2 = &al7230_channel_table0[0][0];
+		addr3 = &al7230_channel_table1[0][0];
 		break;
 	case RF_VT3226:
 		length1 = CB_VT3226_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &abyVT3226_InitTable[0][0];
-		addr2 = &abyVT3226_ChannelTable0[0][0];
-		addr3 = &abyVT3226_ChannelTable1[0][0];
+		addr1 = &at3226_init_table[0][0];
+		addr2 = &vt3226_channel_table0[0][0];
+		addr3 = &vt3226_channel_table1[0][0];
 		break;
 	case RF_VT3226D0:
 		length1 = CB_VT3226_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &abyVT3226D0_InitTable[0][0];
-		addr2 = &abyVT3226_ChannelTable0[0][0];
-		addr3 = &abyVT3226_ChannelTable1[0][0];
+		addr1 = &at3226d0_init_table[0][0];
+		addr2 = &vt3226_channel_table0[0][0];
+		addr3 = &vt3226_channel_table1[0][0];
 		break;
 	case RF_VT3342A0:
 		length1 = CB_VT3342_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL * 3;
 		length3 = CB_MAX_CHANNEL * 3;
-		addr1 = &abyVT3342A0_InitTable[0][0];
-		addr2 = &abyVT3342_ChannelTable0[0][0];
-		addr3 = &abyVT3342_ChannelTable1[0][0];
+		addr1 = &vt3342a0_init_table[0][0];
+		addr2 = &vt3342_channel_table0[0][0];
+		addr3 = &vt3342_channel_table1[0][0];
 		break;
 	}
 
@@ -1062,8 +1062,8 @@ void RFbRFTableDownload(struct vnt_private *priv)
 	if (priv->byRFType == RF_AIROHA7230) {
 		length1 = CB_AL7230_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL * 3;
-		addr1 = &(abyAL7230InitTableAMode[0][0]);
-		addr2 = &(abyAL7230ChannelTable2[0][0]);
+		addr1 = &(al7230_init_table_amode[0][0]);
+		addr2 = &(al7230_channel_table2[0][0]);
 
 		memcpy(array, addr1, length1);
 
-- 
1.8.1.2






