Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:49793 "EHLO
	sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbCJPv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 11:51:56 -0400
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: "Stepanov, Max" <Max.Stepanov@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Get IV len from key conf and not cipher scheme
Date: Tue, 10 Mar 2015 15:51:53 +0000
Message-ID: <5842EA9CC042B141995329508713AD672105A983@ILMAIL1.corp.local> (sfid-20150310_165202_331479_DADE8E8C)
References: <3A934E7FDB083A4683727C7D377065954A23682A@hasmsx109.ger.corp.intel.com>
 <5842EA9CC042B141995329508713AD672105A8F0@ILMAIL1.corp.local>
 <3A934E7FDB083A4683727C7D377065954A2369B7@hasmsx109.ger.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If key is installed without cipher scheme and the cipher is not in explicitly implemented ciphers setting non zero key->conf.iv_len, the ieee80211_key_alloc() function will set key->conf.iv_len to 0.  Perhaps it makes sense to add key->conf.iv_len == 0 verification to ieee80211_crypto_cs_encrypt() before extending skb head. Does it make sense?
>
make sense to me, I will add it.

rgds,
cedric

