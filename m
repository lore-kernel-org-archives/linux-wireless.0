Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0098.outbound.protection.outlook.com ([104.47.1.98]:28320
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751868AbeC2QUe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 12:20:34 -0400
Subject: [PATCH net-next 0/5] Introduce net_rwsem to protect
 net_namespace_list
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
Date: Thu, 29 Mar 2018 19:20:23 +0300
Message-ID: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain> (sfid-20180329_182051_979035_F1A16526)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The series introduces fine grained rw_semaphore, which will be used
instead of rtnl_lock() to protect net_namespace_list.

This improves scalability and allows to do non-exclusive sleepable
iteration for_each_net(), which is enough for most cases.

scripts/get_maintainer.pl gives enormous list of people, and I add
all to CC.

Note, that this patch is independent of "Close race between
{un, }register_netdevice_notifier and pernet_operations":
https://patchwork.ozlabs.org/project/netdev/list/?series=36495

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---

Kirill Tkhai (5):
      net: Introduce net_rwsem to protect net_namespace_list
      net: Don't take rtnl_lock() in wireless_nlevent_flush()
      security: Remove rtnl_lock() in selinux_xfrm_notify_policyload()
      ovs: Remove rtnl_lock() from ovs_exit_net()
      net: Remove rtnl_lock() in nf_ct_iterate_destroy()


 drivers/infiniband/core/roce_gid_mgmt.c |    2 ++
 include/linux/rtnetlink.h               |    1 +
 include/net/net_namespace.h             |    1 +
 net/core/dev.c                          |    5 +++++
 net/core/fib_notifier.c                 |    2 ++
 net/core/net_namespace.c                |   18 +++++++++++++-----
 net/core/rtnetlink.c                    |    5 +++++
 net/netfilter/nf_conntrack_core.c       |    4 ++--
 net/openvswitch/datapath.c              |    4 ++--
 net/wireless/wext-core.c                |    6 ++----
 security/selinux/include/xfrm.h         |    4 ++--
 11 files changed, 37 insertions(+), 15 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
