Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:59967 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaDGP2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 11:28:55 -0400
Received: from smtp02.msg.oleane.net (smtp02.mail.priv [172.17.20.111])
	by smtp-out05.msg.oleane.net with ESMTP id s37CPQQ2022207
	for <linux-wireless@vger.kernel.org>; Mon, 7 Apr 2014 14:25:26 +0200
From: "voncken" <cedric.voncke@acksys.fr>
To: "'Janusz Dziedzic'" <janusz.dziedzic@gmail.com>,
	"Cedric VONCKEN" <cedric.voncken@acksys.fr>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319017342EF@sbs2003.acksys.local> <CAFED-j=nyEnfg7n=OF0oA_Geh11DR_XYNPTLeb603jKNNUxv0g@mail.gmail.com>
In-Reply-To: <CAFED-j=nyEnfg7n=OF0oA_Geh11DR_XYNPTLeb603jKNNUxv0g@mail.gmail.com>
Subject: RE: [MAC80211] Radar detection management issue
Date: Mon, 7 Apr 2014 14:04:51 +0200
Message-ID: <00dc01cf5259$94fd02d0$bef70870$@acksys.fr> (sfid-20140407_172859_440388_D365D3DF)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> >         I don't know how fix this issue. For the moment I disable the
> > channel when the NL80211_RRF_DFS is set (in map_regdom_flags).
> >
> 
> This seems like a bug in ath9k (init.c) driver, when register interface
> combinations.
> Seems RADAR combination should be registered only in case when
> ATH9K_DFS_CERTIFIED is set.
	
	Thanks for the answer. 

	The ATH9K_HW_CAP_DFS is set in hw.c only  if the function
ath9k_hw_dfs_tested return true.

	In the ath9k/init.c, the function ath9k_set_hw_capab do not set any
flags in hw->flags relevant to DFS.

	I'm looking for a similar line
	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_DFS)
      	hw->flags |= IEEE80211_HW_xxxx;
	
	But I don't found. 

	I'm looking in net/mac80211.h the IEEE80211 flag relevant to DFS (to
add the test in ath9k init), but I don't found it.

	It seem the mac80211 do not know the hardware capability to detect
radar.

	Cedric.
> 
> BR
> Janusz

