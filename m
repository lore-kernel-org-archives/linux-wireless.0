Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab0DHUNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 16:13:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] packetspammer: add frame count option
Date: Thu,  8 Apr 2010 16:13:46 -0400
Message-Id: <1270757626-22095-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270757626-22095-1-git-send-email-lrodriguez@atheros.com>
References: <1270757626-22095-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows you to specify the number of frames you want to TX
from the command line.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 packetspammer.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/packetspammer.c b/packetspammer.c
index b7a1367..d068fbe 100644
--- a/packetspammer.c
+++ b/packetspammer.c
@@ -20,6 +20,7 @@
 
 #include "packetspammer.h"
 #include "radiotap.h"
+#include <stdbool.h>
 
 /* wifi bitrate to use in 500kHz units */
 
@@ -143,6 +144,7 @@ usage(void)
 	    "\n"
 	    "Usage: packetspammer [options] <interface>\n\nOptions\n"
 	    "-d/--delay <delay> Delay between packets\n\n"
+	    "-c/--frame-count <frame-count> Number of frames to transmit\n\n"
 	    "-f/--fcs           Mark as having FCS (CRC) already\n"
 	    "                   (pkt ends with 4 x sacrificial - chars)\n"
 	    "Example:\n"
@@ -162,13 +164,14 @@ main(int argc, char *argv[])
 	u8 u8aSendBuffer[500];
 	char szErrbuf[PCAP_ERRBUF_SIZE];
 	int nCaptureHeaderLength = 0, n80211HeaderLength = 0, nLinkEncap = 0;
-	int nOrdinal = 0, r, nDelay = 100000;
+	int nOrdinal = 0, r, nDelay = 100000, num_frames = 0, frame_num = 0;
 	int nRateIndex = 0, retval, bytes;
 	pcap_t *ppcap = NULL;
 	struct bpf_program bpfprogram;
 	char * szProgram = "", fBrokenSocket = 0;
 	u16 u16HeaderLen;
 	char szHostname[PATH_MAX];
+	bool count = false;
 
 	if (gethostname(szHostname, sizeof (szHostname) - 1)) {
 		perror("unable to get hostname");
@@ -182,11 +185,12 @@ main(int argc, char *argv[])
 		int nOptionIndex;
 		static const struct option optiona[] = {
 			{ "delay", required_argument, NULL, 'd' },
+			{ "frame-count", required_argument, NULL, 'c' },
 			{ "fcs", no_argument, &flagMarkWithFCS, 1 },
 			{ "help", no_argument, &flagHelp, 1 },
 			{ 0, 0, 0, 0 }
 		};
-		int c = getopt_long(argc, argv, "d:hf",
+		int c = getopt_long(argc, argv, "d:c:hf",
 			optiona, &nOptionIndex);
 
 		if (c == -1)
@@ -206,6 +210,15 @@ main(int argc, char *argv[])
 			flagMarkWithFCS = 1;
 			break;
 
+		case 'c': // count
+			num_frames = atoi(optarg);
+			if (num_frames > 0) {
+				count = true;
+				frame_num = 1;
+			}
+			break;
+
+
 		default:
 			printf("unknown switch %c\n", c);
 			usage();
@@ -269,10 +282,12 @@ main(int argc, char *argv[])
 	pcap_setnonblock(ppcap, 1, szErrbuf);
 
 	printf("   (delay between packets %dus)\n", nDelay);
+	if (count)
+		printf("   (number of frames to transmit: %d)\n", num_frames);
 
 	memset(u8aSendBuffer, 0, sizeof (u8aSendBuffer));
 
-	while (!fBrokenSocket) {
+	while (!fBrokenSocket && (!count || (count && num_frames > 0))) {
 		u8 * pu8 = u8aSendBuffer;
 		struct pcap_pkthdr * ppcapPacketHeader = NULL;
 		struct ieee80211_radiotap_iterator rti;
@@ -281,6 +296,8 @@ main(int argc, char *argv[])
 		int n, nRate;
 
 		// receive
+		if (count)
+			printf("Frame #%d:\n", frame_num);
 
 		retval = pcap_next_ex(ppcap, &ppcapPacketHeader,
 		    (const u_char**)&pu8Payload);
@@ -378,8 +395,12 @@ main(int argc, char *argv[])
 			perror("Trouble injecting packet");
 			return (1);
 		}
+
 		if (nDelay)
 			usleep(nDelay);
+
+		num_frames--;
+		frame_num++;
 	}
 
 
-- 
1.6.3.3

