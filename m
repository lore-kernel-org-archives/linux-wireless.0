Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B168C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 21:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F28AE208E7
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 21:57:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F28AE208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbeKPIGw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 03:06:52 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:36796 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725888AbeKPIGw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 03:06:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gNPdR-0002r2-6E; Thu, 15 Nov 2018 23:57:13 +0200
Message-ID: <36b1d59aec9ed10decb32d054de33bb108530a26.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Thu, 15 Nov 2018 23:57:11 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Ef2QZ4R94O2Y8+Y6TJkQ"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2018-11-15
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-Ef2QZ4R94O2Y8+Y6TJkQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the first batch of fixes for v4.20.  More details about the
contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit b374e8686fc35ae124e62dc78725ea656ba1ef8a=
:

  mt76: fix building without CONFIG_LEDS_CLASS (2018-11-06 18:46:33 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-for-kalle-2018-11-15

for you to fetch changes up to 5d041c46ccb9b48acc110e214beff5e2789311df:

  iwlwifi: mvm: don't use SAR Geo if basic SAR is not used (2018-11-15 23:5=
0:59 +0200)

----------------------------------------------------------------
First batch of iwlwifi fixes for 4.20

* New FW debugging infrastructure;
* Some more work on 802.11ax;
* Improve support for multiple RF modules with 22000 devices;
* Remove an unused FW parameter;
* Other debugging improvements;

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: mvm: support sta_statistics() even on older firmware
      iwlwifi: mvm: fix regulatory domain update when the firmware starts

Luca Coelho (1):
      iwlwifi: mvm: don't use SAR Geo if basic SAR is not used

Matt Chen (1):
      iwlwifi: fix wrong WGDS_WIFI_DATA_SIZE

Shahar S Matityahu (1):
      iwlwifi: fix D3 debug data buffer memory leak

 drivers/net/wireless/intel/iwlwifi/fw/acpi.h      |  4 +++-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h   |  6 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 38 +++++++++++++++++++=
++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c      |  5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  2 ++
 6 files changed, 47 insertions(+), 20 deletions(-)

--=-Ef2QZ4R94O2Y8+Y6TJkQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlvt67cACgkQoUecoho8
xfp10A//bEHv4Rre3Zrk8mfZtrgcuvX38ponSynTFwi55WJgurxCb5rvlR1O29LG
IBfrZ6ASDt0UTeNhx7YL4hIxxePEdPNvib0lZckb32P4kqSPSxSptHySOPFiJLsQ
MdMcUpK7apQ5wm8cIrZQ6ZYGWveP4+hMrhdrWMJmr0JJ3M7n2+SlUQBZ5nRQ73lF
mBB0gPgLznT0aOyNNy+LbYE0NzjGhafGerAraUYcAwZ75Tg+rv7DjDjIRW1iEpLv
oETFe9nGz2UoSq7DdkbXGJZvb1566eqTUFU1Y1qaRO6I47m4gKhOa1D4Schzpq63
TEiIVZ0GxVSKmGfnzbXz2Z2PUMSv/HXKeglhhdAN34a/uCDBb3Fk54mehEoGs5eU
0hSyE2MxKfZjhyGjTWpdyS/B1szVCxoDNmRQ8+EHSn4sNo8oLcneY3ogh3Tg/lEe
myFYrIiUORl+H09pHAn4tN+n0gw6BMbeIJlwP3EjMgW90JwdKMyVLtGy2LlqCPy2
IFaEbTa9nChTdWA/buvIzVwWA7rjFFAGPv3JyHFLFQNyW1EFaaYWmd+oz/10WToI
eyCvT3R2VukfcivjmayuAlYojgcN6eiKWznIkw1QI9adhdKkKIQ+zWzujiiAMUFk
jzpnrZC2bdHHVwdxaCFT3xp9MyHQT+r97Hz7BIhfCyMNHMZunNA=
=+L6M
-----END PGP SIGNATURE-----

--=-Ef2QZ4R94O2Y8+Y6TJkQ--

