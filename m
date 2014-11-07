Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54190 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaKGVaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 16:30:09 -0500
Date: Fri, 7 Nov 2014 16:21:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Peter Gent <Peter.Gent@mbie.govt.nz>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wireless-regdb: Update regulatory rules for New Zealand (NZ) on
 5GHz and 60 GHz [UNCLASSIFIED]
Message-ID: <20141107212117.GF29733@tuxdriver.com> (sfid-20141107_223014_676581_88BF5CBF)
References: <D0D2EC853BFD0147A005CC7FAC0E4A53E39A56A6@AKI2K113.wd.govt.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D0D2EC853BFD0147A005CC7FAC0E4A53E39A56A6@AKI2K113.wd.govt.nz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 01:04:10AM +0000, Peter Gent wrote:
> Hi,
> 
> We wish to note the following changes should be made to the wireless regulatory database to reflect some recent changes to the 60 GHz band here in New Zealand. In additional there are some inaccuracies when compared to our current licencing for the 5 GHz "Wi-Fi" band.
> 
> The updated entry for New Zealand should read:
> 
> 5150 MHz  - 5250 MHz  80MHz channels, indoor use only at -7.0 dBW EIRP TPC enabled
> 5250 MHz -  5350 MHz  80 MHz channels, indoor use at -7.0 dBW EIRP, outdoor use at 0 dBW EIRP with DFS and TPC enabled* 
> 5470 MHz  - 5725 MHz  80 MHz channels, 0 dBW EIRP with DFS and TPC enabled*
> 5725 MHz  - 5875 MHz  80 MHz channels, 6.0 dBW EIRP with frequency hopping enabled  
> 57000 MHz - 66000 MHz, indoor use only at 13.0 dBW EIRP 
> 
> *if TPC is not enabled, than transmit power must be reduced by 3dB
> 
> Further information on SRD licencing rules can be found at http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/short-range-devices 
> 
> Regards
> 
> Peter

Peter,

Thanks for making us aware of this info.  I'm sorry that there has
been no other response so far.

Changes to our regulatory rules database are typically proposed in the
form of a patch.  This promotes specificity in making such changes.
I suspect that you are unfamiliar with this form of change proposal,
so I have taken a first whack at it.

While I maintain the database, I am not as radio proficient as I
perhaps should be.  I normally leave writing such patches for others,
and wait for some level of agreement to be reached before applying
changes.  In this case, it is quite likely that I have overlooked
something or misinterpreted (or simply misunderstood) your change
suggestions.

I hope that you and others will take a moment to comment and/or
suggest further changes to my proposed changes below.  Without some
affirmative commentary I will not apply any derivative of the changes
specified below.

Thanks!

John

diff --git a/db.txt b/db.txt
index 6cf86e15627b..3b9db42309dc 100644
--- a/db.txt
+++ b/db.txt
@@ -848,12 +848,20 @@ country NP: DFS-JP
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5735 - 5835 @ 80), (20)
 
+# 5150 MHz  - 5250 MHz  80MHz channels, indoor use only at -7.0 dBW EIRP TPC enabled
+# 5250 MHz -  5350 MHz  80 MHz channels, indoor use at -7.0 dBW EIRP, outdoor use at 0 dBW EIRP with DFS and TPC enabled*
+# 5470 MHz  - 5725 MHz  80 MHz channels, 0 dBW EIRP with DFS and TPC enabled*
+# 5725 MHz  - 5875 MHz  80 MHz channels, 6.0 dBW EIRP with frequency hopping enabled
+# 57000 MHz - 66000 MHz, indoor use only at 13.0 dBW EIRP
+# *if TPC is not enabled, than transmit power must be reduced by 3dB
+# http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/short-range-devices
 country NZ: DFS-FCC
 	(2402 - 2482 @ 40), (30)
-	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5730 @ 160), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(5150 - 5250 @ 80), (20), AUTO-BW
+	(5250 - 5350 @ 80), (20), DFS, AUTO-BW
+	(5470 - 5725 @ 160), (27), DFS
+	(5725 - 5875 @ 80), (33)
+	(57000 - 66000 @ 2160), (40)
 
 country OM: DFS-ETSI
 	(2402 - 2482 @ 40), (20)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
