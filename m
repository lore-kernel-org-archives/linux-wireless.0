Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wn1-mbie.dmzglobal.net ([203.144.33.76]:50875 "EHLO
	wn1-mbie.dmzglobal.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaKXBWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2014 20:22:50 -0500
From: Peter Gent <Peter.Gent@mbie.govt.nz>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: wireless-regdb: Update regulatory rules for New Zealand (NZ) on
 5GHz and 60 GHz [UNCLASSIFIED]
Date: Mon, 24 Nov 2014 01:22:46 +0000
Message-ID: <D0D2EC853BFD0147A005CC7FAC0E4A53EBFDFF94@AKI2K113.wd.govt.nz> (sfid-20141124_022254_629327_748B2D83)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

John - thank you for the suggested patch. 

We have a couple of queries and comments on what is proposed so far for the list. 
1) Our top 2 GHz in the 60 GHz band "64000 - 66000 MHz" is indoor only and comments are edited as such
2) Is it possible to define an indoor / outdoor limit inside the processing rules? I guess sensing this might prove problematic but could anyone advise on what other countries do?
3) As our limits are in EIRP, suggest to modify the patch to match the EIRP formatting in the processing rules
4) Can Transmitter power control be added to the patch, if so how is it enabled? 
5) Finally can someone confirm to me the use of AUTO-BW as I can't find any direct reference to it in the processing rules? 

There is still a little more work on this, but this is our next iteration of the New Zealand patch


+# 5150 MHz  - 5250 MHz  80MHz channels, indoor use only at -7.0 dBW 
+EIRP TPC enabled # 5250 MHz -  5350 MHz  80 MHz channels, indoor use at 
+-7.0 dBW EIRP, outdoor use at 0 dBW EIRP with DFS and TPC enabled* # 
+5470 MHz  - 5725 MHz  80 MHz channels, 0 dBW EIRP with DFS and TPC 
+enabled* # 5725 MHz  - 5875 MHz  80 MHz channels, 6.0 dBW EIRP 
+# 57000 MHz - 64000 MHz, at 13.0 dBW EIRP # 64000 - 66000 MHz, 
+indoor use only at 13.0 dBW EIRP # *if TPC is not enabled, than transmit power must be 
+reduced by 3dB # 
+http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/short-range-devices



country NZ: DFS-FCC
 	(2402 - 2482 @ 40), (30)
-	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-	(5490 - 5730 @ 160), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(5150 - 5250 @ 80), (N/A,23), AUTO-BW
+	(5250 - 5350 @ 80), (N/A, 23), DFS, AUTO-BW
+	(5470 - 5725 @ 160), (N/A, 30), DFS
+	(5725 - 5875 @ 80), (N/A, 36)
+	(57000 - 64000 @ 2160), (N/A, 43)



-----Original Message-----
From: John W. Linville [mailto:linville@tuxdriver.com] 
Sent: Saturday, 8 November 2014 10:21 a.m.
To: Peter Gent
Cc: wireless-regdb@lists.infradead.org; linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: Update regulatory rules for New Zealand (NZ) on 5GHz and 60 GHz [UNCLASSIFIED]

On Tue, Oct 28, 2014 at 01:04:10AM +0000, Peter Gent wrote:
> Hi,
> 
> We wish to note the following changes should be made to the wireless regulatory database to reflect some recent changes to the 60 GHz band here in New Zealand. In additional there are some inaccuracies when compared to our current licencing for the 5 GHz "Wi-Fi" band.
> 
> The updated entry for New Zealand should read:
> 
> 5150 MHz  - 5250 MHz  80MHz channels, indoor use only at -7.0 dBW EIRP 
> TPC enabled
> 5250 MHz -  5350 MHz  80 MHz channels, indoor use at -7.0 dBW EIRP, 
> outdoor use at 0 dBW EIRP with DFS and TPC enabled*
> 5470 MHz  - 5725 MHz  80 MHz channels, 0 dBW EIRP with DFS and TPC 
> enabled*
> 5725 MHz  - 5875 MHz  80 MHz channels, 6.0 dBW EIRP with frequency 
> hopping enabled
> 57000 MHz - 66000 MHz, indoor use only at 13.0 dBW EIRP
> 
> *if TPC is not enabled, than transmit power must be reduced by 3dB
> 
> Further information on SRD licencing rules can be found at 
> http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-lic
> ences/short-range-devices
> 
> Regards
> 
> Peter

Peter,

Thanks for making us aware of this info.  I'm sorry that there has been no other response so far.

Changes to our regulatory rules database are typically proposed in the form of a patch.  This promotes specificity in making such changes.
I suspect that you are unfamiliar with this form of change proposal, so I have taken a first whack at it.

While I maintain the database, I am not as radio proficient as I perhaps should be.  I normally leave writing such patches for others, and wait for some level of agreement to be reached before applying changes.  In this case, it is quite likely that I have overlooked something or misinterpreted (or simply misunderstood) your change suggestions.

I hope that you and others will take a moment to comment and/or suggest further changes to my proposed changes below.  Without some affirmative commentary I will not apply any derivative of the changes specified below.

Thanks!

John

diff --git a/db.txt b/db.txt
index 6cf86e15627b..3b9db42309dc 100644
--- a/db.txt
+++ b/db.txt
@@ -848,12 +848,20 @@ country NP: DFS-JP
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5735 - 5835 @ 80), (20)
 
+# 5150 MHz  - 5250 MHz  80MHz channels, indoor use only at -7.0 dBW 
+EIRP TPC enabled # 5250 MHz -  5350 MHz  80 MHz channels, indoor use at 
+-7.0 dBW EIRP, outdoor use at 0 dBW EIRP with DFS and TPC enabled* # 
+5470 MHz  - 5725 MHz  80 MHz channels, 0 dBW EIRP with DFS and TPC 
+enabled* # 5725 MHz  - 5875 MHz  80 MHz channels, 6.0 dBW EIRP with 
+frequency hopping enabled # 57000 MHz - 66000 MHz, indoor use only at 
+13.0 dBW EIRP # *if TPC is not enabled, than transmit power must be 
+reduced by 3dB # 
+http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-lice
+nces/short-range-devices
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
newzealand.govt.nz - connecting you to New Zealand central & local government services

Any opinions expressed in this message are not necessarily those of the Ministry of Business, Innovation and Employment. This message and any files transmitted with it are confidential and solely for the use of the intended recipient. If you are not the intended recipient or the person responsible for delivery to the intended recipient, be advised that you have received this message in error and that any use is strictly prohibited. Please contact the sender and delete the message and any attachment from your computer.

