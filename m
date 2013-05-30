Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:43198 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3E3SU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 14:20:56 -0400
Received: by mail-we0-f172.google.com with SMTP id w62so547816wes.17
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 11:20:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368233521-10642-1-git-send-email-ashok@cozybit.com>
References: <1368233521-10642-1-git-send-email-ashok@cozybit.com>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Thu, 30 May 2013 11:20:35 -0700
Message-ID: <CACcxo+ruNm9+xch42j08dBG9jR28=TX+spgy83oGkQHNSesL7A@mail.gmail.com> (sfid-20130530_202059_689580_9F5DFDF1)
Subject: Re: [PATCH] iw: Allow basic rates to be configured when joining mesh
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, Ashok Nagarajan <ashok@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I am changing the API for mesh join here as per our recent discussion,
which is to accept basic-rates only when passed the 'freq' attribute.
I was wondering what would be an acceptable style in iw to convey this
to user.

1. mesh join <mesh ID> [freq in MHz [HT20|HT40+|HT40-|NOHT]
[basic-rates <rate in Mbps,rate2,...>]] or
2. mesh join <mesh ID> [freq in MHz] [HT20|HT40+|HT40-|NOHT]
[basic-rates <rate in Mbps,rate2,...>]

Note the nested brackets in style 1.

Please let me know what you think.

Thanks,
Ashok

On Fri, May 10, 2013 at 5:52 PM, Ashok Nagarajan <ashok@cozybit.com> wrote:
> This patch adds option to configure basic rates during mesh join
>
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> ---
>  mesh.c |   37 +++++++++++++++++++++++++++++++++++--
>  1 files changed, 35 insertions(+), 2 deletions(-)
>
> diff --git a/mesh.c b/mesh.c
> index 5a09b62..c6aa9ce 100644
> --- a/mesh.c
> +++ b/mesh.c
> @@ -431,8 +431,11 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
>  {
>         struct nlattr *container;
>         float rate;
> +       unsigned char rates[NL80211_MAX_SUPP_RATES];
> +       int n_rates = 0;
>         int bintval, dtim_period;
>         char *end;
> +       char *value = NULL, *sptr = NULL;
>
>         if (argc < 1)
>                 return 1;
> @@ -441,6 +444,34 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
>         argc--;
>         argv++;
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
> +
> +               argv++;
> +               argc--;
> +       }
> +
> +       /* multicast rate */
> +
>         if (argc > 1 && strcmp(argv[0], "mcast-rate") == 0) {
>                 argv++;
>                 argc--;
> @@ -506,11 +537,13 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
>   nla_put_failure:
>         return -ENOBUFS;
>  }
> -COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>]"
> +COMMAND(mesh, join, "<mesh ID> [basic-rates <rate in Mbps,rate2,...>]"
> +       "[mcast-rate <rate in Mbps>]"
>         " [beacon-interval <time in TUs>] [dtim-period <value>]"
>         " [vendor_sync on|off] [<param>=<value>]*",
>         NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
> -       "Join a mesh with the given mesh ID with mcast-rate and mesh parameters.");
> +       "Join a mesh with the given mesh ID with basic-rates, "
> +       "mcast-rate and mesh parameters.");
>
>  static int leave_mesh(struct nl80211_state *state, struct nl_cb *cb,
>                       struct nl_msg *msg, int argc, char **argv,
> --
> 1.7.5.4
>



-- 
Ashok Raj Nagarajan,
cozybit Inc.
http://www.cozybit.com
