Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DCEC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 23:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ACD22086C
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 23:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="ShtHktwN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfA3Xqf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 18:46:35 -0500
Received: from ozlabs.org ([203.11.71.1]:48069 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfA3Xqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 18:46:35 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ozlabs.org (Postfix) with ESMTPSA id 43qg4S3G6Zz9s9h;
        Thu, 31 Jan 2019 10:46:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1548891992;
        bh=visofJ8vCCpT6qpaBHgU1PPiAfvYeW+KbeEn+HN4KJw=;
        h=Date:From:To:Cc:Subject:From;
        b=ShtHktwN9wBpF7tTQmVIlYXX5L/VJ6bjKiVCD/SWSxCzB3pX35pgeGtRWNky9/1Sf
         boxxrI5Z5df96hKZWugtSWMLaJ2C63DGT/kOait3dN8+fqpk83Z5DA55QSHUBn5UAr
         u4gG71VbSfcPv8LrgTXJGgrrudEtvw/9elneQHKLlXW6odXxofS7NDvGcztuLAt033
         j/RGVEqUEEoFJMBdt05dx+I4Ra+3XYB+bro/zTXILfY9OWfetVh7rWV3RpmxsTnC34
         H2Mhy/SVY9nEQk3C0Vv8V+Loct3Z62KiJPhfJtgFsndizL1WhiMGhXyhSsJpScmPJZ
         GB+dE6dgBAjQw==
Date:   Thu, 31 Jan 2019 10:46:26 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: build warning after merge of the wireless-drivers-next
 tree
Message-ID: <20190131104626.62ff05ce@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/afMExeCp/SIBblsvDHiEv0V"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/afMExeCp/SIBblsvDHiEv0V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the wireless-drivers-next tree, today's linux-next build
(x86_64 allmodconfig) produced this warning:

drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:195:13: warning: 'iwl_mvm_add=
_rtap_sniffer_config' defined but not used [-Wunused-function]
 static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Introduced by commit

  9bf13bee2d74 ("iwlwifi: mvm: include configured sniffer AID in radiotap")

--=20
Cheers,
Stephen Rothwell

--Sig_/afMExeCp/SIBblsvDHiEv0V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlxSN1IACgkQAVBC80lX
0Gyukwf+MOAs6EFm07dVghXCzXuqRffQNaZ003yGYC6+DGV8IYV1lkRJZqYirZ9Z
+jQYhepillqMj1xQXxvQ6IsPeXxkAvaSPYLc9phqA6cs91MHIroPhzL7j9hDLaUB
gZGOtq+6R+2fdxj9OABrqiqRJ56oYhsCua1h1tNdY8ipv/NHW4xC5AlJkdGJLNg7
8OsVE+fe0SPUuRqzHWqqEMn2DWFytljuEb0c9XqmzTXf029FDtFr8zJ1jCcSrM9O
3FlDzATEE7xA/wn82qsU0Ey8hputtHUgGx7+efYUPgpR0AEUqtmzpPqYlB0rAN6Z
2Z2kP2bEtRmOMFSrBl7JIVGSPA4Aww==
=Mxa2
-----END PGP SIGNATURE-----

--Sig_/afMExeCp/SIBblsvDHiEv0V--
