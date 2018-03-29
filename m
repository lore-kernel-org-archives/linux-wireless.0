Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:46806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbeC2RsY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 13:48:24 -0400
Date: Thu, 29 Mar 2018 13:48:14 -0400 (EDT)
Message-Id: <20180329.134814.2157489714350229877.davem@davemloft.net> (sfid-20180329_194835_720673_4A316D2D)
To: ktkhai@virtuozzo.com
Cc: dledford@redhat.com, jgg@ziepe.ca, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, pshelar@ovn.org,
        johannes@sipsolutions.net, paul@paul-moore.com, sds@tycho.nsa.gov,
        eparis@parisplace.org, jmorris@namei.org, serge@hallyn.com,
        leon@kernel.org, yuval.shaia@oracle.com, parav@mellanox.com,
        danielj@mellanox.com, majd@mellanox.com, nicolas.dichtel@6wind.com,
        vyasevic@redhat.com, paulmck@linux.vnet.ibm.com,
        vyasevich@gmail.com, gregkh@linuxfoundation.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com, ast@kernel.org,
        brouer@redhat.com, linux@rasmusvillemoes.dk,
        john.fastabend@gmail.com, dsahern@gmail.com, jiri@mellanox.com,
        idosch@mellanox.com, vvs@virtuozzo.com, avagin@virtuozzo.com,
        roman.kapl@sysgo.com, lucien.xin@gmail.com,
        christian.brauner@ubuntu.com, jbenc@redhat.com,
        pombredanne@nexb.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, dev@openvswitch.org,
        linux-wireless@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] Introduce net_rwsem to protect
 net_namespace_list
From: David Miller <davem@davemloft.net>
In-Reply-To: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
References: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kirill Tkhai <ktkhai@virtuozzo.com>
Date: Thu, 29 Mar 2018 19:20:23 +0300

> The series introduces fine grained rw_semaphore, which will be used
> instead of rtnl_lock() to protect net_namespace_list.
> 
> This improves scalability and allows to do non-exclusive sleepable
> iteration for_each_net(), which is enough for most cases.
> 
> scripts/get_maintainer.pl gives enormous list of people, and I add
> all to CC.
> 
> Note, that this patch is independent of "Close race between
> {un, }register_netdevice_notifier and pernet_operations":
> https://patchwork.ozlabs.org/project/netdev/list/?series=36495
> 
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>

Great stuff!

Series applied, thanks!
