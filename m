Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:50057 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2B2Gir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 01:38:47 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q1T6cjwK012954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 06:38:46 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q1T6ciIu017469
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 06:38:44 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q1T6ciR7003388
	for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 00:38:44 -0600
Date: Wed, 29 Feb 2012 09:38:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-wireless@vger.kernel.org
Subject: checking for integer overflows in cfg80211_roamed_bss()
Message-ID: <20120229063841.GG18031@elgon.mountain> (sfid-20120229_073850_391425_67F24184)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just sent a patch for a places that didn't cap "req_ie_len" and
"resp_ie_len" properly leading to integer overflows in
cfg80211_roamed_bss().  If there was a good way, I'd like to cap those
values inside cfg80211_roamed_bss() as well.  What is a good limit to
use?

devel/net/wireless/sme.c
   653  
   654          ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
   655          if (!ev) {
   656                  cfg80211_put_bss(bss);
   657                  return;
   658          }
   659  

regards,
dan carpenter
