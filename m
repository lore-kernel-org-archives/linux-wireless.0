Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3I3JJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:09:22 -0400
Message-ID: <1380532158.14467.3.camel@jlt4.sipsolutions.net> (sfid-20130930_110933_233455_E25A6838)
Subject: Re: [PATCH 3.12] mac80211: fix a tx power handling regression
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 11:09:18 +0200
In-Reply-To: <1380458883-19862-1-git-send-email-nbd@openwrt.org>
References: <1380458883-19862-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-09-29 at 14:48 +0200, Felix Fietkau wrote:
> commit 1ea6f9c0d48b11b6ec3ec4b5579ec74fc3951cf8
> "mac80211: handle TX power per virtual interface"
> 
> This commit added support for tracking tx power configuration for
> multiple interfaces, however instead of using the maximum value of all
> virtual interfaces, it uses the minimum.

I'm not sure it should be using the maximum? What if the AP required
lowering TX power by way of TPC for example?

johannes

