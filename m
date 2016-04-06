Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34713 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbcDFOWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 10:22:52 -0400
Received: by mail-lb0-f171.google.com with SMTP id vo2so30968388lbb.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 07:22:51 -0700 (PDT)
Received: from di ([80.233.186.214])
        by smtp.gmail.com with ESMTPSA id r9sm503111lfr.33.2016.04.06.07.22.49
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 06 Apr 2016 07:22:49 -0700 (PDT)
Date: Wed, 6 Apr 2016 17:22:48 +0300
From: Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] Do not send netlink socket release notification when
 socket is not bound
Message-Id: <20160406172248.b032ff227e4843a836e00802@ubnt.com> (sfid-20160406_162255_804347_6B014CD5)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch corrects the problem where non-privileged user may create
netlink socket with port_id equal to port_id used by hostapd to create
virtual wireless network interfaces. Call to bind() will fail for such
socket, but release notification sent on close() or process termination
to nl80211 subsystem will destroy virtual network interfaces while
hostapd is still running.

Signed-off-by: Dmitry Ivanov <dima@ubnt.com>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 215fc08..330ebd6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -688,7 +688,7 @@ static int netlink_release(struct socket *sock)
 
 	skb_queue_purge(&sk->sk_write_queue);
 
-	if (nlk->portid) {
+	if (nlk->portid && nlk->bound) {
 		struct netlink_notify n = {
 						.net = sock_net(sk),
 						.protocol = sk->sk_protocol,
-- 
2.1.4

