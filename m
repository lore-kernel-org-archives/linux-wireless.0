Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3JBKMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 06:12:05 -0400
Message-ID: <1380708715.13329.16.camel@jlt4.sipsolutions.net> (sfid-20131002_121208_588342_8FF5F1B2)
Subject: Re: [PATCH] mac80211: allow mgmt frame transmission on DFS channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 02 Oct 2013 12:11:55 +0200
In-Reply-To: <CAA2SeN+nhLU7vGDNLJCD=UrNRSFm5hT6HGEEhUqr1kAcMF3O-A@mail.gmail.com> (sfid-20131002_120735_165886_3460160D)
References: <1380545557-25103-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1380704100.13329.6.camel@jlt4.sipsolutions.net>
	 <CAA2SeN+nhLU7vGDNLJCD=UrNRSFm5hT6HGEEhUqr1kAcMF3O-A@mail.gmail.com>
	 (sfid-20131002_120735_165886_3460160D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-02 at 12:07 +0200, Lorenzo Bianconi wrote:
> Before start beaconing cfg80211_reg_can_beacon() verifies the channel
> is CAC checked and available calling cfg80211_secondary_chans_ok().
> Although the channel is marked NL80211_DFS_AVAILABLE after a CAC
> period, ieee80211_monitor_start_xmit() does not allow to inject mgmt
> frames on DFS channels causing association failures.

I don't see how this can cause association failures? Please explain.
DFS-capable hostapd doesn't use monitor interfaces with mac80211 any
more.

johannes

