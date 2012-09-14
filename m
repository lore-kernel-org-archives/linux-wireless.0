Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12068 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062Ab2INOn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 10:43:56 -0400
Date: Fri, 14 Sep 2012 22:43:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hante Meuleman <meuleman@broadcom.com>
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: [iwlwifi:master 67/70]
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:732:42: sparse:
 invalid assignment: |=
Message-ID: <20120914144351.GA23614@localhost> (sfid-20120914_164405_930438_ED272BE1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hante,

FYI, there are new sparse warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git master
head:   99f314c04ff5f4cfd969f5fbe82d6d0c0a7d8336
commit: e756af5b30b008f6ffcfebf8ad0b477f6f225b62 [67/70] brcmfmac: add e-scan support.

All sparse warnings:

+ drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:732:42: sparse: invalid assignment: |=
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:732:42:    left side has type restricted __le16
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:732:42:    right side has type int
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:734:42: sparse: invalid assignment: |=
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:734:42:    left side has type restricted __le16
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:734:42:    right side has type int
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:737:42: sparse: invalid assignment: |=
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:737:42:    left side has type restricted __le16
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:737:42:    right side has type int
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:738:42: sparse: invalid assignment: |=
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:738:42:    left side has type restricted __le16
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:738:42:    right side has type int
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:740:42: sparse: invalid assignment: |=
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:740:42:    left side has type restricted __le16
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:740:42:    right side has type int
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:743:50: sparse: invalid assignment: |=
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:743:50:    left side has type restricted __le16
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:743:50:    right side has type int
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:745:50: sparse: invalid assignment: |=
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:745:50:    left side has type restricted __le16
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:745:50:    right side has type int
+ drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:750:33: sparse: restricted __le16 degrades to integer
+ drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:748:52: sparse: incorrect type in assignment (different base types)
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:748:52:    expected restricted __le16 <noident>
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:748:52:    got int
+ drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:754:33: sparse: cast from restricted __le16
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:768:39: sparse: incorrect type in assignment (different base types)
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:768:39:    expected unsigned int [unsigned] [addressable] [usertype] SSID_len
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:768:39:    got restricted __le32 [usertype] <noident>
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:2846:40: sparse: restricted __le16 degrades to integer
  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:2846:52: sparse: restricted __le16 degrades to integer

vim +732 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
   722		n_channels = request->n_channels;
   723		/* Copy channel array if applicable */
   724		WL_SCAN("### List of channelspecs to scan ### %d\n", n_channels);
   725		if (n_channels > 0) {
   726			for (i = 0; i < n_channels; i++) {
   727				chanspec = 0;
   728				req_channel = request->channels[i];
   729				channel = ieee80211_frequency_to_channel(
   730						req_channel->center_freq);
   731				if (req_channel->band == IEEE80211_BAND_2GHZ)
 > 732					chanspec |= WL_CHANSPEC_BAND_2G;
   733				else
   734					chanspec |= WL_CHANSPEC_BAND_5G;
   735	
   736				if (req_channel->flags & IEEE80211_CHAN_NO_HT40) {
   737					chanspec |= WL_CHANSPEC_BW_20;
   738					chanspec |= WL_CHANSPEC_CTL_SB_NONE;
   739				} else {
   740					chanspec |= WL_CHANSPEC_BW_40;
   741					if (req_channel->flags &
   742							IEEE80211_CHAN_NO_HT40PLUS)

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu, Yuanhan Liu                              Intel Corporation
