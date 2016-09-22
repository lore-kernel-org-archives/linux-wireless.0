Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:60166 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934155AbcIVREn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 13:04:43 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v9 0/2] mac80211: TXQ dequeue path rework
Date: Thu, 22 Sep 2016 19:04:18 +0200
Message-Id: <20160922170420.5193-1-toke@toke.dk> (sfid-20160922_190446_954643_9940028D)
In-Reply-To: <20160906114426.25520-1-toke@toke.dk>
References: <20160906114426.25520-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the ninth iteration of my attempts to reorder the TXQ dequeue
path to avoid issues with reorder-sensitive operations. This version is
split into two patches; the first one moves ieee80211_tx_dequeue() to
avoid adding function stubs at the top of tx.c.

Changes since v8:
- Don't add function stubs to the beginning of tx.c
- Don't use control.hw_key from the dequeued packet, since that can go
  away while the packet is queued. Instead, run the select_key handler
  on dequeue and use the key from that.
- Change places that check tin.backlog_packets as an indication of
  whether the TXQ has anything queued to also look at the 'frags' queue.
- Don't change the order of the select_key handler with respect to the
  other handlers.
- Rebase on current mac80211-next tree.

Toke H=C3=B8iland-J=C3=B8rgensen (2):
  mac80211: Move ieee802111_tx_dequeue() to later in tx.c
  mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue

 include/net/mac80211.h     |   2 +
 net/mac80211/ieee80211_i.h |   8 ++
 net/mac80211/rx.c          |   4 +-
 net/mac80211/sta_info.c    |  10 +-
 net/mac80211/tx.c          | 335 +++++++++++++++++++++++++++++++--------=
------
 net/mac80211/util.c        |  11 +-
 6 files changed, 256 insertions(+), 114 deletions(-)

--=20
2.9.3

base-commit: c13ed534b8db543e4d8ead3885f4b06585a5771c
