Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:35009 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753218Ab2B1GFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 01:05:13 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/6] mwifiex: improvements for 3.4
Date: Mon, 27 Feb 2012 22:04:10 -0800
Message-Id: <1330409056-4399-1-git-send-email-bzhao@marvell.com> (sfid-20120228_070518_336668_3EDC406E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Please find the following patches in this submission. I've mixed V1
and V2 patches here as they have dependences.
 
[PATCH 1/6 V2] mwifiex: correct bitrates advertised to cfg80211

  The V1 patch was submitted for 3.3. Now I'm submitting the V2 for 3.4
as it doesn't cause any real problem in 3.3 or ealier versions.

[PATCH 2/6 RESEND] mwifiex: remove unnecessary enum MWIFIEX_802_11_WEP_STATUS
[PATCH 3/6 RESEND] mwifiex: handle auto authentication mode correctly

  These two patches are included here just for your convenience.
  They depend on
    "[PATCH 3.3] mwifiex: reset encryption mode flag before association" and
    "[PATCH 3.4] mwifiex: remove redundant scan operation"
  submitted previously.

[PATCH 4/6] mwifiex: remove unnecessary struct mwifiex_802_11_ssid

  This is a new cleanup patch for 3.4.

[PATCH 5/6 V2] mwifiex: fix bug in wildcard scan handling

  The V1 patch was submitted for 3.3. Now I'm submitting the V2 for 3.4
because it depends on PATCH 4/6 which is intended for 3.4.

[PATCH 6/6] mwifiex: remove BSS entry before specific SSID scan

  This is a new enhancement patch for specific scan, intended for 3.4.

Thanks,
Bing

---

Amitkumar Karwar (5):
  mwifiex: remove unnecessary enum MWIFIEX_802_11_WEP_STATUS
  mwifiex: handle auto authentication mode correctly
  mwifiex: remove unnecessary struct mwifiex_802_11_ssid
  mwifiex: fix bug in wildcard scan handling
  mwifiex: remove BSS entry before specific SSID scan

Avinash Patil (1):
  mwifiex: correct bitrates advertised to cfg80211

 drivers/net/wireless/mwifiex/cfg80211.c  |   32 ++++-----
 drivers/net/wireless/mwifiex/cmdevt.c    |    8 +--
 drivers/net/wireless/mwifiex/decl.h      |    5 --
 drivers/net/wireless/mwifiex/fw.h        |   15 +---
 drivers/net/wireless/mwifiex/init.c      |    2 +-
 drivers/net/wireless/mwifiex/ioctl.h     |    4 +-
 drivers/net/wireless/mwifiex/join.c      |   11 ++--
 drivers/net/wireless/mwifiex/main.h      |   18 +++---
 drivers/net/wireless/mwifiex/scan.c      |  111 ++++++++++++++++--------------
 drivers/net/wireless/mwifiex/sta_event.c |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |   26 +++++--
 11 files changed, 116 insertions(+), 118 deletions(-)

