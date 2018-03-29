Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr00097.outbound.protection.outlook.com ([40.107.0.97]:51524
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751714AbeC2QVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 12:21:06 -0400
Subject: [PATCH net-next 3/5] security: Remove rtnl_lock() in
 selinux_xfrm_notify_policyload()
From: Kirill Tkhai <ktkhai@virtuozzo.com>
To: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        pshelar@ovn.org, johannes@sipsolutions.net, paul@paul-moore.com,
        sds@tycho.nsa.gov, eparis@parisplace.org, jmorris@namei.org,
        serge@hallyn.com, leon@kernel.org, yuval.shaia@oracle.com,
        parav@mellanox.com, danielj@mellanox.com, ktkhai@virtuozzo.com,
        majd@mellanox.com, nicolas.dichtel@6wind.com, vyasevic@redhat.com,
        paulmck@linux.vnet.ibm.com, vyasevich@gmail.com,
        gregkh@linuxfoundation.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, ast@kernel.org, brouer@redhat.com,
        linux@rasmusvillemoes.dk, john.fastabend@gmail.com,
        dsahern@gmail.com, jiri@mellanox.com, idosch@mellanox.com,
        vvs@virtuozzo.com, avagin@virtuozzo.com, roman.kapl@sysgo.com,
        lucien.xin@gmail.com, christian.brauner@ubuntu.com,
        jbenc@redhat.com, pombredanne@nexb.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, dev@openvswitch.org,
        linux-wireless@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Date: Thu, 29 Mar 2018 19:20:56 +0300
Message-ID: <152234045636.19153.4897050357891895124.stgit@localhost.localdomain> (sfid-20180329_182120_203944_688FEA28)
In-Reply-To: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
References: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt_genid_bump_all() consists of ipv4 and ipv6 part.
ipv4 part is incrementing of net::ipv4::rt_genid,
and I see many places, where it's read without rtnl_lock().

ipv6 part calls __fib6_clean_all(), and it's also
called without rtnl_lock() in other places.

So, rtnl_lock() here was used to iterate net_namespace_list only,
and we can remove it.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 security/selinux/include/xfrm.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 31d66431be1e..a0b465316292 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -47,12 +47,10 @@ static inline void selinux_xfrm_notify_policyload(void)
 {
 	struct net *net;
 
-	rtnl_lock();
 	down_read(&net_rwsem);
 	for_each_net(net)
 		rt_genid_bump_all(net);
 	up_read(&net_rwsem);
-	rtnl_unlock();
 }
 #else
 static inline int selinux_xfrm_enabled(void)
