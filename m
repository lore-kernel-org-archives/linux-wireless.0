Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF4CC43387
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 11:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7776E20815
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 11:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="1hpk8p6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfACLNs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 06:13:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbfACLNs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 06:13:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x03B8dMi074087;
        Thu, 3 Jan 2019 11:13:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=ksdjxPxNc+N01RgxBPAbBts42hQr+lUbJg45haFykP4=;
 b=1hpk8p6w4LOgP0igi2DanikKYI1F3oFBWO629C2UkJS5d5C6LSv3DvhyL9v/qYAgIdVT
 XcX3aKSPjTXhNlJTzsCX1gk6jZDCH08vriJ5s1ptvnrcpWGLZBQzwGpE7ZSeQ3pc5T4k
 AzsNwFT9ObYaT8KWdmZE6u9X3emYSj7KyUjSrx0e0RsMmK8XoiLpEu8x9b34ackrZoWN
 SUIiHRw0mHMgniqQUN1t9gPI2YoYLS+d/iIAMOICHfqa0SGEeCgiYexBIg2UgdabTN2N
 zaLLheAEg5woa7DCzMLlyPp6wBqVm4JjOBXWFgg9jYZVD+4sbTgJGj8BdeAR1+5Gasii 7Q== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jr6ff6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jan 2019 11:13:46 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x03BDjvA031338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Jan 2019 11:13:45 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x03BDjRv031321;
        Thu, 3 Jan 2019 11:13:45 GMT
Received: from kadam (/41.202.241.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jan 2019 03:13:44 -0800
Date:   Thu, 3 Jan 2019 14:13:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     baijiaju1990@gmail.com
Cc:     linux-wireless@vger.kernel.org
Subject: [bug report] cw1200: Fix concurrency use-after-free bugs in
 cw1200_hw_scan()
Message-ID: <20190103111338.GA9692@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9124 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=463
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901030100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Jia-Ju Bai,

The patch 4f68ef64cd7f: "cw1200: Fix concurrency use-after-free bugs
in cw1200_hw_scan()" from Dec 14, 2018, leads to the following static
checker warning:

drivers/net/wireless/st/cw1200/scan.c:127 cw1200_hw_scan() warn: inconsistent returns 'sem:&priv->scan.lock'.
  Locked on:   line 88
               line 127
  Unlocked on: line 66
               line 70
drivers/net/wireless/st/cw1200/scan.c:268 cw1200_scan_work() warn: inconsistent returns 'sem:&priv->scan.lock'.
  Locked on:   line 262
               line 268
  Unlocked on: line 196


(I don't really understand the locking in cw1200_scan_work() well enough
to say what's supposed to happen but the first warning seems like a bug).

drivers/net/wireless/st/cw1200/scan.c
    54 int cw1200_hw_scan(struct ieee80211_hw *hw,
    55 		   struct ieee80211_vif *vif,
    56 		   struct ieee80211_scan_request *hw_req)
    57 {
    58 	struct cw1200_common *priv = hw->priv;
    59 	struct cfg80211_scan_request *req = &hw_req->req;
    60 	struct wsm_template_frame frame = {
    61 		.frame_type = WSM_FRAME_TYPE_PROBE_REQUEST,
    62 	};
    63 	int i, ret;
    64 
    65 	if (!priv->vif)
    66 		return -EINVAL;
    67 
    68 	/* Scan when P2P_GO corrupt firmware MiniAP mode */
    69 	if (priv->join_status == CW1200_JOIN_STATUS_AP)
    70 		return -EOPNOTSUPP;
    71 
    72 	if (req->n_ssids == 1 && !req->ssids[0].ssid_len)
    73 		req->n_ssids = 0;
    74 
    75 	wiphy_dbg(hw->wiphy, "[SCAN] Scan request for %d SSIDs.\n",
    76 		  req->n_ssids);
    77 
    78 	if (req->n_ssids > WSM_SCAN_MAX_NUM_OF_SSIDS)
    79 		return -EINVAL;
    80 
    81 	/* will be unlocked in cw1200_scan_work() */
    82 	down(&priv->scan.lock);
        ^^^^^^^^^^^^^^^^^^^^^^
    83 	mutex_lock(&priv->conf_mutex);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    84 
    85 	frame.skb = ieee80211_probereq_get(hw, priv->vif->addr, NULL, 0,
    86 		req->ie_len);
    87 	if (!frame.skb)
    88 		return -ENOMEM;
                ^^^^^^^^^^^^^^^

Need to drop the locks before returning.

    89 
    90 	if (req->ie_len)
    91 		skb_put_data(frame.skb, req->ie, req->ie_len);
    92 
    93 	ret = wsm_set_template_frame(priv, &frame);
    94 	if (!ret) {
    95 		/* Host want to be the probe responder. */
    96 		ret = wsm_set_probe_responder(priv, true);
    97 	}
    98 	if (ret) {
    99 		dev_kfree_skb(frame.skb);
    100 		mutex_unlock(&priv->conf_mutex);
    101 		up(&priv->scan.lock);
    102 		return ret;
    103 	}
    104 
    105 	wsm_lock_tx(priv);
    106 
    107 	BUG_ON(priv->scan.req);
    108 	priv->scan.req = req;
    109 	priv->scan.n_ssids = 0;
    110 	priv->scan.status = 0;
    111 	priv->scan.begin = &req->channels[0];
    112 	priv->scan.curr = priv->scan.begin;
    113 	priv->scan.end = &req->channels[req->n_channels];
    114 	priv->scan.output_power = priv->output_power;
    115 
    116 	for (i = 0; i < req->n_ssids; ++i) {
    117 		struct wsm_ssid *dst = &priv->scan.ssids[priv->scan.n_ssids];
    118 		memcpy(&dst->ssid[0], req->ssids[i].ssid, sizeof(dst->ssid));
    119 		dst->length = req->ssids[i].ssid_len;
    120 		++priv->scan.n_ssids;
    121 	}
    122 
    123 	if (frame.skb)
    124 		dev_kfree_skb(frame.skb);
    125 	mutex_unlock(&priv->conf_mutex);
    126 	queue_work(priv->workqueue, &priv->scan.work);
    127 	return 0;
    128 }

regards,
dan carpenter
