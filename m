Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34466 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2GTRUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2012 13:20:15 -0400
Received: by bkwj10 with SMTP id j10so3625966bkw.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2012 10:20:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342787764-26858-1-git-send-email-yeohchunyeow@gmail.com>
References: <1342787764-26858-1-git-send-email-yeohchunyeow@gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 20 Jul 2012 10:19:53 -0700
Message-ID: <CAG6hwVN7meRB2AH3Go1x-PhfXNygsq=xqKxhZ4nsJxG_b0vycw@mail.gmail.com> (sfid-20120720_192020_960226_AF160AD0)
Subject: Re: [PATCH] mac80211: add extra checking for RC init upon receiving
 mesh beacon
To: devel@lists.open80211s.org
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chun-Yeow,

On Fri, Jul 20, 2012 at 5:36 AM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Rate control statistic is flushed whenever the mesh beacon
> is received.

That's terrible! Thanks for catching this.

> This may not optimizes the performance of rate
> control algorithm. This patch ensures that <rate_control_
> rate_init> is called only if the peer's channel type is
> changed.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  net/mac80211/mesh_plink.c |   10 +++++++++-
>  net/mac80211/sta_info.h   |    4 ++++
>  2 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index 4256859..a3fce28 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -357,6 +357,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
>                 if (!sta)
>                         return NULL;
>                 insert = true;
> +               sta->mesh_rate_init = false;
>         }
>
>         spin_lock_bh(&sta->lock);
> @@ -377,9 +378,16 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
>                                             ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>                 sta->ch_type =
>                         ieee80211_ht_oper_to_channel_type(elems->ht_operation);
> +       } else {
> +               sta->ch_type = NL80211_CHAN_NO_HT;
> +       }
> +
> +       if (!sta->mesh_rate_init || sta->pre_ch_type != sta->ch_type) {
> +               rate_control_rate_init(sta);
> +               sta->mesh_rate_init = true;
> +               sta->pre_ch_type = sta->ch_type;
>         }

I think right now there is an assumption that the peer's ch_type and
other capabilities won't change while a peering is established. In
that case, it seems simpler to just return early if sta->plink_state
== NL80211_PLINK_ESTAB. The sta->last_rx should probably still be
updated though.

Thomas
