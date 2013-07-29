Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:63065 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab3G2ImV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 04:42:21 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC] iw: add chan_time scan parameter
Date: Mon, 29 Jul 2013 10:42:13 +0200
Message-ID: <1375087333-23552-1-git-send-email-michal.kazior@tieto.com> (sfid-20130729_104224_314605_7B840FA0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new parameter allows user to specify how long
driver should remain on each channel while
scanning.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
Note: nl/cfg/mac patches were sent separately.

      Should this be split into two patches - one
      that updates nl80211.h and the other adding
      the parameter support?

 nl80211.h |    8 ++++++++
 scan.c    |   16 +++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 5abc54d..f9ef050 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1469,6 +1469,12 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_COALESCE_RULE: Coalesce rule information.
  *
+ * @NL80211_ATTR_SCAN_CHAN_TIME: Specifies how many msec should a driver spend
+ *	on each channel during scanning. This is optional and the default is
+ *	leave the decision up to the driver. This setting may, but preferrably
+ *	shouldn't, be ignored by a driver.
+ *
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1771,6 +1777,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_COALESCE_RULE,
 
+	NL80211_ATTR_SCAN_CHAN_TIME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/scan.c b/scan.c
index 4fb0f23..c5bafd8 100644
--- a/scan.c
+++ b/scan.c
@@ -87,12 +87,13 @@ static int handle_scan(struct nl80211_state *state,
 		SSID,
 		MESHID,
 		DONE,
+		CHANTIME,
 	} parse = NONE;
 	int freq;
 	bool passive = false, have_ssids = false, have_freqs = false;
 	size_t ies_len = 0, meshid_len = 0;
 	unsigned char *ies = NULL, *meshid = NULL, *tmpies;
-	int flags = 0;
+	int flags = 0, chan_time = 0;
 
 	ssids = nlmsg_alloc();
 	if (!ssids)
@@ -137,6 +138,9 @@ static int handle_scan(struct nl80211_state *state,
 			} else if (strcmp(argv[i], "meshid") == 0) {
 				parse = MESHID;
 				break;
+			} else if (strcmp(argv[i], "chan-time") == 0) {
+				parse = CHANTIME;
+				break;
 			}
 		case DONE:
 			return 1;
@@ -170,6 +174,10 @@ static int handle_scan(struct nl80211_state *state,
 			meshid_len += 2;
 			parse = NONE;
 			break;
+		case CHANTIME:
+			chan_time = strtoul(argv[i], &eptr, 10);
+			parse = NONE;
+			break;
 		}
 	}
 
@@ -198,6 +206,8 @@ static int handle_scan(struct nl80211_state *state,
 		nla_put_nested(msg, NL80211_ATTR_SCAN_FREQUENCIES, freqs);
 	if (flags)
 		NLA_PUT_U32(msg, NL80211_ATTR_SCAN_FLAGS, flags);
+	if (chan_time)
+		NLA_PUT_U32(msg, NL80211_ATTR_SCAN_CHAN_TIME, chan_time);
 
 	err = 0;
  nla_put_failure:
@@ -1596,7 +1606,7 @@ static int handle_scan_combined(struct nl80211_state *state,
 	dump_argv[0] = argv[0];
 	return handle_cmd(state, id, dump_argc, dump_argv);
 }
-TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]", 0, 0,
+TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force] [chan-time <msec>] [ssid <ssid>*|passive]", 0, 0,
 	 CIB_NETDEV, handle_scan_combined,
 	 "Scan on the given frequencies and probe for the given SSIDs\n"
 	 "(or wildcard if not given) unless passive scanning is requested.\n"
@@ -1606,7 +1616,7 @@ COMMAND(scan, dump, "[-u]",
 	NL80211_CMD_GET_SCAN, NLM_F_DUMP, CIB_NETDEV, handle_scan_dump,
 	"Dump the current scan results. If -u is specified, print unknown\n"
 	"data in scan results.");
-COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]",
+COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force] [chan-time <msec>] [ssid <ssid>*|passive]",
 	NL80211_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, handle_scan,
 	 "Trigger a scan on the given frequencies with probing for the given\n"
 	 "SSIDs (or wildcard if not given) unless passive scanning is requested.");
-- 
1.7.9.5

