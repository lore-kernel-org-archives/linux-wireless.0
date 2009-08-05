Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:35125 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZHEUc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:32:59 -0400
Received: by ewy10 with SMTP id 10so291644ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 13:32:59 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 0/4] orinoco: use cfg80211 for key manipulation
Date: Wed,  5 Aug 2009 21:32:48 +0100
Message-Id: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First attempt at connect/disconnect, join_ibss/leave_ibss, and add_key
etc. These patches rely on the series I just sent, but conflict with
Holgers set_channel patch. Simple to resolve, and I'll do that in my
next update.

This doesn't work yet*, but I've a number of questions.

- The cfg80211 notification functions like cfg80211_connect_result
  are not called in this series. Does the driver need to keep track of
  each call and make sure it calls the right notifer? Right now orinoco
  arbitrarily sends SIOCGIWAP, IWEVASSOCRESPIE and IWEVASSOCREQIE on
  ?authorisation? Also not sure how this will tie in with
  cfg80211_send_rx_auth/assoc.

- In station mode, is the connect crypto struct fully filled in
  regardless of WEP/WPA? I'd like to set priv->encode_alg at this stage,
  and then only accept keys of that type via add_key. Unfortunately
  join_ibss doesn't have similar info.

- In adhoc mode, how do you set open/shared WEP? i.e. how does orinoco
  know to set priv->wep_restrict?

- Digging around cfg80211, it looks like set_default_key isn't called
  when authentication is TKIP. How does the driver tell which key to use
  for transmit? Are we supposed to assume the group key is the transmit
  key?

- TKIP pairwise keys. I think orinoco has always ignored them. The Agere
  driver installed pairwaise keys to index 0. Should I attempt anything?

- TKIP and ad-hoc. err... I plan on leaving this alone.


All hints greatly appreciated :)



Dave.

* wpa_supplicant in wext mode gets stuck in the ASSOCIATING state.
  Haven't tried nl80211 mode.

---
David Kilroy (4):
  orinoco: add cfg80211 connect and disconnect
  orinoco: add cfg80211 join_ibss and leave_ibss
  orinoco: implement cfg80211 key manipulation functions
  orinoco: do WE via cfg80211

 drivers/net/wireless/orinoco/cfg.c  |  486 +++++++++++++++++++++++
 drivers/net/wireless/orinoco/wext.c |  726 +----------------------------------
 2 files changed, 497 insertions(+), 715 deletions(-)

