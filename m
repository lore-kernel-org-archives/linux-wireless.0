Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D09C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 11:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0096321773
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 11:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2RY4X0jF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbeLTLSC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 06:18:02 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42856 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbeLTLSC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 06:18:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBKBFYKI035144
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2018 11:18:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=596zQCrpKtpB5+wGz/XWuxxkKpZVCW8CezEgUQTEcyk=;
 b=2RY4X0jFpaI56a1l21Qi/hJjv6ZmT/uXvTNiZFmuf2bbA++gfH/9RDOIcUSuPc8RlBZR
 wycesm9qELGyBIwbdv5KhieRW2KcxX13hU/MAJF6TXWs+ol1GY6Emea4QJisYsub71sj
 PkIY/slbkKO6t8Rh40y8RtxZDCrFZJ3nxCt4XHA4UCODNtB+jHcyYzdzsIkkezeyKJK2
 NygMe4/5h53YeQoUZllocuvW+shhxXpa0ayxFkYxR+USPvIYvIV57cNELym0bLqR5W4N
 BNy0IL0R0D4tfECgNw3zyr/kVg/zsMvy5oDg8zERi/F+W+TxWg0KkkmhBVGkR4HDVDQI ww== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pf8gfgc1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2018 11:18:00 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBKBHsJL028420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2018 11:17:55 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBKBHs29000814
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2018 11:17:54 GMT
Received: from kadam (/10.175.63.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Dec 2018 03:17:54 -0800
Date:   Thu, 20 Dec 2018 14:17:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     linux-wireless@vger.kernel.org
Subject: [bug report] nl80211/cfg80211: add radar detection command/event
Message-ID: <20181220111726.GA19146@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9112 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812200094
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi wireless devs,

The patch 04f39047af2a: "nl80211/cfg80211: add radar detection
command/event" from Feb 8, 2013, leads to the following static
checker warning:

	net/wireless/chan.c:250 cfg80211_set_chans_dfs_state()
	warn: 'center_freq + bandwidth / 2 - 10' negative user limit promoted to high

net/wireless/chan.c
   242  static void cfg80211_set_chans_dfs_state(struct wiphy *wiphy, u32 center_freq,
   243                                           u32 bandwidth,
   244                                           enum nl80211_dfs_state dfs_state)
   245  {
   246          struct ieee80211_channel *c;
   247          u32 freq;
   248  
   249          for (freq = center_freq - bandwidth/2 + 10;
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   250               freq <= center_freq + bandwidth/2 - 10;
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This isn't really a big issue but center_freq comes from
nla_get_u32(attrs[NL80211_ATTR_WIPHY_FREQ]) in nl80211_parse_chandef().
Smatch is complaining that there is an issue with the math
over/underflowing.  It just means that we loop for a long time.  It's
not a security problem.  Even without the overflow, we could end up
looping for a long time.

Is center_freq capped somewhere that I haven't seen?

   251               freq += 20) {
   252                  c = ieee80211_get_channel(wiphy, freq);
   253                  if (!c || !(c->flags & IEEE80211_CHAN_RADAR))
   254                          continue;
   255  
   256                  c->dfs_state = dfs_state;
   257                  c->dfs_state_entered = jiffies;
   258          }
   259  }

regards,
dan carpenter
