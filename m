Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0134.outbound.protection.outlook.com ([104.47.2.134]:38336
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751714AbeC2QVU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 12:21:20 -0400
Subject: [PATCH net-next 4/5] ovs: Remove rtnl_lock() from ovs_exit_net()
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
Date: Thu, 29 Mar 2018 19:21:09 +0300
Message-ID: <152234046913.19153.5014546114733288472.stgit@localhost.localdomain> (sfid-20180329_182147_248183_D0589E86)
In-Reply-To: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
References: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here we iterate for_each_net() and removes
vport from alive net to the exiting net.

ovs_net::dps are protected by ovs_mutex(),
and the others, who change it (ovs_dp_cmd_new(),
__dp_destroy()) also take it.
The same with datapath::ports list.

So, we remove rtnl_lock() here.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 net/openvswitch/datapath.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9746ee30a99b..015e24e08909 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2363,12 +2363,10 @@ static void __net_exit ovs_exit_net(struct net *dnet)
 	list_for_each_entry_safe(dp, dp_next, &ovs_net->dps, list_node)
 		__dp_destroy(dp);
 
-	rtnl_lock();
 	down_read(&net_rwsem);
 	for_each_net(net)
 		list_vports_from_net(net, dnet, &head);
 	up_read(&net_rwsem);
-	rtnl_unlock();
 
 	/* Detach all vports from given namespace. */
 	list_for_each_entry_safe(vport, vport_next, &head, detach_list) {
