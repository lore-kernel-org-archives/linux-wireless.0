Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53846 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2GXDLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 23:11:54 -0400
Received: by bkwj10 with SMTP id j10so5883420bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 20:11:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343092554-17734-1-git-send-email-yeohchunyeow@gmail.com>
References: <1343092554-17734-1-git-send-email-yeohchunyeow@gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 23 Jul 2012 20:11:32 -0700
Message-ID: <CAG6hwVNnqTBi10vGsjYqYBOedtaThjyJuRt6o=XpZF_dRaqQsA@mail.gmail.com> (sfid-20120724_051157_664352_271B923E)
Subject: Re: [PATCH v3] mac80211: add extra checking for RC init upon
 receiving mesh beacon
To: devel@lists.open80211s.org
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow,

On Mon, Jul 23, 2012 at 6:15 PM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Rate control statistic is flushed whenever the mesh beacon
> is received. This may not optimizes the performance of rate
> control algorithm. This patch ensures that we return early
> from mesh_peer_init if the plink_state is ESTAB. Thus, avoid
> calling the rate_control_rate_init again for established mesh
> STA.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
> v2: simplify the logic checking (Thomas Pedersen)
> v3: updating the sta last rx activity (Thomas Pedersen)
>
>  net/mac80211/mesh_plink.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index 4256859..4f5740e 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -360,6 +360,12 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
>         }
>
>         spin_lock_bh(&sta->lock);
> +       if (sta->plink_state == NL80211_PLINK_ESTAB) {
> +               sta->last_rx = jiffies;
> +               spin_unlock_bh(&sta->lock);
> +               return sta;
> +       }
> +
>         sta->last_rx = jiffies;

You should avoid duplicating this assignment.

Thomas
