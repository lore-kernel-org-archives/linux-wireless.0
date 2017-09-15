Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37314 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbdIOKVA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 06:21:00 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <johannes@sipsolutions.net>)
        id 1dsnk3-0006cq-GF
        for linux-wireless@vger.kernel.org; Fri, 15 Sep 2017 12:20:59 +0200
Message-ID: <1505470858.31630.37.camel@sipsolutions.net> (sfid-20170915_122103_822713_1A22C8F6)
Subject: Re: [RFC 4/4] cfg80211: implement regdb signature checking
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 15 Sep 2017 12:20:58 +0200
In-Reply-To: <20170915101810.11435-5-johannes@sipsolutions.net> (sfid-20170915_121820_023097_633FD9F9)
References: <20170915101810.11435-1-johannes@sipsolutions.net>
         <20170915101810.11435-5-johannes@sipsolutions.net>
         (sfid-20170915_121820_023097_633FD9F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-15 at 12:18 +0200, Johannes Berg wrote:
> 
> +config CFG80211_REQUIRE_SIGNED_REGDB
> +	bool "require regdb signature" if
> CFG80211_CERTIFICATION_ONUS
> +	default y
> +	select SYSTEM_DATA_VERIFICATION

Note that this will not be easy to backport, however, the code only
needs relatively self-contained functionality, namely this:

> +       builtin_regdb_keys =
> +               keyring_alloc(".builtin_regdb_keys",
> +                             KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
> +                             ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
> +                             KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
> +                             KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);

> +               key = key_create_or_update(make_key_ref(builtin_regdb_keys, 1),
> +                                          "asymmetric",
> +                                          NULL,
> +                                          p,
> +                                          plen,
> +                                          ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
> +                                          KEY_USR_VIEW | KEY_USR_READ),
> +                                          KEY_ALLOC_NOT_IN_QUOTA |
> +                                          KEY_ALLOC_BUILT_IN |
> +                                          KEY_ALLOC_BYPASS_RESTRICTION);

> +       if (verify_pkcs7_signature(db->data, db->size, sig->data, sig->size,
> +                                  builtin_regdb_keys,
> +                                  VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL))

so I'm hoping it won't be too difficult, since we don't really need the
ability to manipulate keyrings etc.

johannes
