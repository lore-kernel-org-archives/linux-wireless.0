Return-Path: <SRS0=o7U+=Q6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E1EC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 04:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E717206B6
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 04:28:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3NOEs9CJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfBWE2J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 23:28:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41842 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfBWE2J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 23:28:09 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1N4JH0i067673;
        Sat, 23 Feb 2019 04:27:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=gHN41F6u1UPPFZbZ6PXPAOfaeKRWnj17oEPR/MExtDc=;
 b=3NOEs9CJnV16NOfwIh6aolfu+E73aJeNVPT3O8xkSadl58UEsuMT6x7PSVYeHw1N3TTl
 LmSRdNLrhi6PjNM5gfX8PDZ0rwbNimkDdccfyiwY0qhkMuPlMdpRMmkJRko4gsE2JnO7
 7kbD2eOZIsdKTYdPnviK3+sB9CZk9WzfeScbkLhrLc5tDp1wwIKZ78ttTJ7+kd+6wYBG
 UuQLKDjkrmlzsG9uCNusiMESqDIxNv9P4hXjN+hNVFBZsBeWe1DzDJCVEw82xJ0uXbu9
 D7/sGljBStWNIs8bxw0dXU8KpKwt2kbgnuGi6mCL1QGgLRqnoNzceE1w9hy5KXDDwRaI 5g== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qtwktr4h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Feb 2019 04:27:57 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1N4RuX4023818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Feb 2019 04:27:56 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1N4RtXf017636;
        Sat, 23 Feb 2019 04:27:56 GMT
Received: from kadam (/41.202.241.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 20:27:55 -0800
Date:   Sat, 23 Feb 2019 07:27:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [mac80211-next:master 25/27] net/ipv6/ila/ila_xlat.c:420
 ila_xlat_nl_cmd_flush() error: uninitialized symbol 'ret'.
Message-ID: <20190223042747.GK1711@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9175 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=952 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902230028
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
head:   db0342b20f32f584aedff27c9c09e0a4bbe5beff
commit: 6c4128f658571b2dc7e01058ad09a8e947bc0159 [25/27] rhashtable: Remove obsolete rhashtable_walk_init function

smatch warnings:
net/ipv6/ila/ila_xlat.c:420 ila_xlat_nl_cmd_flush() error: uninitialized symbol 'ret'.

# https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/commit/?id=6c4128f658571b2dc7e01058ad09a8e947bc0159
git remote add mac80211-next https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
git remote update mac80211-next
git checkout 6c4128f658571b2dc7e01058ad09a8e947bc0159
vim +/ret +420 net/ipv6/ila/ila_xlat.c

b6e71bde Tom Herbert 2018-06-27  378  
b6e71bde Tom Herbert 2018-06-27  379  int ila_xlat_nl_cmd_flush(struct sk_buff *skb, struct genl_info *info)
b6e71bde Tom Herbert 2018-06-27  380  {
b6e71bde Tom Herbert 2018-06-27  381  	struct net *net = genl_info_net(info);
b6e71bde Tom Herbert 2018-06-27  382  	struct ila_net *ilan = net_generic(net, ila_net_id);
b6e71bde Tom Herbert 2018-06-27  383  	struct rhashtable_iter iter;
b6e71bde Tom Herbert 2018-06-27  384  	struct ila_map *ila;
b6e71bde Tom Herbert 2018-06-27  385  	spinlock_t *lock;
b6e71bde Tom Herbert 2018-06-27  386  	int ret;
b6e71bde Tom Herbert 2018-06-27  387  
6c4128f6 Herbert Xu  2019-02-14  388  	rhashtable_walk_enter(&ilan->xlat.rhash_table, &iter);
b6e71bde Tom Herbert 2018-06-27  389  	rhashtable_walk_start(&iter);
b6e71bde Tom Herbert 2018-06-27  390  
b6e71bde Tom Herbert 2018-06-27  391  	for (;;) {
b6e71bde Tom Herbert 2018-06-27  392  		ila = rhashtable_walk_next(&iter);
b6e71bde Tom Herbert 2018-06-27  393  
b6e71bde Tom Herbert 2018-06-27  394  		if (IS_ERR(ila)) {
b6e71bde Tom Herbert 2018-06-27  395  			if (PTR_ERR(ila) == -EAGAIN)
b6e71bde Tom Herbert 2018-06-27  396  				continue;
b6e71bde Tom Herbert 2018-06-27  397  			ret = PTR_ERR(ila);
b6e71bde Tom Herbert 2018-06-27  398  			goto done;
b6e71bde Tom Herbert 2018-06-27  399  		} else if (!ila) {
b6e71bde Tom Herbert 2018-06-27  400  			break;

Set "ret" on this error path?

b6e71bde Tom Herbert 2018-06-27  401  		}
b6e71bde Tom Herbert 2018-06-27  402  
b6e71bde Tom Herbert 2018-06-27  403  		lock = lock_from_ila_map(ilan, ila);
b6e71bde Tom Herbert 2018-06-27  404  
b6e71bde Tom Herbert 2018-06-27  405  		spin_lock(lock);
b6e71bde Tom Herbert 2018-06-27  406  
b6e71bde Tom Herbert 2018-06-27  407  		ret = rhashtable_remove_fast(&ilan->xlat.rhash_table,
b6e71bde Tom Herbert 2018-06-27  408  					     &ila->node, rht_params);
b6e71bde Tom Herbert 2018-06-27  409  		if (!ret)
b6e71bde Tom Herbert 2018-06-27  410  			ila_free_node(ila);
b6e71bde Tom Herbert 2018-06-27  411  
b6e71bde Tom Herbert 2018-06-27  412  		spin_unlock(lock);
b6e71bde Tom Herbert 2018-06-27  413  
b6e71bde Tom Herbert 2018-06-27  414  		if (ret)
b6e71bde Tom Herbert 2018-06-27  415  			break;
b6e71bde Tom Herbert 2018-06-27  416  	}
b6e71bde Tom Herbert 2018-06-27  417  
b6e71bde Tom Herbert 2018-06-27  418  done:
b6e71bde Tom Herbert 2018-06-27  419  	rhashtable_walk_stop(&iter);
b6e71bde Tom Herbert 2018-06-27 @420  	return ret;
b6e71bde Tom Herbert 2018-06-27  421  }
b6e71bde Tom Herbert 2018-06-27  422  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
