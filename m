Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61642 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0ESWUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 18:20:45 -0400
Received: by pva18 with SMTP id 18so1199443pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 15:20:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100519172944.GB32757@tpkurt2.garloff.de>
References: <20100519172944.GB32757@tpkurt2.garloff.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 19 May 2010 15:20:24 -0700
Message-ID: <AANLkTilXo13Pn6n0n3mJONuUj50BImufADLveYAjX3YR@mail.gmail.com>
Subject: Re: WLAN Regulatory Domain Germany
To: Kurt Garloff <kurt@garloff.de>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 10:29 AM, Kurt Garloff <kurt@garloff.de> wrote:
> Hi,
>
> studying the three documents
>
> WLAN 5GHz (Vfg. 7/2010)
> http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publicationFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
>
> WLAN 2.4GHz (Vfg. 89/2003)
> http://www.bundesnetzagentur.de/cae/servlet/contentblob/38214/publicationFile/2557/FundstelleId313pdf.pdf
>
> Frequenznutzungsplan
> http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
>
> I think the data in db.txt is slightly inaccurate.
>
> Find below my suggested entry into db.txt.
> Suggested changes:
> * Updated references (they restructured their webserver/CMS it seems)
> * Split 5150 -- 5350 range into two
>  - the first range does not require DFS
> * 5470 -- 5725 does not have a NO-OUTDOOR requirement
>  - (and 500mW translates to 27db, not 26db AFAICT)
>
> Sidenote: The values include lowering txpower by a factor of 2 (3db)
>  for non TPC devices -- the wording in Vfg. 7/2010 does NOT require
>  this for 5150 -- 5250; so we could actually use 200mW/23db there. As
>  this is out of line with the neighbour countries, I have sticked with
>  the conservative value of 100mW here.
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
>        # entries 279004 and 280006
>        (2400 - 2483.5 @ 40), (N/A, 100 mW)
>        # entry 303005
>        (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
>        # entries 304002 and 305002
>        (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
>        # entries 308002, 309001 and 310003
>        (5470 - 5725 @ 40), (N/A, 500 mW), DFS
>
> 8<------------------------------------------------------------------------
>
> (Or in db, as displayed by iw reg get)
> country DE:
>        (2400 - 2483 @ 40), (N/A, 20)
>        (5150 - 5250 @ 40), (N/A, 20), NO-OUTDOOR
>        (5250 - 5350 @ 40), (N/A, 20), NO-OUTDOOR, DFS
>        (5470 - 5725 @ 40), (N/A, 27), DFS
>
> PS: I'm not subscribed, please copy responses to me.

Thanks for the e-mail and your review, I've passed this to our
regulatory gods and it is now being picked at and reviewed.

  Luis
