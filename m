Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab0HHCJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 22:09:51 -0400
Subject: [PATCH 0/5] libertas: firmware loading rework
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 21:11:10 -0500
Message-ID: <1281233470.6235.12.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I dumped a ton of Libertas firmware into linux-firmware a long time ago,
but the driver was never updated to use the linux-firmware locations.
Fix that.  USB uses one-stage firmware so it doesn't need to use the
common helper.

John: this is 2.6.37 material.

Dan Williams (5):
  libertas: [usb] use new firmware locations
  libertas: add two-stage firmware request helper
  libertas: [cs] use common firmware request helper and new firmware locations
  libertas: [sdio] use common firmware request helper and new firmware locations
  libertas: [spi] use common firmware request helper and new firmware locations

 drivers/net/wireless/libertas/decl.h    |   13 +++
 drivers/net/wireless/libertas/if_cs.c   |  130 ++++++++++++++++------------
 drivers/net/wireless/libertas/if_sdio.c |  143 +++++++++++++------------------
 drivers/net/wireless/libertas/if_sdio.h |    4 -
 drivers/net/wireless/libertas/if_spi.c  |  144 +++++++++++++++----------------
 drivers/net/wireless/libertas/if_spi.h  |    5 -
 drivers/net/wireless/libertas/if_usb.c  |   60 +++++++++++--
 drivers/net/wireless/libertas/if_usb.h  |    1 +
 drivers/net/wireless/libertas/main.c    |  105 ++++++++++++++++++++++
 9 files changed, 375 insertions(+), 230 deletions(-)

-- 
1.7.2.1


