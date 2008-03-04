Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:18033 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbYCDHlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 02:41:21 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH, take 2] libertas: implement SSID scanning for SIOCSIWSCAN
Date: Tue, 4 Mar 2008 07:38:19 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200802261522.05676.hs4233@mail.mn-solutions.de> <1204571891.16248.1.camel@localhost.localdomain>
In-Reply-To: <1204571891.16248.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803040738.19911.hs4233@mail.mn-solutions.de> (sfid-20080304_074146_435072_719BA0B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> However, it never found the hidden AP I was using (ie, it
> never replaced the blank SSID in the iwlist scan results with
> the actual SSID as I'd expect).  I haven't tracked that down
> quite yet, but it might be an issue in the scan result
> handling code or it could be firmware.

Do you mean that 

00:1D:60:14:33:2B   <empty SSID>
00:1D:60:14:33:2B   WLAN

should be unified into

00:1D:60:14:33:2B   WLAN

???


First I wanted to do that, but then I thought that maybe this is 
erraneous. An AP can have several SSIDs, one of them could be 
hidden, the other ones not hidden. E.g. this is easy to setup on 
a Cisco 123x or Cisco 124x access-point.



I also have a "take 3" of this patch now, because I adapted 
(after a chat with David on IRC) the outstanding patches from 
libertas-2.6 to wireless-testing. Two of the patches touched 
scan.c as well, so I rewrote my scan-for-specific-ssid patch to 
apply on top of the 5 David-Woodhouse-patches.
