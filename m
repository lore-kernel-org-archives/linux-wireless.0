Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965068AbaGBATj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 20:19:39 -0400
Date: Wed, 2 Jul 2014 02:19:36 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] wireless: fixup genregdb.awk for remove of antenna
	gain from wireless-regdb
Message-ID: <20140702001936.GQ27687@wotan.suse.de> (sfid-20140702_021942_467223_8BAF8BE4)
References: <1404245874-350-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404245874-350-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 01, 2014 at 04:17:54PM -0400, John W. Linville wrote:
> Since "wireless-regdb: remove antenna gain" was merged in the
> wireless-regdb tree, this script has been incompatible with the
> 'official' regulatory database.  Let's fix it up.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> I think the dfs_cac stuff is still broken, since it does not account
> for the starting offset of the flags.

Indeed, but that also breaks other stuff too, because the DFS CAC stuff
is optional it means the flags can now start at different locations, it
also means that we need to distinguish a flag from a CAC. 

Here's a complex example we should test for as an example now:

country US: DFS-FCC
	(2400 - 2450 @ 40), (100 mW)
	(2450 - 2500 @ 0), (100 mW), DFS, AUTO-BW
	(5170 - 5250 @ 80), (100 mW), DFS, AUTO-BW, NO-OUTDOOR
	(5250 - 5330 @ 0), (20), (60000), DFS, AUTO-BW
	(5735 - 5835 @ 80), (30)
	(57240 - 63720 @ 2160), (40)

The changes below seem to address it. I think awk is too fragile to
scale well and keep us sane. A C parser exists but right now it
ignores the DFS CAC. Having a parser is nice as it allows us to
modify the db.txt on the fly, however parser still requires a bit
of an update in code. If we wanted to avoid the parser all together
we could just merge a CRDA reader at build time and require a
a regulatory.bin file for reading instead of the db.txt. If we
had support for that then its really only one step further from
having full CRDA functionality upstream on the kernel, ie letting
us read the file at run time rather than just build time. If we
are to follow the steps from udev with its firmware loader helper
we might as well merge CRDA upstream, in fact we could just use
request_firmware_direct() for the reader, what remains questionable
to me is the signing stuff, but if we already have support module
signing checks it doesn't seem far fetched to be able to have
request firmware verify a signature on a file, which probably
ain't such a bad idea anyway. If we did this we'd have two options:

1) regulatory.bin reader at build time to build the static regulatory domains
2) the same reader code can use request the file at run time via
   request_firmware_direct() and if we added signature verification
   it can replace CRDA

We'd eliminate the ASCII representation completely from the build picture
and peg a regulatory.bin firmware to each kernel then. Thoughts?

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 40c37fc..baf2426 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -51,32 +51,41 @@ function parse_country_head() {
 
 function parse_reg_rule()
 {
+	flag_starts_at = 7
+
 	start = $1
 	sub(/\(/, "", start)
 	end = $3
 	bw = $5
 	sub(/\),/, "", bw)
-	gain = $6
-	sub(/\(/, "", gain)
-	sub(/,/, "", gain)
-	power = $7
-	sub(/\)/, "", power)
-	sub(/,/, "", power)
+	gain = 0
+	power = $6
 	# power might be in mW...
-	units = $8
+	units = $7
+	dfs_cac = 0
+
+	sub(/\(/, "", power)
+	sub(/\),/, "", power)
+	sub(/\),/, "", units)
 	sub(/\)/, "", units)
-	sub(/,/, "", units)
-	dfs_cac = $9
+
 	if (units == "mW") {
+		flag_starts_at = 8
 		power = 10 * log(power)/log(10)
+		if ($8 ~ /[[:digit:]]/) {
+			flag_starts_at = 9
+			dfs_cac = $8
+		}
 	} else {
-		dfs_cac = $8
+		if ($7 ~ /[[:digit:]]/) {
+			flag_starts_at = 8
+			dfs_cac = $7
+		}
 	}
-	sub(/,/, "", dfs_cac)
 	sub(/\(/, "", dfs_cac)
-	sub(/\)/, "", dfs_cac)
+	sub(/\),/, "", dfs_cac)
 	flagstr = ""
-	for (i=8; i<=NF; i++)
+	for (i=flag_starts_at; i<=NF; i++)
 		flagstr = flagstr $i
 	split(flagstr, flagarray, ",")
 	flags = ""
