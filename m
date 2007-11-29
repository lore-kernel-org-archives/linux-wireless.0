Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:28544 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbXK2JCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 04:02:17 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: coding style lesson: iwlwifi vs. endianness
Date: Thu, 29 Nov 2007 10:03:12 +0100
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>
References: <1196189059.6058.95.camel@johannes.berg> <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com>
In-Reply-To: <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711291003.12423.hs4233@mail.mn-solutions.de> (sfid-20071129_090222_013093_3F26322A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I know it is tempting to teach BIG Intel

Hmm, Intel is not the enemy or foe. It's actually quite liked, 
because Intel is playing in many ways quite open and helpful 
towards the OSS community. Having experienced openly 
downloadable manuals for PXA processors from Intel and now the 
barricaded website from Marvell, after they took over 
PXA255/PXA270 ...


But back to the topic:

A driver that I happen to know quite well now is the 
(non-mac80211) libertas in drivers/net/wireless/libertas/. And 
this driver happens to use le16_to_cpu() and cpu_to_le16() all 
over the place. Both in it's library part and in it's hardware 
interface module (if_usb.c, if_cf.c, if_sdio.c).

That makes it easy to keep the thing "sparse"-clean. I wrote the 
compact-flash code on x86. And others used that later on ARM and 
MIPS (I'm going to use it on PXA as well). They didn't have a 
endianness problem so far.

So, using that programming idiom paid well back.
