Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:33701 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759561AbcIWT72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 15:59:28 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 0/3] Add memory limits to fq.h and mac80211 TXQ
Date: Fri, 23 Sep 2016 21:59:08 +0200
Message-Id: <20160923195911.4572-1-toke@toke.dk> (sfid-20160923_215937_824017_4FEE0DD2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a series of small patches to avoid OOM conditions on small
wireless devices with the mac80211 intermediate TXQ structure. The
current default limit in fq.h translates to up to 16 Mbytes of memory
usage, which can be fatal to a device with 32 MBytes of total RAM.

Rather than just change the fq_limit, this ports the memory limit
mechanism from the fq_codel qdisc. The second patch in the series just
adds the new fields to the mac80211 'aqm' debugfs file.

The third patch changes mac80211 to set a lower memory limit for non-VHT
devices. The assumption is that (a) for 802.11n and lower 4 Mbytes of
total queue (2048 packets, 64 max-size aggregates) is plenty, and so it
is safe to simply limit the queue size. And (b) that VHT-capable devices
are usually installed in systems equipped with more system memory.

Toke H=C3=B8iland-J=C3=B8rgensen (3):
  fq.h: Port memory limit mechanism from fq_codel
  mac80211: Export fq memory limit information in debugfs
  mac80211: Set lower memory limit for non-VHT devices

 include/net/fq.h       |  3 +++
 include/net/fq_impl.h  |  7 ++++++-
 net/mac80211/debugfs.c |  8 ++++++++
 net/mac80211/tx.c      | 18 ++++++++++++++++++
 4 files changed, 35 insertions(+), 1 deletion(-)

--=20
2.9.3

base-commit: fb2a3d5c7c85cb6e8bc88192be919b4ef8d6e630
