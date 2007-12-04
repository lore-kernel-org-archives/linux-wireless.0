Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:8094 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbXLDKj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 05:39:57 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: questions regarding removing the depencency on CONFIG_IEEE80211
Date: Tue, 4 Dec 2007 11:40:07 +0100
Cc: libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712041140.07516.hs4233@mail.mn-solutions.de> (sfid-20071204_104003_822443_169A4663)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Last friday I was asked on IRC about the dependency of libertas 
on CONFIG_IEEE80211. I gave a quick question, but today I had 
time to look into this further.


1. simply things

* remove "select IEEE80211" in wireless/KConfig
* remove "#include <net/ieee80211.h>"


2. MAX_WPA_IE_LEN

This was defined in net/ieee80211.h, but is not defined in 
linux/ieee80211.h. I have two options, which one should I go:

* define it locally in some libertas header file
* define it as IEEE80211_MAX_WPA_IE_LEN in linux/ieee80211.h


3. MAX_NETWORK_COUNT

libertas has a list of found BSSses during scanning. It keeps 
them in an kzalloc()'ed array. However, it doesn't use any of
ieee80211's code for BSS or associating, so I guess I make this a 
private define, e.g. LBS_MAX_BSS_COUNT.


4. DEFAULT_MAX_SCAN_AGE

Again, libertas doesn't use any aging code from ieee80211, so I 
guess I make this a libertas-private define.


5. MFIE_TYPE_xxxx enum

They are easily substituded with the proper WLAN_EID_xxx ones.


6. struct ieee80211_info_element

In scan.c, libertas uses heavily the "struct 
ieee80211_info_element". As this struct might be useful for 
other non-max80211 drivers, I'd suggest putting it in 
include/linux/ieee80211.h.


7. RADIOTAP

Libertas contains lot's of code for it's monitoring mode, which 
uses radiotap. It used "struct net_device *rtap_net_dev" 
and "struct ieee80211_device *ieee". It contains code like

   priv->rtap_net_dev = alloc_ieee80211(0);
   priv->ieee = netdev_priv(priv->rtap_net_dev);

and I don't have any knowledge about radiotap and how to 
substitue the alloc_ieee80211(). All I could currently to is to 
put those sections into #ifdef CONFIG_IEEE80211.
