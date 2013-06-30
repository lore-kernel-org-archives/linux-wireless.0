Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:48791 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3F3XIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jun 2013 19:08:38 -0400
Received: by mail-la0-f41.google.com with SMTP id fn20so3828736lab.28
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jun 2013 16:08:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 30 Jun 2013 16:08:15 -0700
Message-ID: <CAB=NE6XeDvaqY+7MWPvBbtZPXNFtseQMe2xFVVVAfQSiEq6HCg@mail.gmail.com> (sfid-20130701_010854_592479_EBEA11D1)
Subject: Re: [PATCH 00/40] crda: reglib enhancements
To: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>, alexandre@cmu.edu
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 30, 2013 at 7:08 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> I've hinted I've been working towards a regdb regulatory
> library. This pushes that idea further as I was inclined
> recently to develop a union algorithm and saw we still
> had quite a bit of work to be able to share more consistently.
>
> I'll likely be using the intersection code as basis for this
> and as such I've cleaned that up and also ran valgrind over
> most of the code. I believe I've fixed all reglib memory
> related issues the rest of things valgrind bitches about
> are due to netlink.
>
> mcgrof@frijol ~ $ cat .valgrindrc
> --memcheck:leak-check=full
> --memcheck:leak-resolution=high
> --memcheck:show-reachable=yes
> --memcheck:num-callers=50
>
> If this looks OK I'll next start working towards the union
> code. The purpose of this is two fold:
>
> Help build regulatory domains out of arbitrary custom
> regulatory definitions and to also allow us to build
> more thorough world regulatory domains that have passive
> scan flags on regulatory rules that are do not fit the
> intersection.
>
> Luis R. Rodriguez (40):
>   crda: make reg_rules_intersect() style match Linux
>   crda: port over Linux is_valid_reg_rule() change bd05f28e
>   crda: remove verbose errors out of regdom_intersect()
>   crda: constify usage of struct ieee80211_regdomain
>   crda: remove unused BUG_ON() from intersect.c
>   crda: move regdom_intersect() to reglib
>   crda: fix regression when using reglib_for_each_country()
>   crda: move intersection if first attempt failed
>   crda: do not double count on reglib_for_each_country()
>   crda: annotate intersection worst case scenerio
>   crda: fix intersect.c memory management
>   crda: explicitly munmap() on reglib_get_rd_alpha2()
>   crda: explicitly close file descriptor and munmap() on failures
>   crda: separate crda_verify_db_signature() implementations
>   crda: use gcry_sexp_release() on crda_verify_db_signature()
>   crda: explicitly use close() and munmap() on reglib_get_rd_alpha2()
>   crda: use gcry_mpi_release() when using gcry_mpi_scan()
>   crda: rename world and prev_world on intersect.c
>   crda: remove verbosity out of intersect.c
>   crda: rename regdom_intersect() to reglib_intersect_rds()
>   crda: rename crda_get_file_ptr() to reglib_get_file_ptr()
>   crda: rename crda_verify_db_signature() to
>     reglib_verify_db_signature()
>   crda: rename print_regdom() to reglib_print_regdom()
>   crda: add regdb_dfs_regions
>   crda: make print-regdom use internal flags
>   crda: move reg print helpers to reglib
>   crda: rename is_world_regdom() to reglib_is_world_regdom()
>   crda: rename isalpha_upper() to reglib_isalpha_upper()
>   crda: rename is_alpha2() to reglib_is_alpha2()
>   crda: rename is_valid_regdom() to reglib_is_valid_regdom()
>   crda: rename max() to reglib_max()
>   crda: rename min() to reglib_min()
>   crda: fix spacing on reglib_for_each_country()
>   crda: clarify intersect.c only computes an intersection
>   crda: separate intersecting a full db into a helper
>   crda: move reglib_intersect_regdb() to reglib
>   crda: move regdbprint to its own helper
>   crda: add reglib regdb context helpers:
>     reglib_(malloc|free)_regdb_ctx()
>   crda: pass struct reglib_regdb_ctx to country2rd()
>   crda: make reglib_for_each_country() use the reglib context
>
>  Makefile       |    4 +-
>  crda.c         |   14 +-
>  intersect.c    |  264 ++---------------------------
>  print-regdom.c |   81 ---------
>  regdb.h        |   24 ++-
>  regdbdump.c    |   30 +++-
>  reglib.c       |  518 +++++++++++++++++++++++++++++++++++++++++++++-----------
>  reglib.h       |  125 +++++++++++---
>  8 files changed, 589 insertions(+), 471 deletions(-)
>  delete mode 100644 print-regdom.c

I've applied and pushed these given I saw no opposition. Please let me
know if you run into any issues. I may cut a new release soon but I
have a few other ideas I was considering implementing.

  Luis
