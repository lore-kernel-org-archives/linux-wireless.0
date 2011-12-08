Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:54876 "HELO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751575Ab1LHH2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 02:28:24 -0500
Date: Thu, 8 Dec 2011 12:52:45 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH] mac80211: Purge A-MPDU TX queues before station
 destructions
Message-ID: <20111208072243.GA4680@hertz.marvell.com> (sfid-20111208_082827_891892_61590A0D)
References: <20111208064124.GA4406@hertz.marvell.com>
 <CANUX_P3sXXTP7C1hq0kKpTh98gtR6dsnDZQvs4Kq6kR3sbRrYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P3sXXTP7C1hq0kKpTh98gtR6dsnDZQvs4Kq6kR3sbRrYw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 11:07:13PM -0800, Emmanuel Grumbach wrote:
> >
> > When a station leaves suddenly while ampdu traffic to that station is still
> > running, there is a possibility that the ampdu pending queues are not freed due
> > to a race condition leading to memory leaks. In '__sta_info_destroy' when we
> > attempt to destroy the ampdu sessions in 'ieee80211_sta_tear_down_BA_sessions',
> > the driver calls 'ieee80211_stop_tx_ba_cb_irqsafe' to delete the ampdu
> > structures (tid_tx) and splice the pending queues and this job gets queued in
> > sdata workqueue. However, the sta entry can get destroyed before the above work
> > gets scheduled and hence the race.
> >
> > Purging the queues and freeing the tid_tx to avoid the leak. The better solution
> > would be to fix the race, but that can be taken up in a separate patch.
> >
> 
> Did you actually run into that race, or you can see the bug from code
> inspection ?
We did see this while running stress tests.
