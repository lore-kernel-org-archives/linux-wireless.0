Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FE2C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30B64205C9
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:02:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="klv3MKCC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfCKHCc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 03:02:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfCKHCc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 03:02:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2B6wiaj166530;
        Mon, 11 Mar 2019 07:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=VptuTN5sLd9NwA+Fp/r87IFqvEmvK0A169dCruVVr/s=;
 b=klv3MKCCinIzctPPrxB2BlDz8xs2psbeSfYItnSnQiCj6j4TZy7Lyct0ZPO/C/U99Rnf
 hRSIaT/TLquGe1QSQ5WmOW4+tyaiFYc1pExu4ef0pFTIc1I3HsImrlX5sF1vmoMADv1N
 RZN94//pqn6y3yKn8hk9SGxy+VV4N2PMX6HJ2dLi9/IYIXBZatg/ppBSlGqdwrMQkpYj
 /Z0taLXiObjKtDX6XR8yhm1+1BHo4sp3erYR80d2FGrazMa+CEyYG6tjqrL3SnneUJWi
 mD+ovfNwpAV+fstZ92LPEIEmbRqeU9dwQEGb2xvh48xJ3R+k8VwWbqe8n8DI8gX9RP4/ Pw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2r464r4e6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 07:02:21 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2B72FO6004743
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 07:02:16 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2B72Fjf005776;
        Mon, 11 Mar 2019 07:02:15 GMT
Received: from kadam (/197.157.34.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Mar 2019 00:02:14 -0700
Date:   Mon, 11 Mar 2019 10:02:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     kbuild-all@01.org, johannes@sipsolutions.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: Re: [PATCHv3 8/9] ath10k: Add new api to support TID specific
 configuration
Message-ID: <20190311070207.GA2412@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551895251-22941-9-git-send-email-tamizhr@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9191 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903110053
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Tamizh,

url:    https://github.com/0day-ci/linux/commits/Tamizh-chelvam/cfg80211-mac80211-Add-support-for-TID-specific-configuration/20190308-195433
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master

smatch warnings:
drivers/net/wireless/ath/ath10k/mac.c:8438 ath10k_mac_op_set_tid_config() error: uninitialized symbol 'ret'.

# https://github.com/0day-ci/linux/commit/2eab2d81c36efa0cf08b02bfe2df3f83a2e2d756
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 2eab2d81c36efa0cf08b02bfe2df3f83a2e2d756
vim +/ret +8438 drivers/net/wireless/ath/ath10k/mac.c

6a7f8911 Anilkumar Kolli 2017-12-05  8306  
2eab2d81 Tamizh chelvam  2019-03-06  8307  static int ath10k_mac_op_set_tid_config(struct ieee80211_hw *hw,
2eab2d81 Tamizh chelvam  2019-03-06  8308  					struct ieee80211_vif *vif,
2eab2d81 Tamizh chelvam  2019-03-06  8309  					struct ieee80211_sta *sta,
2eab2d81 Tamizh chelvam  2019-03-06  8310  					struct ieee80211_tid_config *tid_config)
2eab2d81 Tamizh chelvam  2019-03-06  8311  {
2eab2d81 Tamizh chelvam  2019-03-06  8312  	struct ath10k *ar = hw->priv;
2eab2d81 Tamizh chelvam  2019-03-06  8313  	struct ath10k_vif *arvif = (void *)vif->drv_priv;
2eab2d81 Tamizh chelvam  2019-03-06  8314  	struct ath10k_mac_iter_tid_conf_data data = {};
2eab2d81 Tamizh chelvam  2019-03-06  8315  	struct wmi_per_peer_per_tid_cfg_arg arg = {};
2eab2d81 Tamizh chelvam  2019-03-06  8316  	int ret, i;
2eab2d81 Tamizh chelvam  2019-03-06  8317  	u8 changed;
2eab2d81 Tamizh chelvam  2019-03-06  8318  
2eab2d81 Tamizh chelvam  2019-03-06  8319  	mutex_lock(&ar->conf_mutex);
2eab2d81 Tamizh chelvam  2019-03-06  8320  	arg.vdev_id = arvif->vdev_id;
2eab2d81 Tamizh chelvam  2019-03-06  8321  
2eab2d81 Tamizh chelvam  2019-03-06  8322  	memset(arvif->tid_conf_changed, 0, sizeof(arvif->tid_conf_changed));
2eab2d81 Tamizh chelvam  2019-03-06  8323  
2eab2d81 Tamizh chelvam  2019-03-06  8324  	for (i = 0; i < tid_config->n_tid_conf; i++) {
2eab2d81 Tamizh chelvam  2019-03-06  8325  		if (tid_config->tid_conf[i].tid >= IEEE80211_TID_MAX)
2eab2d81 Tamizh chelvam  2019-03-06  8326  			continue;
                                                                ^^^^^^^^^
We would have to hit this continue over and over and "sta" would have
to be non-NULL for this to be an issue.

2eab2d81 Tamizh chelvam  2019-03-06  8327  
2eab2d81 Tamizh chelvam  2019-03-06  8328  		ath10k_mac_parse_tid_config(ar, sta, vif,
2eab2d81 Tamizh chelvam  2019-03-06  8329  					    &tid_config->tid_conf[i],
2eab2d81 Tamizh chelvam  2019-03-06  8330  					    &arg);
2eab2d81 Tamizh chelvam  2019-03-06  8331  		changed = tid_config->tid_conf[i].tid_conf_mask;
2eab2d81 Tamizh chelvam  2019-03-06  8332  		if (sta) {
2eab2d81 Tamizh chelvam  2019-03-06  8333  			if (!sta->wme) {
2eab2d81 Tamizh chelvam  2019-03-06  8334  				ret = -ENOTSUPP;
2eab2d81 Tamizh chelvam  2019-03-06  8335  				goto exit;
2eab2d81 Tamizh chelvam  2019-03-06  8336  			}
2eab2d81 Tamizh chelvam  2019-03-06  8337  
2eab2d81 Tamizh chelvam  2019-03-06  8338  			if (changed & IEEE80211_TID_CONF_RETRY) {
2eab2d81 Tamizh chelvam  2019-03-06  8339  				if (sta->noack[arg.tid] == WMI_PEER_TID_CONFIG_NOACK ||
2eab2d81 Tamizh chelvam  2019-03-06  8340  				    vif->noack[arg.tid] == WMI_PEER_TID_CONFIG_NOACK)
2eab2d81 Tamizh chelvam  2019-03-06  8341  					arg.retry_count = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8342  			}
2eab2d81 Tamizh chelvam  2019-03-06  8343  
2eab2d81 Tamizh chelvam  2019-03-06  8344  			if (changed & IEEE80211_TID_CONF_AMPDU) {
2eab2d81 Tamizh chelvam  2019-03-06  8345  				if (sta->noack[arg.tid] == WMI_PEER_TID_CONFIG_NOACK ||
2eab2d81 Tamizh chelvam  2019-03-06  8346  				    vif->noack[arg.tid] == WMI_PEER_TID_CONFIG_NOACK)
2eab2d81 Tamizh chelvam  2019-03-06  8347  					arg.aggr_control = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8348  			}
2eab2d81 Tamizh chelvam  2019-03-06  8349  
2eab2d81 Tamizh chelvam  2019-03-06  8350  			if (changed & IEEE80211_TID_CONF_TX_BITRATE) {
2eab2d81 Tamizh chelvam  2019-03-06  8351  				if (sta->noack[arg.tid] == WMI_PEER_TID_CONFIG_NOACK ||
2eab2d81 Tamizh chelvam  2019-03-06  8352  				    vif->noack[arg.tid] == WMI_PEER_TID_CONFIG_NOACK) {
2eab2d81 Tamizh chelvam  2019-03-06  8353  					arg.rate_ctrl = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8354  					arg.rcode_flags = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8355  				}
2eab2d81 Tamizh chelvam  2019-03-06  8356  			}
2eab2d81 Tamizh chelvam  2019-03-06  8357  
2eab2d81 Tamizh chelvam  2019-03-06  8358  			ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
2eab2d81 Tamizh chelvam  2019-03-06  8359  			ret = ath10k_wmi_set_per_peer_per_tid_cfg(ar, &arg);
2eab2d81 Tamizh chelvam  2019-03-06  8360  			if (ret)
2eab2d81 Tamizh chelvam  2019-03-06  8361  				goto exit;
2eab2d81 Tamizh chelvam  2019-03-06  8362  
2eab2d81 Tamizh chelvam  2019-03-06  8363  			/* Store the configured parameters in success case */
2eab2d81 Tamizh chelvam  2019-03-06  8364  			if (changed & IEEE80211_TID_CONF_NOACK) {
2eab2d81 Tamizh chelvam  2019-03-06  8365  				if (tid_config->tid_conf[i].noack ==
2eab2d81 Tamizh chelvam  2019-03-06  8366  						NL80211_TID_CONFIG_DEFAULT) {
2eab2d81 Tamizh chelvam  2019-03-06  8367  					sta->noack[arg.tid] = -1;
2eab2d81 Tamizh chelvam  2019-03-06  8368  				} else {
2eab2d81 Tamizh chelvam  2019-03-06  8369  					sta->noack[arg.tid] = arg.ack_policy;
2eab2d81 Tamizh chelvam  2019-03-06  8370  				}
2eab2d81 Tamizh chelvam  2019-03-06  8371  
2eab2d81 Tamizh chelvam  2019-03-06  8372  				arg.ack_policy = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8373  				arg.aggr_control = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8374  				arg.rate_ctrl = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8375  				arg.rcode_flags = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8376  			}
2eab2d81 Tamizh chelvam  2019-03-06  8377  
2eab2d81 Tamizh chelvam  2019-03-06  8378  			if (changed & IEEE80211_TID_CONF_RETRY) {
2eab2d81 Tamizh chelvam  2019-03-06  8379  				if (tid_config->tid_conf[i].retry_long == -1) {
2eab2d81 Tamizh chelvam  2019-03-06  8380  					sta->retry_long[arg.tid] = -1;
2eab2d81 Tamizh chelvam  2019-03-06  8381  				} else {
2eab2d81 Tamizh chelvam  2019-03-06  8382  					sta->retry_long[arg.tid] = arg.retry_count;
2eab2d81 Tamizh chelvam  2019-03-06  8383  				}
2eab2d81 Tamizh chelvam  2019-03-06  8384  
2eab2d81 Tamizh chelvam  2019-03-06  8385  				arg.retry_count = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8386  			}
2eab2d81 Tamizh chelvam  2019-03-06  8387  
2eab2d81 Tamizh chelvam  2019-03-06  8388  			if (changed & IEEE80211_TID_CONF_AMPDU) {
2eab2d81 Tamizh chelvam  2019-03-06  8389  				if (tid_config->tid_conf[i].ampdu ==
2eab2d81 Tamizh chelvam  2019-03-06  8390  						NL80211_TID_CONFIG_DEFAULT) {
2eab2d81 Tamizh chelvam  2019-03-06  8391  					sta->ampdu[arg.tid] = -1;
2eab2d81 Tamizh chelvam  2019-03-06  8392  				} else {
2eab2d81 Tamizh chelvam  2019-03-06  8393  					sta->ampdu[arg.tid] = arg.aggr_control;
2eab2d81 Tamizh chelvam  2019-03-06  8394  				}
2eab2d81 Tamizh chelvam  2019-03-06  8395  
2eab2d81 Tamizh chelvam  2019-03-06  8396  				arg.aggr_control = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8397  			}
2eab2d81 Tamizh chelvam  2019-03-06  8398  
2eab2d81 Tamizh chelvam  2019-03-06  8399  			if (changed & IEEE80211_TID_CONF_TX_BITRATE) {
2eab2d81 Tamizh chelvam  2019-03-06  8400  				sta->rate_ctrl[arg.tid] = arg.rate_ctrl;
2eab2d81 Tamizh chelvam  2019-03-06  8401  				arg.rate_ctrl = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8402  				arg.rcode_flags = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8403  			}
2eab2d81 Tamizh chelvam  2019-03-06  8404  		} else {
2eab2d81 Tamizh chelvam  2019-03-06  8405  			arvif->tid_conf_changed[arg.tid] |= changed;
2eab2d81 Tamizh chelvam  2019-03-06  8406  
2eab2d81 Tamizh chelvam  2019-03-06  8407  			if (changed & IEEE80211_TID_CONF_NOACK) {
2eab2d81 Tamizh chelvam  2019-03-06  8408  				vif->noack[arg.tid] = arg.ack_policy;
2eab2d81 Tamizh chelvam  2019-03-06  8409  				vif->ampdu[arg.tid] = arg.aggr_control;
2eab2d81 Tamizh chelvam  2019-03-06  8410  				vif->rate_ctrl[arg.tid] = arg.rate_ctrl;
2eab2d81 Tamizh chelvam  2019-03-06  8411  			}
2eab2d81 Tamizh chelvam  2019-03-06  8412  
2eab2d81 Tamizh chelvam  2019-03-06  8413  			if (changed & IEEE80211_TID_CONF_RETRY)
2eab2d81 Tamizh chelvam  2019-03-06  8414  				vif->retry_long[arg.tid] = arg.retry_count;
2eab2d81 Tamizh chelvam  2019-03-06  8415  
2eab2d81 Tamizh chelvam  2019-03-06  8416  			if (changed & IEEE80211_TID_CONF_AMPDU)
2eab2d81 Tamizh chelvam  2019-03-06  8417  				vif->ampdu[arg.tid] = arg.aggr_control;
2eab2d81 Tamizh chelvam  2019-03-06  8418  
2eab2d81 Tamizh chelvam  2019-03-06  8419  			if (changed & IEEE80211_TID_CONF_TX_BITRATE) {
2eab2d81 Tamizh chelvam  2019-03-06  8420  				vif->rate_ctrl[arg.tid] = arg.rate_ctrl;
2eab2d81 Tamizh chelvam  2019-03-06  8421  				vif->rate_code[arg.tid] = arg.rcode_flags;
2eab2d81 Tamizh chelvam  2019-03-06  8422  			}
2eab2d81 Tamizh chelvam  2019-03-06  8423  		}
2eab2d81 Tamizh chelvam  2019-03-06  8424  	}
2eab2d81 Tamizh chelvam  2019-03-06  8425  
2eab2d81 Tamizh chelvam  2019-03-06  8426  	if (sta)
2eab2d81 Tamizh chelvam  2019-03-06  8427  		goto exit;
2eab2d81 Tamizh chelvam  2019-03-06  8428  
2eab2d81 Tamizh chelvam  2019-03-06  8429  	ret = 0;
2eab2d81 Tamizh chelvam  2019-03-06  8430  	data.curr_vif = vif;
2eab2d81 Tamizh chelvam  2019-03-06  8431  	data.ar = ar;
2eab2d81 Tamizh chelvam  2019-03-06  8432  
2eab2d81 Tamizh chelvam  2019-03-06  8433  	ieee80211_iterate_stations_atomic(hw, ath10k_mac_vif_stations_tid_conf,
2eab2d81 Tamizh chelvam  2019-03-06  8434  					  &data);
2eab2d81 Tamizh chelvam  2019-03-06  8435  
2eab2d81 Tamizh chelvam  2019-03-06  8436  exit:
2eab2d81 Tamizh chelvam  2019-03-06  8437  	mutex_unlock(&ar->conf_mutex);
2eab2d81 Tamizh chelvam  2019-03-06 @8438  	return ret;
2eab2d81 Tamizh chelvam  2019-03-06  8439  }
2eab2d81 Tamizh chelvam  2019-03-06  8440  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
