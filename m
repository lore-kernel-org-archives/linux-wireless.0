Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF1DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 09:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 624AB20828
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 09:06:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pYPn5u9r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfCSJGb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 05:06:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44310 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfCSJGa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 05:06:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J8wx3V141870;
        Tue, 19 Mar 2019 09:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=DxV7nHfeZjtowak0Cai/84fQLSEI0P63yrUZE54Z0gQ=;
 b=pYPn5u9rSaKnIMg9Gdi+gbAZO/X0DVKoLejVtuqJTdp4oYjyWKWZiKIiRuD+hmPt90hq
 tO0FdybHT+dWqt9EsnkM6g8yqeuyX98YAct/1yVVTHvXr2GpYCMe6jbl0MTq7LttpFGw
 Bls6XamLV2Kh2nVjxOJ091UoEn4H70ziHarVEICr9cz6v+psmqs3W7eAgzPlzQAtiQP2
 HJEk5UDD3gCZkOPNMWZE+9kqDG54lKGLM5TBkVVtXq8/a9+y2yHIj93mSm0t1DWozlog
 Om2OuelvHd+kyMg2vgqmnNTNPO+HS1avzWJLXJqWY5jdtn4mziVm0erGKdutKkjgCui+ ag== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2r8ssrb8d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Mar 2019 09:06:22 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2J96MY0003225
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Mar 2019 09:06:22 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2J96LSH006782;
        Tue, 19 Mar 2019 09:06:22 GMT
Received: from kadam (/197.157.0.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 02:06:21 -0700
Date:   Tue, 19 Mar 2019 12:06:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Luca Coelho <luca@coelho.fi>
Cc:     kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 09/11] cfg80211: support profile split between elements
Message-ID: <20190319090603.GM2227@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315153907.16192-10-luca@coelho.fi>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190069
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Luca,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Luca-Coelho/mac80211-Increase-MAX_MSG_LEN/20190316-083719
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master

smatch warnings:
net/wireless/scan.c:1610 cfg80211_parse_mbssid_data() warn: should '1 << (mbssid_index_ie[2])' be a 64 bit type?

# https://github.com/0day-ci/linux/commit/e28e850d09f80732c1e9c04e0079c4e40f23ef7d
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout e28e850d09f80732c1e9c04e0079c4e40f23ef7d
vim +1610 net/wireless/scan.c

e28e850d Sara Sharon   2019-03-15  1530  
0b8fb823 Peng Xu       2019-01-21  1531  static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
0b8fb823 Peng Xu       2019-01-21  1532  				       struct cfg80211_inform_bss *data,
0b8fb823 Peng Xu       2019-01-21  1533  				       enum cfg80211_bss_frame_type ftype,
0b8fb823 Peng Xu       2019-01-21  1534  				       const u8 *bssid, u64 tsf,
0b8fb823 Peng Xu       2019-01-21  1535  				       u16 beacon_interval, const u8 *ie,
0b8fb823 Peng Xu       2019-01-21  1536  				       size_t ielen,
0cd01efb Sara Sharon   2019-01-22  1537  				       struct cfg80211_non_tx_bss *non_tx_data,
0b8fb823 Peng Xu       2019-01-21  1538  				       gfp_t gfp)
0b8fb823 Peng Xu       2019-01-21  1539  {
1c8745f3 Johannes Berg 2019-02-07  1540  	const u8 *mbssid_index_ie;
1c8745f3 Johannes Berg 2019-02-07  1541  	const struct element *elem, *sub;
1c8745f3 Johannes Berg 2019-02-07  1542  	size_t new_ie_len;
0b8fb823 Peng Xu       2019-01-21  1543  	u8 new_bssid[ETH_ALEN];
e28e850d Sara Sharon   2019-03-15  1544  	u8 *new_ie, *profile;
e28e850d Sara Sharon   2019-03-15  1545  	u64 seen_indices = 0;
0b8fb823 Peng Xu       2019-01-21  1546  	u16 capability;
0b8fb823 Peng Xu       2019-01-21  1547  	struct cfg80211_bss *bss;
0b8fb823 Peng Xu       2019-01-21  1548  
0cd01efb Sara Sharon   2019-01-22  1549  	if (!non_tx_data)
0b8fb823 Peng Xu       2019-01-21  1550  		return;
0b8fb823 Peng Xu       2019-01-21  1551  	if (!cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
0b8fb823 Peng Xu       2019-01-21  1552  		return;
213ed579 Sara Sharon   2019-01-16  1553  	if (!wiphy->support_mbssid)
213ed579 Sara Sharon   2019-01-16  1554  		return;
213ed579 Sara Sharon   2019-01-16  1555  	if (wiphy->support_only_he_mbssid &&
213ed579 Sara Sharon   2019-01-16  1556  	    !cfg80211_find_ext_ie(WLAN_EID_EXT_HE_CAPABILITY, ie, ielen))
213ed579 Sara Sharon   2019-01-16  1557  		return;
0b8fb823 Peng Xu       2019-01-21  1558  
0b8fb823 Peng Xu       2019-01-21  1559  	new_ie = kmalloc(IEEE80211_MAX_DATA_LEN, gfp);
0b8fb823 Peng Xu       2019-01-21  1560  	if (!new_ie)
0b8fb823 Peng Xu       2019-01-21  1561  		return;
0b8fb823 Peng Xu       2019-01-21  1562  
e28e850d Sara Sharon   2019-03-15  1563  	profile = kmalloc(ielen, gfp);
e28e850d Sara Sharon   2019-03-15  1564  	if (!profile)
e28e850d Sara Sharon   2019-03-15  1565  		goto out;
e28e850d Sara Sharon   2019-03-15  1566  
1c8745f3 Johannes Berg 2019-02-07  1567  	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, ie, ielen) {
1c8745f3 Johannes Berg 2019-02-07  1568  		if (elem->datalen < 4)
1c8745f3 Johannes Berg 2019-02-07  1569  			continue;
1c8745f3 Johannes Berg 2019-02-07  1570  		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
e28e850d Sara Sharon   2019-03-15  1571  			u8 profile_len;
e28e850d Sara Sharon   2019-03-15  1572  
1c8745f3 Johannes Berg 2019-02-07  1573  			if (sub->id != 0 || sub->datalen < 4) {
0b8fb823 Peng Xu       2019-01-21  1574  				/* not a valid BSS profile */
0b8fb823 Peng Xu       2019-01-21  1575  				continue;
0b8fb823 Peng Xu       2019-01-21  1576  			}
0b8fb823 Peng Xu       2019-01-21  1577  
1c8745f3 Johannes Berg 2019-02-07  1578  			if (sub->data[0] != WLAN_EID_NON_TX_BSSID_CAP ||
1c8745f3 Johannes Berg 2019-02-07  1579  			    sub->data[1] != 2) {
0b8fb823 Peng Xu       2019-01-21  1580  				/* The first element within the Nontransmitted
0b8fb823 Peng Xu       2019-01-21  1581  				 * BSSID Profile is not the Nontransmitted
0b8fb823 Peng Xu       2019-01-21  1582  				 * BSSID Capability element.
0b8fb823 Peng Xu       2019-01-21  1583  				 */
0b8fb823 Peng Xu       2019-01-21  1584  				continue;
0b8fb823 Peng Xu       2019-01-21  1585  			}
0b8fb823 Peng Xu       2019-01-21  1586  
e28e850d Sara Sharon   2019-03-15  1587  			memset(profile, 0, ielen);
e28e850d Sara Sharon   2019-03-15  1588  			profile_len = cfg80211_merge_profile(ie, ielen,
e28e850d Sara Sharon   2019-03-15  1589  							     elem,
e28e850d Sara Sharon   2019-03-15  1590  							     sub,
e28e850d Sara Sharon   2019-03-15  1591  							     &profile,
e28e850d Sara Sharon   2019-03-15  1592  							     ielen);
e28e850d Sara Sharon   2019-03-15  1593  
0b8fb823 Peng Xu       2019-01-21  1594  			/* found a Nontransmitted BSSID Profile */
0b8fb823 Peng Xu       2019-01-21  1595  			mbssid_index_ie = cfg80211_find_ie
0b8fb823 Peng Xu       2019-01-21  1596  				(WLAN_EID_MULTI_BSSID_IDX,
e28e850d Sara Sharon   2019-03-15  1597  				 profile, profile_len);
0b8fb823 Peng Xu       2019-01-21  1598  			if (!mbssid_index_ie || mbssid_index_ie[1] < 1 ||
e28e850d Sara Sharon   2019-03-15  1599  			    mbssid_index_ie[2] == 0 ||
e28e850d Sara Sharon   2019-03-15  1600  			    mbssid_index_ie[2] > 46) {
0b8fb823 Peng Xu       2019-01-21  1601  				/* No valid Multiple BSSID-Index element */
0b8fb823 Peng Xu       2019-01-21  1602  				continue;
0b8fb823 Peng Xu       2019-01-21  1603  			}
0b8fb823 Peng Xu       2019-01-21  1604  
e28e850d Sara Sharon   2019-03-15  1605  			if (seen_indices & BIT(mbssid_index_ie[2]))
                                                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
I should fix Smatch to generate a warning here as well...

e28e850d Sara Sharon   2019-03-15  1606  				/* We don't support legacy split of a profile */
e28e850d Sara Sharon   2019-03-15  1607  				net_dbg_ratelimited("Partial info for BSSID index %d\n",
e28e850d Sara Sharon   2019-03-15  1608  						    mbssid_index_ie[2]);
e28e850d Sara Sharon   2019-03-15  1609  
e28e850d Sara Sharon   2019-03-15 @1610  			seen_indices |= BIT(mbssid_index_ie[2]);
                                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

e28e850d Sara Sharon   2019-03-15  1611  
0cd01efb Sara Sharon   2019-01-22  1612  			non_tx_data->bssid_index = mbssid_index_ie[2];
0cd01efb Sara Sharon   2019-01-22  1613  			non_tx_data->max_bssid_indicator = elem->data[0];
0cd01efb Sara Sharon   2019-01-22  1614  
0cd01efb Sara Sharon   2019-01-22  1615  			cfg80211_gen_new_bssid(bssid,
0cd01efb Sara Sharon   2019-01-22  1616  					       non_tx_data->max_bssid_indicator,
0cd01efb Sara Sharon   2019-01-22  1617  					       non_tx_data->bssid_index,
0b8fb823 Peng Xu       2019-01-21  1618  					       new_bssid);
0b8fb823 Peng Xu       2019-01-21  1619  			memset(new_ie, 0, IEEE80211_MAX_DATA_LEN);
e28e850d Sara Sharon   2019-03-15  1620  			new_ie_len = cfg80211_gen_new_ie(ie, ielen,
e28e850d Sara Sharon   2019-03-15  1621  							 profile,
e28e850d Sara Sharon   2019-03-15  1622  							 profile_len, new_ie,
0b8fb823 Peng Xu       2019-01-21  1623  							 gfp);
0b8fb823 Peng Xu       2019-01-21  1624  			if (!new_ie_len)
0b8fb823 Peng Xu       2019-01-21  1625  				continue;
0b8fb823 Peng Xu       2019-01-21  1626  
e28e850d Sara Sharon   2019-03-15  1627  			capability = get_unaligned_le16(profile + 2);
0b8fb823 Peng Xu       2019-01-21  1628  			bss = cfg80211_inform_single_bss_data(wiphy, data,
0b8fb823 Peng Xu       2019-01-21  1629  							      ftype,
0b8fb823 Peng Xu       2019-01-21  1630  							      new_bssid, tsf,
0b8fb823 Peng Xu       2019-01-21  1631  							      capability,
0b8fb823 Peng Xu       2019-01-21  1632  							      beacon_interval,
0b8fb823 Peng Xu       2019-01-21  1633  							      new_ie,
0b8fb823 Peng Xu       2019-01-21  1634  							      new_ie_len,
0cd01efb Sara Sharon   2019-01-22  1635  							      non_tx_data,
0cd01efb Sara Sharon   2019-01-22  1636  							      gfp);
0b8fb823 Peng Xu       2019-01-21  1637  			if (!bss)
0b8fb823 Peng Xu       2019-01-21  1638  				break;
0b8fb823 Peng Xu       2019-01-21  1639  			cfg80211_put_bss(wiphy, bss);
0b8fb823 Peng Xu       2019-01-21  1640  		}
0b8fb823 Peng Xu       2019-01-21  1641  	}
0b8fb823 Peng Xu       2019-01-21  1642  
e28e850d Sara Sharon   2019-03-15  1643  out:
0b8fb823 Peng Xu       2019-01-21  1644  	kfree(new_ie);
e28e850d Sara Sharon   2019-03-15  1645  	kfree(profile);
0b8fb823 Peng Xu       2019-01-21  1646  }
0b8fb823 Peng Xu       2019-01-21  1647  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
