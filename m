Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60955 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932667AbcBBO6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 09:58:25 -0500
Message-ID: <1454425100.2926.3.camel@sipsolutions.net> (sfid-20160202_155837_455736_F3AE9C22)
Subject: Re: [PATCH v4] mac80211: minstrel: Change expected throughput unit
 back to Kbps
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>,
	linux-wireless@vger.kernel.org
Cc: thomas@net.t-labs.tu-berlin.de, antonio@open-mesh.com,
	nbd@nbd.name, Sven Eckelmann <sven@open-mesh.com>
Date: Tue, 02 Feb 2016 15:58:20 +0100
In-Reply-To: <1454397146-2884-1-git-send-email-sven@open-mesh.com> (sfid-20160202_081232_977019_5B1D36A5)
References: <1454397146-2884-1-git-send-email-sven@open-mesh.com>
	 (sfid-20160202_081232_977019_5B1D36A5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-02 at 08:12 +0100, Sven Eckelmann wrote:
> The change from cur_tp to the function
> minstrel_get_tp_avg/minstrel_ht_get_tp_avg changed the unit used for
> the
> current throughput. For example in minstrel_ht the correct
> conversion between them would be:
> 
>     mrs->cur_tp / 10 == minstrel_ht_get_tp_avg(..).
> 
> This factor 10 must also be included in the calculation of
> minstrel_get_expected_throughput and
> minstrel_ht_get_expected_throughput to
> return values with the unit [Kbps] instead of [10Kbps]. Otherwise
> routing
> algorithms like B.A.T.M.A.N. V will make incorrect decision based on
> these
> values. Its kernel based implementation expects expected_throughput
> always
> to have the unit [Kbps] and not sometimes [10Kbps] and sometimes
> [Kbps].
> 
Applied; also added Cc stable.

johannes
