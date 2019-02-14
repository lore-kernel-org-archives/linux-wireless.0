Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AB5C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 05:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB5A6222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 05:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d6Gcg66V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393973AbfBNFw7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 00:52:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42090 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405440AbfBNFwb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 00:52:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1E5iYmA136369;
        Thu, 14 Feb 2019 05:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=D3sp8ZzIKh6xhDYYKYULzPYhAK5nbzyMUSPFow6gmBs=;
 b=d6Gcg66V3XdNxJADqxjOMSvmc0NkPICT63wmbTAjOOAX0IpuiScyi9YjeE5e5x6SC+AA
 k7aLzuHMdmqlsfrddmJ/E1Upxv9M+jwir+39dewIGxE8XPuro6piXsbU+TDnyadz0nn4
 wUlX0jK3e78tERswHXusRI+ixBW8Hgy8eaUOkz1p+HJ217Irc4VcTqMOcxIF6jcERJp+
 k8PGy2H0M+DUICdFDdsqbBUIJ0ko+399Tv9hcUEM5ZtJV1l2Tb0FOvASh30G9xtJztI6
 nT42u/spRtoTF7GCiv5I44B97Vo2Cx8B7hqop6g5Up5div0z/KGWl/JMYLNoci3gcJ+3 aA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qhree604n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Feb 2019 05:52:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1E5qCTA031304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Feb 2019 05:52:12 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1E5q92p010010;
        Thu, 14 Feb 2019 05:52:10 GMT
Received: from kadam (/41.202.241.28)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Feb 2019 05:52:09 +0000
Date:   Thu, 14 Feb 2019 08:52:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kbuild-all@01.org, David Miller <davem@davemloft.net>,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, j@w1.fi, tgraf@suug.ch,
        johannes.berg@intel.com
Subject: Re: [PATCH 2/2] mac80211: Free mpath object when rhashtable
 insertion fails
Message-ID: <20190214055159.GA2304@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1gtmu6-0001Vl-O7@gondobar>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9166 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902140043
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Herbert,

url:    https://github.com/0day-ci/linux/commits/Herbert-Xu/mac80211-Fix-incorrect-usage-of-rhashtable-walk-API/20190213-181325
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master

smatch warnings:
net/mac80211/mesh_pathtbl.c:439 mesh_path_add() warn: passing zero to 'ERR_PTR'

# https://github.com/0day-ci/linux/commit/a0886e834aacf883ceaf0c34c842c4cdb4d318fd
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout a0886e834aacf883ceaf0c34c842c4cdb4d318fd
vim +/ERR_PTR +439 net/mac80211/mesh_pathtbl.c

b15dc38b9 Bob Copeland         2016-02-28  390  
eb2b9311f Luis Carlos Cobo     2008-02-23  391  /**
eb2b9311f Luis Carlos Cobo     2008-02-23  392   * mesh_path_add - allocate and add a new path to the mesh path table
bf7cd94dc Johannes Berg        2013-02-15  393   * @dst: destination address of the path (ETH_ALEN length)
f698d856f Jasper Bryant-Greene 2008-08-03  394   * @sdata: local subif
eb2b9311f Luis Carlos Cobo     2008-02-23  395   *
af901ca18 André Goddard Rosa   2009-11-14  396   * Returns: 0 on success
eb2b9311f Luis Carlos Cobo     2008-02-23  397   *
eb2b9311f Luis Carlos Cobo     2008-02-23  398   * State: the initial state of the new path is set to 0
eb2b9311f Luis Carlos Cobo     2008-02-23  399   */
ae76eef02 Bob Copeland         2013-03-29  400  struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
ae76eef02 Bob Copeland         2013-03-29  401  				const u8 *dst)
eb2b9311f Luis Carlos Cobo     2008-02-23  402  {
349eb8cf4 Johannes Berg        2011-05-14  403  	struct mesh_table *tbl;
eb2b9311f Luis Carlos Cobo     2008-02-23  404  	struct mesh_path *mpath, *new_mpath;
60854fd94 Bob Copeland         2016-03-02  405  	int ret;
eb2b9311f Luis Carlos Cobo     2008-02-23  406  
b203ca391 Joe Perches          2012-05-08  407  	if (ether_addr_equal(dst, sdata->vif.addr))
eb2b9311f Luis Carlos Cobo     2008-02-23  408  		/* never add ourselves as neighbours */
ae76eef02 Bob Copeland         2013-03-29  409  		return ERR_PTR(-ENOTSUPP);
eb2b9311f Luis Carlos Cobo     2008-02-23  410  
eb2b9311f Luis Carlos Cobo     2008-02-23  411  	if (is_multicast_ether_addr(dst))
ae76eef02 Bob Copeland         2013-03-29  412  		return ERR_PTR(-ENOTSUPP);
eb2b9311f Luis Carlos Cobo     2008-02-23  413  
472dbc45d Johannes Berg        2008-09-11  414  	if (atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS) == 0)
ae76eef02 Bob Copeland         2013-03-29  415  		return ERR_PTR(-ENOSPC);
ae76eef02 Bob Copeland         2013-03-29  416  
b15dc38b9 Bob Copeland         2016-02-28  417  	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
402d7752e Pavel Emelyanov      2008-05-06  418  	if (!new_mpath)
60854fd94 Bob Copeland         2016-03-02  419  		return ERR_PTR(-ENOMEM);
402d7752e Pavel Emelyanov      2008-05-06  420  
60854fd94 Bob Copeland         2016-03-02  421  	tbl = sdata->u.mesh.mesh_paths;
60854fd94 Bob Copeland         2016-03-02  422  	do {
60854fd94 Bob Copeland         2016-03-02  423  		ret = rhashtable_lookup_insert_fast(&tbl->rhead,
60854fd94 Bob Copeland         2016-03-02  424  						    &new_mpath->rhash,
60854fd94 Bob Copeland         2016-03-02  425  						    mesh_rht_params);
f84e71a94 Pavel Emelyanov      2008-05-06  426  
60854fd94 Bob Copeland         2016-03-02  427  		if (ret == -EEXIST)
60854fd94 Bob Copeland         2016-03-02  428  			mpath = rhashtable_lookup_fast(&tbl->rhead,
60854fd94 Bob Copeland         2016-03-02  429  						       dst,
60854fd94 Bob Copeland         2016-03-02  430  						       mesh_rht_params);
05b0152f1 Herbert Xu           2019-02-13  431  		else if (!ret)
05b0152f1 Herbert Xu           2019-02-13  432  			hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
60854fd94 Bob Copeland         2016-03-02  433  	} while (unlikely(ret == -EEXIST && !mpath));
f5ea9120b Johannes Berg        2009-08-07  434  
a0886e834 Herbert Xu           2019-02-13  435  	if (ret)
a0886e834 Herbert Xu           2019-02-13  436  		kfree(new_mpath);
a0886e834 Herbert Xu           2019-02-13  437  
a0886e834 Herbert Xu           2019-02-13  438  	if (ret != -EEXIST)
60854fd94 Bob Copeland         2016-03-02 @439  		return ERR_PTR(ret);

                                                         if (ret && ret != -EEXIST) ?

ae76eef02 Bob Copeland         2013-03-29  440  
60854fd94 Bob Copeland         2016-03-02  441  	/* At this point either new_mpath was added, or we found a
60854fd94 Bob Copeland         2016-03-02  442  	 * matching entry already in the table; in the latter case
60854fd94 Bob Copeland         2016-03-02  443  	 * free the unnecessary new entry.
60854fd94 Bob Copeland         2016-03-02  444  	 */
a0886e834 Herbert Xu           2019-02-13  445  	if (ret == -EEXIST)
60854fd94 Bob Copeland         2016-03-02  446  		new_mpath = mpath;
60854fd94 Bob Copeland         2016-03-02  447  	sdata->u.mesh.mesh_paths_generation++;
60854fd94 Bob Copeland         2016-03-02  448  	return new_mpath;
18889231e Javier Cardona       2009-08-10  449  }
eb2b9311f Luis Carlos Cobo     2008-02-23  450  

:::::: The code at line 439 was first introduced by commit
:::::: 60854fd94573f0d3b80b55b40cf0140a0430f3ab mac80211: mesh: convert path table to rhashtable

:::::: TO: Bob Copeland <me@bobcopeland.com>
:::::: CC: Johannes Berg <johannes.berg@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
