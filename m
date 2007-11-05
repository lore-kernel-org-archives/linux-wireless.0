Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52193
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXKEQcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 11:32:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC] ssb: Add code for SPROM Rev 4
Date: Mon, 5 Nov 2007 17:31:33 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <472c9192.8nd7AOTgl+jWptik%Larry.Finger@lwfinger.net> <200711051351.37252.mb@bu3sch.de> <472F3EE3.5040201@lwfinger.net>
In-Reply-To: <472F3EE3.5040201@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711051731.33284.mb@bu3sch.de> (sfid-20071105_163220_709556_8F639822)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 November 2007 17:03:47 Larry Finger wrote:
> 	u8 path_data0[SPROM_PATH_DATA_SIZE];
> 	u8 path_data1 ...
> 
> where SPROM_PATH_DATA_SIZE = 0x26. Once we see how the data are used, it may make more sense to have
> these data be u16,


> or even a union so that we can have it both ways. 
            ^^^^^                        ^^^^^^^^^

Whoops, endianess broken :)

> I'm not sure we need a separate "valid bit" for path data. In the sprom that we are working with,

Ok, even better then.
The "valid bit" was just an idea for stuff in the sprom which cannot
be determined valid or not in another way.

> As I said earlier, my current patch is working OK for present needs. Once we come to an agreement
> regarding the sprom data structures, I will begin implementing them. As I see it, conversion will be
> a 3-step process. We will need a patch to add the new structure, a second to populate that
> structure, patches to convert b44, b43, and b43legacy to use the new data, and a final patch to
> remove the old structure. In this manner, bisection will be supported.

cool :)

Are you going to try a redesign of the structure?
I'm not too motivated to do it, as I don't know too much about
the v4 sprom, yet.

-- 
Greetings Michael.
