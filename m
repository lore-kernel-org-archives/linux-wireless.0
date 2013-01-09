Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab3AIM0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 07:26:32 -0500
Message-ID: <1357734417.9757.6.camel@jlt4.sipsolutions.net> (sfid-20130109_132636_195405_59DD5716)
Subject: Re: missing RX_FLAG_DECRIPTED in ieee80211_rx_status after first
 reassociation in 802.11R
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Debarge <cedric.debarge@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Jan 2013 13:26:57 +0100
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319014B7055@sbs2003.acksys.local> (sfid-20130108_123142_580099_93DD6C6E)
References: <773DB8A82AB6A046AE0195C68612A319014B7055@sbs2003.acksys.local>
	 (sfid-20130108_123142_580099_93DD6C6E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-08 at 12:11 +0100, Cedric Debarge wrote:
> Hi all,
> 
> 	I dug a little more on this problem and I found that hardware encryption is disabled after the first roam because ieee80211_key_enable_hw_accel fails on the following test :
> 		if (sta && !sta->uploaded) 
> 			goto out_unsupported;
> 
> 	After the first roam, sta->uploaded is tested before sta_info_move_state sets it to true.
> 
> 	At the first association/authentication :
> 	1) sta_info_move_state sets sta->uploaded to true
> 	2) ieee80211_key_enable_hw_accel test it and find it true --> hardware decoding
> 
> 	When the station changes from an AP to another :
> 	1) ieee80211_key_enable_hw_accel test it and find it false --> software decoding
> 	2) sta_info_move_state sets sta->uploaded to true

I cannot reproduce this. Could you obtain tracing information
("trace-cmd record -e cfg80211") on an affected system?

Also a wpa_supplicant debug log would be helpful. Or better yet, use a
new supplicant with the "-T" parameter -- this will make its debug
information go into the cfg80211 tracing that you record as per above.

johannes

