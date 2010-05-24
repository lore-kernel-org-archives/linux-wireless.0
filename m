Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60569 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab0EXIha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:37:30 -0400
Subject: Re: WLAN Regulatory Domain Germany
From: Johannes Berg <johannes@sipsolutions.net>
To: Kurt Garloff <kurt@garloff.de>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <20100519172944.GB32757@tpkurt2.garloff.de>
References: <20100519172944.GB32757@tpkurt2.garloff.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 10:37:26 +0200
Message-ID: <1274690246.3743.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, 2010-05-19 at 19:29 +0200, Kurt Garloff wrote:

> WLAN 5GHz (Vfg. 7/2010)
> http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publicationFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf


> Find below my suggested entry into db.txt.
> Suggested changes:
> * Updated references (they restructured their webserver/CMS it seems)
> * Split 5150 -- 5350 range into two
>   - the first range does not require DFS
> * 5470 -- 5725 does not have a NO-OUTDOOR requirement
>   - (and 500mW translates to 27db, not 26db AFAICT)
> 
> Sidenote: The values include lowering txpower by a factor of 2 (3db)
>  for non TPC devices -- the wording in Vfg. 7/2010 does NOT require
>  this for 5150 -- 5250; so we could actually use 200mW/23db there. As 
>  this is out of line with the neighbour countries, I have sticked with
>  the conservative value of 100mW here.
> 
> What is the process for checking the correctness and getting the crda DB 
> updated?
> 
> 8<------------------------------------------------------------------------
> 
> # Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from 
> # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
> # For the 5GHz range also see 
> # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publicationFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
> # The values have been reduced by a factor of 2 (3db) for non TPC devcies
> # (in other words: devices with TPC can use twice the tx power of this table).
> 
> country DE:
> 	# entries 279004 and 280006
> 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
> 	# entry 303005
> 	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
> 	# entries 304002 and 305002
> 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> 	# entries 308002, 309001 and 310003
> 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS

I haven't verified the entries in the Frequenznutzungsplan itself, but
according to the second document this seems fine. I think there ought to
be a comment in the db.txt file indicating the rationale for using 100mW
rather than 200mW.

Also note that there are different requirements depending on the channel
bandwidth, which will eventually come up in Linux too. But I think for
that we need the new database format for that ... yet another thing to
do before we can support 5/10 MHz channels.

johannes

