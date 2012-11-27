Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:34012 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2K0TBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 14:01:52 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC] iw: add spectral scan attribute to scan function
Date: Tue, 27 Nov 2012 20:01:25 +0100
Message-Id: <1354042885-32688-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121127_200158_416746_AB8F350B)
In-Reply-To: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 scan.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/scan.c b/scan.c
index 05bad0b..3e28722 100644
--- a/scan.c
+++ b/scan.c
@@ -70,7 +70,7 @@ static int handle_scan(struct nl80211_state *state,
 		DONE,
 	} parse = NONE;
 	int freq;
-	bool passive = false, have_ssids = false, have_freqs = false;
+	bool passive = false, have_ssids = false, have_freqs = false, spec_scan = false;
 	size_t tmp;
 	unsigned char *ies;
 	int flags = 0;
@@ -115,6 +115,10 @@ static int handle_scan(struct nl80211_state *state,
 				parse = DONE;
 				passive = true;
 				break;
+			} else if (strcmp(argv[i], "spec-scan") == 0) {
+				parse = NONE;
+				spec_scan = true;
+				break;
 			}
 		case DONE:
 			return 1;
@@ -151,6 +155,8 @@ static int handle_scan(struct nl80211_state *state,
 		nla_put_nested(msg, NL80211_ATTR_SCAN_FREQUENCIES, freqs);
 	if (flags)
 		NLA_PUT_U32(msg, NL80211_ATTR_SCAN_FLAGS, flags);
+	if (spec_scan)
+                NLA_PUT_FLAG(msg, NL80211_ATTR_TX_SPEC_SCAN);
 
 	err = 0;
  nla_put_failure:
@@ -1450,7 +1456,7 @@ static int handle_scan_combined(struct nl80211_state *state,
 	dump_argv[0] = argv[0];
 	return handle_cmd(state, id, dump_argc, dump_argv);
 }
-TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]", 0, 0,
+TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush,ap-force,spec-scan] [ssid <ssid>*|passive]", 0, 0,
 	 CIB_NETDEV, handle_scan_combined,
 	 "Scan on the given frequencies and probe for the given SSIDs\n"
 	 "(or wildcard if not given) unless passive scanning is requested.\n"
@@ -1460,7 +1466,7 @@ COMMAND(scan, dump, "[-u]",
 	NL80211_CMD_GET_SCAN, NLM_F_DUMP, CIB_NETDEV, handle_scan_dump,
 	"Dump the current scan results. If -u is specified, print unknown\n"
 	"data in scan results.");
-COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]",
+COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush,ap-force,spec-scan] [ssid <ssid>*|passive]",
 	NL80211_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, handle_scan,
 	 "Trigger a scan on the given frequencies with probing for the given\n"
 	 "SSIDs (or wildcard if not given) unless passive scanning is requested.");
-- 
1.7.10.4

