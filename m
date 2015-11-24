Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35260 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbbKXVnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 16:43:04 -0500
Received: by igl9 with SMTP id 9so82033390igl.0
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2015 13:43:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448386927-25170-1-git-send-email-sven@open-mesh.com>
References: <1448386927-25170-1-git-send-email-sven@open-mesh.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 25 Nov 2015 08:42:44 +1100
Message-ID: <CAGRGNgUzFuK=r4HTtC0VkBc-5rLEHA99GB3VuyA6T7Ch6nr2kw@mail.gmail.com> (sfid-20151124_224309_591775_EC7871AE)
Subject: Re: iw: add VHT80 support for 802.11s
To: Sven Eckelmann <sven@open-mesh.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven,

On Wed, Nov 25, 2015 at 4:42 AM, Sven Eckelmann <sven@open-mesh.com> wrote:
> iw mesh supports non-HT and HT channel widths like HT20 or NOHT. But the
> Linux 802.11s implementation also supports VHT80 which can be specified
> during the mesh join.
>
>     iw dev mesh0 mesh join "meshnet" freq 5180 80MHz
>
> Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
> ---
>  ibss.c | 33 ---------------------------------
>  iw.h   |  9 +++++++++
>  mesh.c | 16 ++++++++--------
>  util.c | 26 ++++++++++++++++++++++++++
>  4 files changed, 43 insertions(+), 41 deletions(-)
>
> diff --git a/mesh.c b/mesh.c
> index 0090530..930d58f 100644
> --- a/mesh.c
> +++ b/mesh.c
> @@ -439,12 +439,8 @@ static int join_mesh(struct nl80211_state *state,
>         int bintval, dtim_period, i, n_rates = 0;
>         char *end, *value = NULL, *sptr = NULL;
>         unsigned long freq = 0;
> -       static const struct {
> -               const char *name;
> -               unsigned int width;
> -               int freq1_diff;
> -               int chantype; /* for older kernel */
> -       } *chanmode_selected = NULL, chanmode[] = {
> +       const struct chanmode *chanmode_selected = NULL;
> +       static const struct chanmode chanmode[] = {

You might want to make this change in a separate patch.

>                 { .name = "HT20",
>                   .width = NL80211_CHAN_WIDTH_20,
>                   .freq1_diff = 0,
> @@ -599,7 +599,7 @@ static int join_mesh(struct nl80211_state *state,
>   nla_put_failure:
>         return -ENOBUFS;
>  }
> -COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT>]"
> +COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT|80MHz>]"

Should NOHT remain last in the list?

>         " [basic-rates <rate in Mbps,rate2,...>]], [mcast-rate <rate in Mbps>]"
>         " [beacon-interval <time in TUs>] [dtim-period <value>]"
>         " [vendor_sync on|off] [<param>=<value>]*",

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
