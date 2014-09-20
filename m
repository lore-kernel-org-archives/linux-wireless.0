Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:40952 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaITBTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2014 21:19:18 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so517309wes.27
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2014 18:19:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411093476-15685-2-git-send-email-yeohchunyeow@gmail.com>
References: <1411093476-15685-1-git-send-email-yeohchunyeow@gmail.com>
	<1411093476-15685-2-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 19 Sep 2014 18:19:16 -0700
Message-ID: <CANrMYP4+atK9g+cfU5VYKjAuT31COVSXAkqTswZn0E2QEv5JDA@mail.gmail.com> (sfid-20140920_031922_637469_88F16DE8)
Subject: Re: [PATCH v2 2/2] iw: Allow basic rates to be configured when
 joining mesh
From: Colleen T <colleen@cozybit.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>, devel@lists.open80211s.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ashok Nagarajan <ashok.dragon@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2014 at 7:24 PM, Chun-Yeow Yeoh via Devel
<devel@lists.open80211s.org> wrote:
> This patch adds option to configure basic rates during mesh join.
>
> Signed-off-by: Ashok Nagarajan <ashok.dragon@gmail.com>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>
> v2: minor change for upstream
> ---
>  mesh.c | 40 ++++++++++++++++++++++++++++++++++------
>  1 file changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/mesh.c b/mesh.c
> index 69c54cc..b21a302 100644
> --- a/mesh.c
> +++ b/mesh.c
> @@ -438,8 +438,9 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
>  {
>         struct nlattr *container;
>         float rate;
> -       int bintval, dtim_period, i;
> -       char *end;
> +       unsigned char rates[NL80211_MAX_SUPP_RATES];
> +       int bintval, dtim_period, i, n_rates = 0;
> +       char *end, *value = NULL, *sptr = NULL;
>         unsigned long freq = 0;
>         static const struct {
>                 const char *name;
> @@ -510,6 +511,32 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
>                 }
>         }
>
> +       /* basic rates */
> +       if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {
> +               argv++;
> +               argc--;
> +
> +               value = strtok_r(argv[0], ",", &sptr);
> +
> +               while (value && n_rates < NL80211_MAX_SUPP_RATES) {
> +                       rate = strtod(value, &end);
> +                       rates[n_rates] = rate * 2;
> +
> +                       /* filter out suspicious values  */
> +                       if (*end != '\0' || !rates[n_rates] ||
> +                           rate*2 != rates[n_rates])
> +                               return 1;
> +
> +                       n_rates++;
> +                       value = strtok_r(NULL, ",", &sptr);
> +               }
> +
> +               NLA_PUT(msg, NL80211_ATTR_BSS_BASIC_RATES, n_rates, rates);
> +               argv++;
> +               argc--;
> +       }
> +
> +       /* multicast rate */
>         if (argc > 1 && strcmp(argv[0], "mcast-rate") == 0) {
>                 argv++;
>                 argc--;
> @@ -575,13 +602,14 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
>   nla_put_failure:
>         return -ENOBUFS;
>  }
> -COMMAND(mesh, join, "<mesh ID> [freq in MHz] [HT20|HT40+|HT40-|NOHT]"
> -       " [mcast-rate <rate in Mbps>]"
> +COMMAND(mesh, join, "<mesh ID> [freq in MHz [HT20|HT40+|HT40-|NOHT]"
> +       " [basic-rates <rate in Mbps,rate2,...>]], [mcast-rate <rate in Mbps>]"
>         " [beacon-interval <time in TUs>] [dtim-period <value>]"
>         " [vendor_sync on|off] [<param>=<value>]*",
>         NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
> -       "Join a mesh with the given mesh ID with frequency, mcast-rate, "
> -       "and mesh parameters.");
> +       "Join a mesh with the given mesh ID with frequency, basic-rates,\n"
> +       "mcast-rate and mesh parameters. basic-rates are be applied only if\n"
> +       "frequency is provided.");

I think you have a typo here.  Remove "be"?

>  static int leave_mesh(struct nl80211_state *state, struct nl_cb *cb,
>                       struct nl_msg *msg, int argc, char **argv,
> --
> 1.9.2
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel

- Colleen
