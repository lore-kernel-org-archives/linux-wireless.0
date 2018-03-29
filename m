Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0111.outbound.protection.outlook.com ([104.47.0.111]:59470
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751714AbeC2QVa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 12:21:30 -0400
Subject: [PATCH net-next 5/5] net: Remove rtnl_lock() in
 nf_ct_iterate_destroy()
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
Date: Thu, 29 Mar 2018 19:21:20 +0300
Message-ID: <152234048028.19153.843006403471156320.stgit@localhost.localdomain> (sfid-20180329_182137_508202_06127DE9)
In-Reply-To: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
References: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtnl_lock() doesn't protect net::ct::count,
and it's not needed for__nf_ct_unconfirmed_destroy()
and for nf_queue_nf_hook_drop().

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 net/netfilter/nf_conntrack_core.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 370f9b7f051b..41ff04ee2554 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1763,7 +1763,6 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 {
 	struct net *net;
 
-	rtnl_lock();
 	down_read(&net_rwsem);
 	for_each_net(net) {
 		if (atomic_read(&net->ct.count) == 0)
@@ -1772,7 +1771,6 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 		nf_queue_nf_hook_drop(net);
 	}
 	up_read(&net_rwsem);
-	rtnl_unlock();
 
 	/* Need to wait for netns cleanup worker to finish, if its
 	 * running -- it might have deleted a net namespace from
