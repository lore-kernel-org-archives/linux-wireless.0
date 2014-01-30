Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaA3Jvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 04:51:47 -0500
Message-ID: <1391075501.4323.1.camel@jlt4.sipsolutions.net> (sfid-20140130_105153_227716_D813855E)
Subject: Re: [PATCH v2] mac80211: Fix IBSS disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 30 Jan 2014 10:51:41 +0100
In-Reply-To: <1391071648-12863-1-git-send-email-sujith@msujith.org>
References: <1391071648-12863-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-30 at 14:17 +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Currently, when a station leaves an IBSS network, the
> corresponding BSS is not dropped from cfg80211 if there are
> other active stations in the network. But, the small
> window that is present when trying to determine a station's
> status based on IEEE80211_IBSS_MERGE_INTERVAL introduces
> a race.
> 
> Instead of trying to keep the BSS, always remove it when
> leaving an IBSS network. There is not much benefit to retain
> the BSS entry since it will be added with a subsequent join
> operation.
> 
> This fixes an issue where a dangling BSS entry causes ath9k
> to wait for a beacon indefinitely.

Applied.

johannes

