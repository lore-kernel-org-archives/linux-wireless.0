Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:48088 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3GQBb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 21:31:59 -0400
Received: by mail-lb0-f180.google.com with SMTP id o10so1131439lbi.11
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 18:31:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372636171.5155.56.camel@deadeye.wl.decadent.org.uk>
References: <1372636171.5155.56.camel@deadeye.wl.decadent.org.uk>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 16 Jul 2013 18:31:36 -0700
Message-ID: <CAB=NE6Vz_3d9Vz62dNTWocT3MTqvG4Ez+MZc0w-w8KBgkaapxg@mail.gmail.com> (sfid-20130717_033203_293005_C627D46F)
Subject: Re: [PATCH] reglib: Validate all structure and array lengths
To: Ben Hutchings <ben@decadent.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>, alexandre <alexandre@cmu.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 30, 2013 at 4:49 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> Add checks that:
> - Signature length does not exceed the file length (this was already
>   checked, but did not account for signature lengths greater than 2 GB)
> - Database length is long enough for all structures we expect in it
> - Array length calculations will not overflow
>
> To keep these checks simple, change the types of array length and index
> variables to unsigned int (must be at least 32-bit, matching the file
> format) and the types of byte-length variables to size_t.
>
> Alexandre Rebert <alexandre@cmu.edu> reported and provided a test case
> for the signature length issue; the others I found by inspection.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Thanks! Despite the fact you didn't resend for a wider review and I
would have preferred this split up into a few patches this has been
sitting on wireless-regdb for a while, so after my review I just
applied and pushed. Thanks again!

  Luis

> ---
>  reglib.c | 58 +++++++++++++++++++++++++++++++++++++++++-----------------
>  reglib.h |  5 +++--
>  2 files changed, 44 insertions(+), 19 deletions(-)
>
> diff --git a/reglib.c b/reglib.c
> index c4d00f8..224821b 100644
> --- a/reglib.c
> +++ b/reglib.c
> @@ -10,6 +10,7 @@
>  #include <stdbool.h>
>  #include <unistd.h>
>  #include <string.h>
> +#include <limits.h>
>
>  #include <arpa/inet.h> /* ntohl */
>
> @@ -37,10 +38,16 @@
>  #include "keys-gcrypt.c"
>  #endif
>
> -void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr)
> +void *
> +reglib_get_file_ptr(uint8_t *db, size_t dblen, size_t structlen, uint32_t ptr)
>  {
>         uint32_t p = ntohl(ptr);
>
> +       if (structlen > dblen) {
> +               fprintf(stderr, "Invalid database file, too short!\n");
> +               exit(3);
> +       }
> +
>         if (p > dblen - structlen) {
>                 fprintf(stderr, "Invalid database file, bad pointer!\n");
>                 exit(3);
> @@ -49,6 +56,17 @@ void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr)
>         return (void *)(db + p);
>  }
>
> +static size_t
> +reglib_array_len(size_t baselen, unsigned int elemcount, size_t elemlen)
> +{
> +       if (elemcount > (SIZE_MAX - baselen) / elemlen) {
> +               fprintf(stderr, "Invalid database file, count too large!\n");
> +               exit(3);
> +       }
> +
> +       return baselen + elemcount * elemlen;
> +}
> +
>  /*
>   * reglib_verify_db_signature():
>   *
> @@ -59,7 +77,7 @@ void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr)
>   */
>
>  #ifdef USE_OPENSSL
> -int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen)
> +int reglib_verify_db_signature(uint8_t *db, size_t dblen, size_t siglen)
>  {
>         RSA *rsa;
>         uint8_t hash[SHA_DIGEST_LENGTH];
> @@ -118,7 +136,7 @@ out:
>  #endif /* USE_OPENSSL */
>
>  #ifdef USE_GCRYPT
> -int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen)
> +int reglib_verify_db_signature(uint8_t *db, size_t dblen, size_t siglen)
>  {
>         gcry_mpi_t mpi_e, mpi_n;
>         gcry_sexp_t rsa, signature, data;
> @@ -180,7 +198,7 @@ out:
>  #endif /* USE_GCRYPT */
>
>  #if !defined(USE_OPENSSL) && !defined(USE_GCRYPT)
> -int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen)
> +int reglib_verify_db_signature(uint8_t *db, size_t dblen, size_t siglen)
>  {
>         return 1;
>  }
> @@ -220,7 +238,7 @@ const struct reglib_regdb_ctx *reglib_malloc_regdb_ctx(const char *regdb_file)
>                 return NULL;
>         }
>
> -       ctx->header = reglib_get_file_ptr(ctx->db, ctx->dblen,
> +       ctx->header = reglib_get_file_ptr(ctx->db, ctx->real_dblen,
>                                           sizeof(struct regdb_file_header),
>                                           0);
>         header = ctx->header;
> @@ -232,12 +250,13 @@ const struct reglib_regdb_ctx *reglib_malloc_regdb_ctx(const char *regdb_file)
>                 goto err_out;
>
>         ctx->siglen = ntohl(header->signature_length);
> -       /* The actual dblen does not take into account the signature */
> -       ctx->dblen = ctx->real_dblen - ctx->siglen;
>
> -       if (ctx->dblen <= sizeof(*header))
> +       if (ctx->siglen > ctx->real_dblen - sizeof(*header))
>                 goto err_out;
>
> +       /* The actual dblen does not take into account the signature */
> +       ctx->dblen = ctx->real_dblen - ctx->siglen;
> +
>         /* verify signature */
>         if (!reglib_verify_db_signature(ctx->db, ctx->dblen, ctx->siglen))
>                 goto err_out;
> @@ -272,7 +291,7 @@ void reglib_free_regdb_ctx(const struct reglib_regdb_ctx *regdb_ctx)
>         free(ctx);
>  }
>
> -static void reg_rule2rd(uint8_t *db, int dblen,
> +static void reg_rule2rd(uint8_t *db, size_t dblen,
>         uint32_t ruleptr, struct ieee80211_reg_rule *rd_reg_rule)
>  {
>         struct regdb_file_reg_rule *rule;
> @@ -303,18 +322,21 @@ country2rd(const struct reglib_regdb_ctx *ctx,
>  {
>         struct regdb_file_reg_rules_collection *rcoll;
>         struct ieee80211_regdomain *rd;
> -       int i, num_rules, size_of_rd;
> +       unsigned int i, num_rules;
> +       size_t size_of_rd;
>
>         rcoll = reglib_get_file_ptr(ctx->db, ctx->dblen, sizeof(*rcoll),
>                                     country->reg_collection_ptr);
>         num_rules = ntohl(rcoll->reg_rule_num);
>         /* re-get pointer with sanity checking for num_rules */
>         rcoll = reglib_get_file_ptr(ctx->db, ctx->dblen,
> -                       sizeof(*rcoll) + num_rules * sizeof(uint32_t),
> -                       country->reg_collection_ptr);
> +                                   reglib_array_len(sizeof(*rcoll), num_rules,
> +                                                    sizeof(uint32_t)),
> +                                   country->reg_collection_ptr);
>
> -       size_of_rd = sizeof(struct ieee80211_regdomain) +
> -               num_rules * sizeof(struct ieee80211_reg_rule);
> +       size_of_rd = reglib_array_len(sizeof(struct ieee80211_regdomain),
> +                                     num_rules,
> +                                     sizeof(struct ieee80211_reg_rule));
>
>         rd = malloc(size_of_rd);
>         if (!rd)
> @@ -468,7 +490,8 @@ struct ieee80211_regdomain *
>  reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
>                      const struct ieee80211_regdomain *rd2)
>  {
> -       int r, size_of_regd;
> +       int r;
> +       size_t size_of_regd;
>         unsigned int x, y;
>         unsigned int num_rules = 0, rule_idx = 0;
>         const struct ieee80211_reg_rule *rule1, *rule2;
> @@ -506,8 +529,9 @@ reglib_intersect_rds(const struct ieee80211_regdomain *rd1,
>         if (!num_rules)
>                 return NULL;
>
> -       size_of_regd = sizeof(struct ieee80211_regdomain) +
> -               ((num_rules + 1) * sizeof(struct ieee80211_reg_rule));
> +       size_of_regd = reglib_array_len(sizeof(struct ieee80211_regdomain),
> +                                       num_rules + 1,
> +                                       sizeof(struct ieee80211_reg_rule));
>
>         rd = malloc(size_of_regd);
>         if (!rd)
> diff --git a/reglib.h b/reglib.h
> index 86087e3..57082fe 100644
> --- a/reglib.h
> +++ b/reglib.h
> @@ -112,8 +112,9 @@ static inline uint32_t reglib_min(uint32_t a, uint32_t b)
>         return (a > b) ? b : a;
>  }
>
> -void *reglib_get_file_ptr(uint8_t *db, int dblen, int structlen, uint32_t ptr);
> -int reglib_verify_db_signature(uint8_t *db, int dblen, int siglen);
> +void *
> +reglib_get_file_ptr(uint8_t *db, size_t dblen, size_t structlen, uint32_t ptr);
> +int reglib_verify_db_signature(uint8_t *db, size_t dblen, size_t siglen);
>
>  /**
>   * reglib_malloc_regdb_ctx - create a regdb context for usage with reglib
>
