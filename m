Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab0HUA3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 20:29:18 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, geoclue@lists.freedesktop.org,
	David.Quan@atheros.com, kevin@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] iw: add GeoClue support
Date: Fri, 20 Aug 2010 20:29:14 -0400
Message-Id: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds GeoClue support to iw.

A few items we should take into consideration for future
innovation and improvements.

 - The hostip provider should be extended to listen to signals for
   network connetions, and once one becomes availble we can enable
   asynchronous notifications back to the kernel.

 - Extend this to try first the GeoClue gypsy provider, gpsd.

 - Consider writing a GeoClue provider for https://wigle.net/
   which the supplicant can use to inform GeoClue of location.

 - Consider writing our own GeoClue provider based on timezones
   as a last resort.

 - Consider whether or not the kernel may want accuracy
   information as well to make more interesting decisions.

Luis R. Rodriguez (2):
  iw: make is_alpha2() available to other objects
  iw: add GeoClue support for automatically determining location

 COPYING  |    2 +-
 Makefile |    7 +++
 georeg.c |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 iw.h     |    1 +
 reg.c    |    2 +-
 5 files changed, 182 insertions(+), 2 deletions(-)
 create mode 100644 georeg.c

