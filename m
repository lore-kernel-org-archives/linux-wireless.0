Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:33708 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbcDFJ1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:27:43 -0400
Received: by mail-qk0-f169.google.com with SMTP id k135so11461134qke.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 02:27:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 6 Apr 2016 12:27:42 +0300
Message-ID: <CAFSVvRc2N+ONKsvweOPRHHrtFDfhKPxXDVM9fsaa+Sd=qAdEgw@mail.gmail.com> (sfid-20160406_112747_821871_713DBF62)
Subject: [PATCH] NETLINK_URELEASE non-bound socket problem
From: Dmitrijs Ivanovs <dmitrijs.ivanovs@ubnt.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, any non-privileged user can create netlink socket
with port_id equal to port_id used by hostapd to create wireless network
interfaces on-the-fly when more than one BSS is configured. When such socket
is closed, nl80211 will receive socket release notification and such virtual
interfaces will be removed while hostapd is still running.

This patch introduces two additional checks to correct the problem:

1) Do not send netlink socket release notification when socket is not
bound.
2) Check protocol number in nl80211 netlink socket release notification
handler.

Signed-off-by: Dmitry Ivanov <dima@ubnt.com>
---
 net/netlink/af_netlink.c | 2 +-
 net/wireless/nl80211.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 215fc08..330ebd6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -688,7 +688,7 @@ static int netlink_release(struct socket *sock)

     skb_queue_purge(&sk->sk_write_queue);

-    if (nlk->portid) {
+    if (nlk->portid && nlk->bound) {
         struct netlink_notify n = {
                         .net = sock_net(sk),
                         .protocol = sk->sk_protocol,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 98c9242..056a730 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13216,7 +13216,7 @@ static int nl80211_netlink_notify(struct
notifier_block * nb,
     struct wireless_dev *wdev;
     struct cfg80211_beacon_registration *reg, *tmp;

-    if (state != NETLINK_URELEASE)
+    if (state != NETLINK_URELEASE || notify->protocol != NETLINK_GENERIC)
         return NOTIFY_DONE;

     rcu_read_lock();
-- 
2.1.4
