Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52266 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1LHHHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 02:07:14 -0500
Received: by wgbds13 with SMTP id ds13so784452wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 23:07:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111208064124.GA4406@hertz.marvell.com>
References: <20111208064124.GA4406@hertz.marvell.com>
Date: Thu, 8 Dec 2011 09:07:13 +0200
Message-ID: <CANUX_P3sXXTP7C1hq0kKpTh98gtR6dsnDZQvs4Kq6kR3sbRrYw@mail.gmail.com> (sfid-20111208_080719_996351_9105A47E)
Subject: Re: [PATCH] mac80211: Purge A-MPDU TX queues before station destructions
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> When a station leaves suddenly while ampdu traffic to that station is still
> running, there is a possibility that the ampdu pending queues are not freed due
> to a race condition leading to memory leaks. In '__sta_info_destroy' when we
> attempt to destroy the ampdu sessions in 'ieee80211_sta_tear_down_BA_sessions',
> the driver calls 'ieee80211_stop_tx_ba_cb_irqsafe' to delete the ampdu
> structures (tid_tx) and splice the pending queues and this job gets queued in
> sdata workqueue. However, the sta entry can get destroyed before the above work
> gets scheduled and hence the race.
>
> Purging the queues and freeing the tid_tx to avoid the leak. The better solution
> would be to fix the race, but that can be taken up in a separate patch.
>

Did you actually run into that race, or you can see the bug from code
inspection ?
