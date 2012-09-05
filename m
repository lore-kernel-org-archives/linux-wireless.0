Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2259 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab2IEJtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 05:49:41 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: [PATCH 0/2] brcmsmac: fix for regulatory rules and flush
 callback
Date: Wed, 5 Sep 2012 11:49:20 +0200
Message-ID: <1346838562-4818-1-git-send-email-arend@broadcom.com> (sfid-20120905_114946_214327_B368BC00)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two fixes intended for the wireless tree. The issue with the .flush() has
been giving me a lot of email from RedHat's bugzilla server. Hope this
patch will silence that ;-)

The other issue was introduced with regulatory changes made by Seth Forshee
as he remove rule for channel 14 upon my review comment, but n_rules field
was not decreased so we got a random rule with bad side-effects.

Cc: Seth Forshee <seth.forshee@canonical.com>

Arend van Spriel (2):
  brcmsmac: fix mismatch in number of custom regulatory rules
  brcmsmac: rework of mac80211 .flush() callback operation

 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   41 +++++++++++++-------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   21 +++-------
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    4 +-
 5 files changed, 38 insertions(+), 33 deletions(-)

-- 
1.7.9.5


