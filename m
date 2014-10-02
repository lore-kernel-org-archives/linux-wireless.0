Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18422 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJBSQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 14:16:20 -0400
Date: Thu, 2 Oct 2014 21:16:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: re: [PATCH] Check ieee80211softmac_auth_resp kmalloc result
Message-ID: <20141002181608.GA24110@mwanda> (sfid-20141002_201624_090521_5F26244A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've written a new kind of Smatch check that generates this warning:

	drivers/net/wireless/ipw2x00/libipw_rx.c:1303 libipw_parse_info_param()
	warn: potentially allocating too little.

drivers/net/wireless/ipw2x00/libipw_rx.c
  1300                  case WLAN_EID_IBSS_DFS:
  1301                          if (network->ibss_dfs)
  1302                                  break;
  1303                          network->ibss_dfs = kmemdup(info_element->data,
  1304                                                      info_element->len,

The problem is that smatch marks "info_element->len" as untrusted data
because it comes from skb->data.  "network->ibss_dfs" is a 9 character
struct.  We're not necessarily allocating enough space for that.

So far as I can see this is harmless because we never use ->ibss_dfs
and we should just delete it along with all the related code?

  1305                                                      GFP_ATOMIC);
  1306                          if (!network->ibss_dfs)
  1307                                  return 1;
  1308                          network->flags |= NETWORK_HAS_IBSS_DFS;
  1309                          break;

regards,
dan carpenter
