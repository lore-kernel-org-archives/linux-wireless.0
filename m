Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47636 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbCSMxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 08:53:31 -0400
Date: Thu, 19 Mar 2015 15:53:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jouni@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mac80111: Add BIP-GMAC-128 and BIP-GMAC-256 ciphers
Message-ID: <20150319125314.GA15250@mwanda> (sfid-20150319_135342_744584_EF124565)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jouni Malinen,

The patch 8ade538bf39b: "mac80111: Add BIP-GMAC-128 and BIP-GMAC-256
ciphers" from Jan 24, 2015, leads to the following static checker
warning:

	net/mac80211/aes_gmac.c:74 ieee80211_aes_gmac_key_setup()
	warn: we tested 'err' before and it was 'true'

net/mac80211/aes_gmac.c
    61  struct crypto_aead *ieee80211_aes_gmac_key_setup(const u8 key[],
    62                                                   size_t key_len)
    63  {
    64          struct crypto_aead *tfm;
    65          int err;
    66  
    67          tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
    68          if (IS_ERR(tfm))
    69                  return tfm;
    70  
    71          err = crypto_aead_setkey(tfm, key, key_len);
    72          if (!err)
                    ^^^^
This is success handling.  In the kernel, everyone expects error
hanlding like "if (err) " so this makes the code hard to read if you
have a job and need to read code quickly.  At first I missed the "!"
character, and then I thought,  "What??  Is err a pointer?"

    73                  return tfm;
    74          if (!err)
    75                  err = crypto_aead_setauthsize(tfm, GMAC_MIC_LEN);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is dead code.

    76  
    77          crypto_free_aead(tfm);
    78          return ERR_PTR(err);

This function should be a list of commands in a row with tiny detours
for exceptions and error handling.  It messes everyone up if the success
path is hidden somewhere in the middle and it leads to bugs like this.

    79  }

regards,
dan carpenter
