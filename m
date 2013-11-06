Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab3KFKJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:09:41 -0500
Message-ID: <1383732576.14307.17.camel@jlt4.sipsolutions.net> (sfid-20131106_110943_422117_60FB972A)
Subject: Re: [PATCH v2 2/5] mac80211: DFS setup chandef for radar_event
 correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 11:09:36 +0100
In-Reply-To: <1383659329-11023-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_144903_057029_DB5687D1)
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1383659329-11023-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131105_144903_057029_DB5687D1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-05 at 14:48 +0100, Janusz Dziedzic wrote:
> Setup chandef for radar event correctly, before we
> will clear this in ieee80211_dfs_cac_cancel() function.
> 
> Without this patch mac80211 will report wrong channel
> width in case we will get radar event during active CAC.

I'll apply this, but I note that a lot of the DFS stuff is really broken
in 3.12 (did 3.11 have any?) I think you should try to get a patch into
stable that disables DFS in ath9k.

johannes


