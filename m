Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35438 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaAXWht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:37:49 -0500
Received: by mail-pd0-f181.google.com with SMTP id y10so3603519pdj.40
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:37:49 -0800 (PST)
Received: from mcgrof@gmail.com (c-24-7-61-223.hsd1.ca.comcast.net. [24.7.61.223])
        by mx.google.com with ESMTPSA id xs1sm17138517pac.7.2014.01.24.14.37.45
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 24 Jan 2014 14:37:47 -0800 (PST)
Date: Fri, 24 Jan 2014 14:37:44 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Subject: [ANN] crda-3.13 released
Message-ID: <20140124223742.GA26233@garbanzo.do-not-panic.com> (sfid-20140124_233753_001278_9BDED5C9)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I hadn't made a release in a while, its time. Quite a bit of changes
have happened but nothing relevant for the user other than the code
was cleaned up heavily.

Distributions folks would care that CRDA is now licensed under
copyleft-next, and that we now use separate code for using the
db into a library. This allows developers to easily write code
to work with the db, parse it, and do kung-fu with it. A great
example is the new database optimizer parser, which could be
used for example by vendors who have legacy regulatory databases
and need something to scrape their not-so-efficient-dbs into
efficient dbs.

New shiny temporary release page:

http://drvbp1.linux-foundation.org/~mcgrof/rel-html/crda/

Ben Hutchings (1):
      reglib: Validate all structure and array lengths

Christian Lamparter (1):
      reglib: fix memset usage

Luis R. Rodriguez (50):
      crda: fix compile warning on pcc for reglib for string.h
      crda: make reg_rules_intersect() style match Linux
      crda: port over Linux is_valid_reg_rule() change bd05f28e
      crda: remove verbose errors out of regdom_intersect()
      crda: constify usage of struct ieee80211_regdomain
      crda: remove unused BUG_ON() from intersect.c
      crda: move regdom_intersect() to reglib
      crda: fix regression when using reglib_for_each_country()
      crda: move intersection if first attempt failed
      crda: do not double count on reglib_for_each_country()
      crda: annotate intersection worst case scenerio
      crda: fix intersect.c memory management
      crda: explicitly munmap() on reglib_get_rd_alpha2()
      crda: explicitly close file descriptor and munmap() on failures
      crda: separate crda_verify_db_signature() implementations
      crda: use gcry_sexp_release() on crda_verify_db_signature()
      crda: explicitly use close() and munmap() on reglib_get_rd_alpha2()
      crda: use gcry_mpi_release() when using gcry_mpi_scan()
      crda: rename world and prev_world on intersect.c
      crda: remove verbosity out of intersect.c
      crda: rename regdom_intersect() to reglib_intersect_rds()
      crda: rename crda_get_file_ptr() to reglib_get_file_ptr()
      crda: rename crda_verify_db_signature() to reglib_verify_db_signature()
      crda: rename print_regdom() to reglib_print_regdom()
      crda: add regdb_dfs_regions
      crda: make print-regdom use internal flags
      crda: move reg print helpers to reglib
      crda: rename is_world_regdom() to reglib_is_world_regdom()
      crda: rename isalpha_upper() to reglib_isalpha_upper()
      crda: rename is_alpha2() to reglib_is_alpha2()
      crda: rename is_valid_regdom() to reglib_is_valid_regdom()
      crda: rename max() to reglib_max()
      crda: rename min() to reglib_min()
      crda: fix spacing on reglib_for_each_country()
      crda: clarify intersect.c only computes an intersection
      crda: separate intersecting a full db into a helper
      crda: move reglib_intersect_regdb() to reglib
      crda: move regdbprint to its own helper
      crda: add reglib regdb context helpers: reglib_(malloc|free)_regdb_ctx()
      crda: pass struct reglib_regdb_ctx to country2rd()
      crda: make reglib_for_each_country() use the reglib context
      reglib: add reglib_is_valid_rd() and verify data upon build
      crda: consolidate passive-scan and no-ibss flags
      crda: remove antenna gain
      crda: relicense under copyleft-next-0.3.0
      crda: fix -pedantic gcc compilation
      crda: add regulatory domain stream parser
      crda: add regulatory domain optimizer
      crda: make ssl keys include stdint.h
      crda: make reglib a shared library

Zefir Kurtisi (2):
      crda: synch up nl80211.h
      crda: display DFS regulatory domain in regdbdump


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS4us1AAoJEKwtdpJg+MHGNJoP/jSxLwjgsoijVci5LoK2+zku
zoQ/XrB01Mx6G05cWNgAzHLxN9iqmmpfW//h/esIHAmbpxxHu9JGyU1RhInqpNkU
emq8UKZ/WdzUtgQp7QI3dmbpOT+2m351racPp63lyCozBattUuFxGqrwrz9JW8ii
4fd7ISBkUadmNQ3+1biY8mGSiljviI180udvPlIH+hEKLndZpcu9J8MwuETn7vxZ
rNxcFXByNXkd0fHgK65bwFOjYvQNksNbiifHhjCin8oSaB8uldosgDTggroIQ0tn
WDgXcwLksGELoaeBl/ZmLXAx1V7PhTfJEbA2pXiT8eIaOwo7boj6Ea1o32skpo1h
fDO3LsQvwv5APqLdF/IPtWqMtluD9bfApjmKyb12vhqHhLZJuoAVnko7Ukf5c5r1
kfVxPeIrfZROPDf20kBa8HG+64/kPp6kAf7KbggwlZz1FTDTxseoXuVaS2w9L1YT
Bn377U93NGwFgaMRq/7nyvfQoIE17ZhC7+c0ib1AKKVbRs3oBzVEap+qtaKcj8RT
V/R6P/T3+ckUD6j8P3XlxTSlUSuRdGldeGhzr1Pr+hWM8cNA3SntV8n+wwrpORRM
FWYur6QXGp9ZwiXrvtNkOjZhLTy6lmot4WFHUEW1mzm6IOlaojR2dq4F7wDz+MxI
ojDTXM3ndDsn+mlsYwd9
=Lckd
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
