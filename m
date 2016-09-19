Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50286 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754794AbcISKKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 06:10:32 -0400
Message-ID: <1474279827.4469.30.camel@sipsolutions.net> (sfid-20160919_121036_407416_16C2CEC0)
Subject: Re: [v2 PATCH 0/2] rhashtable: rhashtable with duplicate objects
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        tom@herbertland.com, Ben Greear <greearb@candelatech.com>
Date: Mon, 19 Sep 2016 12:10:27 +0200
In-Reply-To: <1474279492.4469.29.camel@sipsolutions.net> (sfid-20160919_120500_879459_486B5001)
References: <20160804071846.GA773@gondor.apana.org.au>
         <20160804074546.GA996@gondor.apana.org.au>
         <1470377813.2977.14.camel@sipsolutions.net>
         <20160805104858.GA9297@gondor.apana.org.au>
         <1470394233.2977.37.camel@sipsolutions.net>
         <20160918135030.GA7062@gondor.apana.org.au>
         <20160919084056.GA11875@gondor.apana.org.au>
         <1474276530.4469.16.camel@sipsolutions.net>
         <20160919091721.GA12235@gondor.apana.org.au>
         <1474277244.4469.21.camel@sipsolutions.net>
         <20160919093434.GA12378@gondor.apana.org.au>
         (sfid-20160919_113440_719977_971CE718) <1474278634.4469.25.camel@sipsolutions.net>
         (sfid-20160919_115045_089605_A254E125) <1474278896.4469.26.camel@sipsolutions.net>
         (sfid-20160919_115508_261438_39410159) <1474279330.4469.28.camel@sipsolutions.net>
         (sfid-20160919_120228_517669_28A2A922) <1474279492.4469.29.camel@sipsolutions.net>
         (sfid-20160919_120500_879459_486B5001)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Btw, for debug I put

BUG_ON(atomic_read(&ht->nelems) < 0);

after the atomic_dec() in __rhashtable_remove_fast_one(). That makes
the kernel crash instantly on the buggy code, and I just have to run a
single test ("wpas_ctrl_interface_add_many") to get there.

johannes
