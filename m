Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E2BC64EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28762214C4
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="WiIpL7oh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28762214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbeJITtp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 15:49:45 -0400
Received: from mail.toke.dk ([52.28.52.200]:45889 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbeJITto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 15:49:44 -0400
Subject: [PATCH RFC v5 0/4] Move TXQ scheduling and airtime fairness into
 mac80211
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1539088379; bh=PYhap6e+LgD62xbHKx4Nu3IyDknvyOQdZS7G1S+BixM=;
        h=Subject:From:To:Cc:Date:From;
        b=WiIpL7ohG5GHLHjxtU+jxp4t+gGwh+FzOYFm2nLkQuINZYER5RFWKQFEwtyBVoFJ1
         M9wHM+4NTSvLv8ClKQstZmuNun8mSuE7KQ2RbyPi0KphaZlt+XfS9wzT353o0oxcFf
         Z90Uh8Ptzix3PwlmqId1dIyBsxQ3hN6m+J1PsTB5ApfhvC4TpkE5zQ65teuHth/Wn7
         4EY2VQSdkvWPyXoATW1oH3mlrItvhFuRqnBz3Erdd2EcWKZj9c3vjk6UW9BDF2acTa
         DLZdcsrn0+LnlCEoAki31lS8RvAb3dQgGgMyq4Fyocw020QQgcmf+GcTVVUhMgbGrV
         i001nCOIT5QSA==
From:   Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To:     linux-wireless@vger.kernel.org
Cc:     make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Date:   Tue, 09 Oct 2018 14:32:58 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <153908805217.9471.9290979918041653328.stgit@alrua-kau>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Another updated version, addressing a few issues with the previous
version.

- Moved the airtime deficit queue wakeup code to its own tasklet to
  lower overhead.

- Change the tasklet to just wake a single queue on each invocation,
  relying to TX completion to continue transmissions.

- Don't try to re-schedule TXQs of stations that are being removed.

- A few cleanups and fixes.

The one thing I didn't change was to add another callback that the
driver can use to trigger the tasklet. Since it's now in its own
tasklet, hopefully the overhead is low enough that we can just call it
on every end_schedule(); and I'd rather not complicate the driver API
further.

Thanks to Rajkumar for testing the previous version. I thought I'd have
time to test this version myself and was planning to send as a non-RFC
PATCH after that, but that time didn't materialise. So I thought it was
better to send another RFC version instead of everyone having to suffer
from my tardiness :)

-Toke

---

Toke Høiland-Jørgensen (4):
      mac80211: Add TXQ scheduling API
      cfg80211: Add airtime statistics and settings
      mac80211: Add airtime accounting and scheduling to TXQs
      ath9k: Switch to mac80211 TXQ scheduling and airtime APIs


 drivers/net/wireless/ath/ath9k/ath9k.h     |   14 --
 drivers/net/wireless/ath/ath9k/debug.c     |    3 
 drivers/net/wireless/ath/ath9k/debug.h     |    8 -
 drivers/net/wireless/ath/ath9k/debug_sta.c |   54 ------
 drivers/net/wireless/ath/ath9k/init.c      |    3 
 drivers/net/wireless/ath/ath9k/recv.c      |    9 -
 drivers/net/wireless/ath/ath9k/xmit.c      |  244 ++++++++--------------------
 include/net/cfg80211.h                     |   10 +
 include/net/mac80211.h                     |  113 +++++++++++++
 include/uapi/linux/nl80211.h               |   15 ++
 net/mac80211/agg-tx.c                      |    2 
 net/mac80211/cfg.c                         |    3 
 net/mac80211/debugfs.c                     |    3 
 net/mac80211/debugfs_sta.c                 |   51 ++++++
 net/mac80211/driver-ops.h                  |    9 +
 net/mac80211/ieee80211_i.h                 |   14 ++
 net/mac80211/main.c                        |   11 +
 net/mac80211/sta_info.c                    |   54 ++++++
 net/mac80211/sta_info.h                    |   13 +
 net/mac80211/status.c                      |    6 +
 net/mac80211/tx.c                          |  137 ++++++++++++++++
 net/mac80211/util.c                        |   75 +++++++++
 net/wireless/nl80211.c                     |   29 +++
 23 files changed, 603 insertions(+), 277 deletions(-)

