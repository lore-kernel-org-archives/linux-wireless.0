Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37536 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdKXH4j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 02:56:39 -0500
Message-ID: <1511510188.2841.7.camel@sipsolutions.net> (sfid-20171124_085656_470744_D8E65EFF)
Subject: Re: kernel BUG at crypto/asymmetric_keys/public_key.c:80
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Fainelli <f.fainelli@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 24 Nov 2017 08:56:28 +0100
In-Reply-To: <46fde28f-8f97-841e-d00a-399a40b3a2e7@gmail.com> (sfid-20171123_184803_677305_35FC2C0E)
References: <d2b989b6-38cf-a04d-0353-3540fdb891ed@gmail.com>
         <2ef18f35-bb00-2f4b-45fe-1beb3cdd0745@broadcom.com>
         <1511376145.2841.1.camel@sipsolutions.net>
         <a95ae21a-c9f7-4e01-98f1-469201e20615@gmail.com>
         <1511447043.2841.2.camel@sipsolutions.net>
         <46fde28f-8f97-841e-d00a-399a40b3a2e7@gmail.com>
         (sfid-20171123_184803_677305_35FC2C0E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-11-23 at 09:47 -0800, Florian Fainelli wrote:

> Absolutely, please find it enclosed.

Thanks.

This is a bit odd. I didn't think the most likely reason is that you
have

CONFIG_CRYPTO_SHA256=m

but everything else built-in. Thus, when loading the certificate,
there's no way to calculate the digest since that requires sha-256,
hence

        BUG_ON(!sig->digest);

If you make CONFIG_CRYPTO_SHA256=y then it should go away.

I guess I'll do this:

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index da91bb547db3..1abcc4fc4df1 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -20,6 +20,10 @@ config CFG80211
 	tristate "cfg80211 - wireless configuration API"
 	depends on RFKILL || !RFKILL
 	select FW_LOADER
+	# may need to update this when certificates are changed and are
+	# using a different algorithm, though right now they shouldn't
+	# (this is here rather than below to allow it to be a module)
+	select CRYPTO_SHA256 if CFG80211_USE_KERNEL_REGDB_KEYS
 	---help---
 	  cfg80211 is the Linux wireless LAN (802.11) configuration API.
 	  Enable this if you have a wireless device.
@@ -113,6 +117,9 @@ config CFG80211_EXTRA_REGDB_KEYDIR
 	  certificates like in the kernel sources (net/wireless/certs/)
 	  that shall be accepted for a signed regulatory database.
 
+	  Note that you need to also select the correct CRYPTO_<hash> modules
+	  for your certificates, and if cfg80211 is built-in they also must be.
+
 config CFG80211_REG_CELLULAR_HINTS
 	bool "cfg80211 regulatory support for cellular base station hints"
 	depends on CFG80211_CERTIFICATION_ONUS


Can you try if that fixes your config for you?

johannes
