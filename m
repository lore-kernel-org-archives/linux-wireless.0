Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57473 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbYK1WpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 17:45:03 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
Date: Fri, 28 Nov 2008 23:44:29 +0100
References: <4902DEBB.3050205@hotmail.com> <BAY104-DAV1D226EA8FB16BE36E3C84991A0@phx.gbl> <BAY104-DAV671C2C6DE8B2A05AD785E99040@phx.gbl>
In-Reply-To: <BAY104-DAV671C2C6DE8B2A05AD785E99040@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811282344.29293.mb@bu3sch.de> (sfid-20081128_234508_294330_4E5B5ACE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 November 2008 06:34:34 Shaddy Baddah wrote:
> case the same simple function replacement would not be OK. But I saw 
> several places where memcmp() is preferred to compare_ether_addr(), 
> which I assume indicates that mac80211 does not expect alignment of 
> 80211 packets passed to it.

The whole networking stack expects 4byte alignment and the driver _must_
make sure it is this way. Either by padding a constant number of bytes at the front
of each allocated SKB, or (if the alignment differs) use dynamic checks
for the lowest few bits of the pointer passed to mac80211.


-- 
Greetings Michael.
