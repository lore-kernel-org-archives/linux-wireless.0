Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62652 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbbCJPDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 11:03:00 -0400
From: "Stepanov, Max" <Max.Stepanov@intel.com>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: Get IV len from key conf and not cipher scheme
Date: Tue, 10 Mar 2015 15:02:33 +0000
Message-ID: <3A934E7FDB083A4683727C7D377065954A2369B7@hasmsx109.ger.corp.intel.com> (sfid-20150310_160312_581186_2600CB63)
References: <3A934E7FDB083A4683727C7D377065954A23682A@hasmsx109.ger.corp.intel.com>
 <5842EA9CC042B141995329508713AD672105A8F0@ILMAIL1.corp.local>
In-Reply-To: <5842EA9CC042B141995329508713AD672105A8F0@ILMAIL1.corp.local>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>We use cipher scheme to support WAPI in both STA and AP mode.
>The patch is for the AP use case when sending a broadcast message that needs encryption. So we want to call 
>ieee80211_crypto_cs_encrypt even if sta is NULL.

So, on ieee80211_add_key() function call we fetch a cipher scheme and if it's present ieee80211_key_alloc() updates key->conf.iv_len setting it to cs->hdr_len. If sta is present cs is also stored in sta->cipher_scheme.

On Tx...
If a cipher scheme was found and sta is present, the ieee80211_crypto_cs_encrypt() supposes to behave the same as before the change. That's looks fine.

If sta is not present your patch changes the flow allowing to use key->conf.iv_len instead of cs->hdr_len associated with sta. In this case you don't need Rx handling without sta because bcast/mcast Rx is handled in STA mode only and in this case sta is present. That's looks fine too.

If key is installed without cipher scheme and the cipher is not in explicitly implemented ciphers setting non zero key->conf.iv_len, the ieee80211_key_alloc() function will set key->conf.iv_len to 0.  Perhaps it makes sense to add key->conf.iv_len == 0 verification to ieee80211_crypto_cs_encrypt() before extending skb head. Does it make sense?

Max



