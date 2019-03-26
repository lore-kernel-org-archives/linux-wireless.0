Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B5DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 07:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38E8320811
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 07:00:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="im79SnYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbfCZHAh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 03:00:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37194 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730821AbfCZHAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 03:00:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2Q6riH4072829;
        Tue, 26 Mar 2019 07:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=XdkdrGB99z4RaDA8f4VST36qOnk1e2ikwh9sH6I5Cuc=;
 b=im79SnYtVWoCPPBk+Mv/IAtaBuDT56is2VjWkvaf58KE6dy9mUnxBgx/RHshG3DT1XQJ
 DWt2VbM6RgLApBj+KyCMDjZ8xExPl2e/AvPtG/kttWYPToybdC9QDqRZeP8hsddz7eHe
 1wIwuXnqvNJpBt0ltQYiY1uHlnLNnsdUGHWEWbDIktS30z4ngpArCNmUZ3U+PjIobruk
 Pkb1o1N/Qp8qko2P9CNItbQmQn/syUeWoAYRmWVMs8Ee2qOr2PgVjRn6PteYcl0ud8u+
 vu1UVsAczbTAY156dKEsWZK1/qqPT2Q0u4Z/gjtg6m5Z7jaBtcH/AeIQ89IOIPPnsB8X Fw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2re6dj8etr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Mar 2019 07:00:12 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2Q70BdS030013
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Mar 2019 07:00:11 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2Q70Bcl025676;
        Tue, 26 Mar 2019 07:00:11 GMT
Received: from kadam (/197.157.0.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Mar 2019 00:00:10 -0700
Date:   Tue, 26 Mar 2019 10:00:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     kbuild-all@01.org, johannes@sipsolutions.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: Re: [PATCHv3 1/9] nl80211: New netlink command for TID specific
 configuration
Message-ID: <20190326070002.GB32613@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551895251-22941-2-git-send-email-tamizhr@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9206 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903260052
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Tamizh,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Tamizh-chelvam/cfg80211-mac80211-Add-support-for-TID-specific-configuration/20190308-195433
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master

New smatch warnings:
net/wireless/nl80211.c:13336 nl80211_set_tid_config() warn: possible memory leak of 'tid_conf'

Old smatch warnings:
net/wireless/nl80211.c:13339 nl80211_set_tid_config() warn: possible memory leak of 'tid_conf'

# https://github.com/0day-ci/linux/commit/e462f4e99ba46deede4c2e78bd343211d372246d
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout e462f4e99ba46deede4c2e78bd343211d372246d
vim +/tid_conf +13336 net/wireless/nl80211.c

e462f4e9 Tamizh chelvam 2019-03-06  13293  
e462f4e9 Tamizh chelvam 2019-03-06  13294  static int nl80211_set_tid_config(struct sk_buff *skb,
e462f4e9 Tamizh chelvam 2019-03-06  13295  				  struct genl_info *info)
e462f4e9 Tamizh chelvam 2019-03-06  13296  {
e462f4e9 Tamizh chelvam 2019-03-06  13297  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
e462f4e9 Tamizh chelvam 2019-03-06  13298  	struct nlattr *attrs[NL80211_ATTR_TID_CONFIG_MAX + 1];
e462f4e9 Tamizh chelvam 2019-03-06  13299  	struct net_device *dev = info->user_ptr[1];
e462f4e9 Tamizh chelvam 2019-03-06  13300  	struct ieee80211_tid_config *tid_conf;
e462f4e9 Tamizh chelvam 2019-03-06  13301  	struct nlattr *tid;
e462f4e9 Tamizh chelvam 2019-03-06  13302  	int conf_idx = 0, rem_conf;
e462f4e9 Tamizh chelvam 2019-03-06  13303  	u32 num_conf = 0, size_of_conf;
e462f4e9 Tamizh chelvam 2019-03-06  13304  	int ret = -EINVAL;
e462f4e9 Tamizh chelvam 2019-03-06  13305  
e462f4e9 Tamizh chelvam 2019-03-06  13306  	if (!info->attrs[NL80211_ATTR_TID_CONFIG])
e462f4e9 Tamizh chelvam 2019-03-06  13307  		return -EINVAL;
e462f4e9 Tamizh chelvam 2019-03-06  13308  
e462f4e9 Tamizh chelvam 2019-03-06  13309  	if (!rdev->ops->set_tid_config)
e462f4e9 Tamizh chelvam 2019-03-06  13310  		return -EOPNOTSUPP;
e462f4e9 Tamizh chelvam 2019-03-06  13311  
e462f4e9 Tamizh chelvam 2019-03-06  13312  	nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
e462f4e9 Tamizh chelvam 2019-03-06  13313  			    rem_conf)
e462f4e9 Tamizh chelvam 2019-03-06  13314  		num_conf++;
e462f4e9 Tamizh chelvam 2019-03-06  13315  
e462f4e9 Tamizh chelvam 2019-03-06  13316  	size_of_conf = sizeof(struct ieee80211_tid_config) +
e462f4e9 Tamizh chelvam 2019-03-06  13317  		num_conf * sizeof(struct ieee80211_tid_cfg);
e462f4e9 Tamizh chelvam 2019-03-06  13318  
e462f4e9 Tamizh chelvam 2019-03-06  13319  	tid_conf = kzalloc(size_of_conf, GFP_KERNEL);
e462f4e9 Tamizh chelvam 2019-03-06  13320  	if (!tid_conf)
e462f4e9 Tamizh chelvam 2019-03-06  13321  		return -ENOMEM;
e462f4e9 Tamizh chelvam 2019-03-06  13322  
e462f4e9 Tamizh chelvam 2019-03-06  13323  	tid_conf->n_tid_conf = num_conf;
e462f4e9 Tamizh chelvam 2019-03-06  13324  
e462f4e9 Tamizh chelvam 2019-03-06  13325  	if (info->attrs[NL80211_ATTR_MAC])
e462f4e9 Tamizh chelvam 2019-03-06  13326  		tid_conf->peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
e462f4e9 Tamizh chelvam 2019-03-06  13327  	else
e462f4e9 Tamizh chelvam 2019-03-06  13328  		tid_conf->peer = NULL;
e462f4e9 Tamizh chelvam 2019-03-06  13329  
e462f4e9 Tamizh chelvam 2019-03-06  13330  	nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
e462f4e9 Tamizh chelvam 2019-03-06  13331  			    rem_conf) {
e462f4e9 Tamizh chelvam 2019-03-06  13332  		ret = nla_parse_nested(attrs, NL80211_ATTR_TID_CONFIG_MAX, tid,
e462f4e9 Tamizh chelvam 2019-03-06  13333  				       NULL, NULL);
e462f4e9 Tamizh chelvam 2019-03-06  13334  
e462f4e9 Tamizh chelvam 2019-03-06  13335  		if (ret)
e462f4e9 Tamizh chelvam 2019-03-06 @13336  			return ret;
e462f4e9 Tamizh chelvam 2019-03-06  13337  
e462f4e9 Tamizh chelvam 2019-03-06  13338  		if (!attrs[NL80211_ATTR_TID_CONFIG_TID])
e462f4e9 Tamizh chelvam 2019-03-06  13339  			return -EINVAL;
e462f4e9 Tamizh chelvam 2019-03-06  13340  
e462f4e9 Tamizh chelvam 2019-03-06  13341  		ret = parse_tid_conf(rdev, attrs, &tid_conf->tid_conf[conf_idx],
e462f4e9 Tamizh chelvam 2019-03-06  13342  				     tid_conf->peer);
e462f4e9 Tamizh chelvam 2019-03-06  13343  		if (ret)
e462f4e9 Tamizh chelvam 2019-03-06  13344  			goto bad_tid_conf;
e462f4e9 Tamizh chelvam 2019-03-06  13345  
e462f4e9 Tamizh chelvam 2019-03-06  13346  		conf_idx++;
e462f4e9 Tamizh chelvam 2019-03-06  13347  	}
e462f4e9 Tamizh chelvam 2019-03-06  13348  
e462f4e9 Tamizh chelvam 2019-03-06  13349  	ret = rdev_set_tid_config(rdev, dev, tid_conf);
e462f4e9 Tamizh chelvam 2019-03-06  13350  
e462f4e9 Tamizh chelvam 2019-03-06  13351  bad_tid_conf:
e462f4e9 Tamizh chelvam 2019-03-06  13352  	kfree(tid_conf);
e462f4e9 Tamizh chelvam 2019-03-06  13353  	return ret;
e462f4e9 Tamizh chelvam 2019-03-06  13354  }
e462f4e9 Tamizh chelvam 2019-03-06  13355  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
