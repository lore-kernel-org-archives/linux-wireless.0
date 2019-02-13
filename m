Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B725C282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 12:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24E26222C1
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 12:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbfBMMu0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 07:50:26 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21384
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731246AbfBMMu0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 07:50:26 -0500
X-IronPort-AV: E=Sophos;i="5.58,365,1544482800"; 
   d="scan'208";a="296059003"
Received: from vaio-julia.rsr.lip6.fr ([132.227.76.33])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2019 13:50:22 +0100
Date:   Wed, 13 Feb 2019 13:50:20 +0100 (CET)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com, kbuild-all@01.org
Subject: Re: [PATCH 2/2] mac80211: Free mpath object when rhashtable insertion
 fails (fwd)
Message-ID: <alpine.DEB.2.20.1902131349440.3561@hadrien>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-939106836-1550062220=:3561"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-939106836-1550062220=:3561
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

Perhaps a return is needed after line 436.

julia

---------- Forwarded message ----------
Date: Wed, 13 Feb 2019 20:29:38 +0800
From: kbuild test robot <lkp@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 2/2] mac80211: Free mpath object when rhashtable insertion
    fails

CC: kbuild-all@01.org
In-Reply-To: <E1gtmu6-0001Vl-O7@gondobar>
References: <E1gtmu6-0001Vl-O7@gondobar>
TO: Herbert Xu <herbert@gondor.apana.org.au>
CC: David Miller <davem@davemloft.net>, johannes@sipsolutions.net, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi, tgraf@suug.ch, johannes.berg@intel.com
CC:

Hi Herbert,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on v5.0-rc4 next-20190212]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Herbert-Xu/mac80211-Fix-incorrect-usage-of-rhashtable-walk-API/20190213-181325
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
:::::: branch date: 2 hours ago
:::::: commit date: 2 hours ago

>> net/mac80211/mesh_pathtbl.c:448:8-17: ERROR: reference preceded by free on line 436

# https://github.com/0day-ci/linux/commit/a0886e834aacf883ceaf0c34c842c4cdb4d318fd
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout a0886e834aacf883ceaf0c34c842c4cdb4d318fd
vim +448 net/mac80211/mesh_pathtbl.c

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
a0886e834 Herbert Xu           2019-02-13 @436  		kfree(new_mpath);
a0886e834 Herbert Xu           2019-02-13  437
a0886e834 Herbert Xu           2019-02-13  438  	if (ret != -EEXIST)
60854fd94 Bob Copeland         2016-03-02  439  		return ERR_PTR(ret);
ae76eef02 Bob Copeland         2013-03-29  440
60854fd94 Bob Copeland         2016-03-02  441  	/* At this point either new_mpath was added, or we found a
60854fd94 Bob Copeland         2016-03-02  442  	 * matching entry already in the table; in the latter case
60854fd94 Bob Copeland         2016-03-02  443  	 * free the unnecessary new entry.
60854fd94 Bob Copeland         2016-03-02  444  	 */
a0886e834 Herbert Xu           2019-02-13  445  	if (ret == -EEXIST)
60854fd94 Bob Copeland         2016-03-02  446  		new_mpath = mpath;
60854fd94 Bob Copeland         2016-03-02  447  	sdata->u.mesh.mesh_paths_generation++;
60854fd94 Bob Copeland         2016-03-02 @448  	return new_mpath;
18889231e Javier Cardona       2009-08-10  449  }
eb2b9311f Luis Carlos Cobo     2008-02-23  450

:::::: The code at line 448 was first introduced by commit
:::::: 60854fd94573f0d3b80b55b40cf0140a0430f3ab mac80211: mesh: convert path table to rhashtable

:::::: TO: Bob Copeland <me@bobcopeland.com>
:::::: CC: Johannes Berg <johannes.berg@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--8323329-939106836-1550062220=:3561--
