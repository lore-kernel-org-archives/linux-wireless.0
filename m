Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37531 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab2KWCnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 21:43:03 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so312489wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 18:43:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353635958-12298-1-git-send-email-yeohchunyeow@gmail.com>
References: <1353635958-12298-1-git-send-email-yeohchunyeow@gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 22 Nov 2012 18:42:41 -0800
Message-ID: <CAG6hwVPxVsR2JCEiHSBCho1fwe4igd1q6o9BL_-ei=K8RHXa5g@mail.gmail.com> (sfid-20121123_034307_798319_81818648)
Subject: Re: [PATCH] mac80211: Fix macro definitions in Mesh
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 22, 2012 at 5:59 PM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Macro definitions should be static inlines.

Then maybe this patch should do that as well? :)

> Reported by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  net/mac80211/mesh_hwmp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 47aeee2..5d3e965 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -88,9 +88,9 @@ static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
>         (msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval))
>  #define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
>  #define disc_timeout_jiff(s) \
> -       msecs_to_jiffies(sdata->u.mesh.mshcfg.min_discovery_timeout)
> +       msecs_to_jiffies(s->u.mesh.mshcfg.min_discovery_timeout)
>  #define root_path_confirmation_jiffies(s) \
> -       msecs_to_jiffies(sdata->u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval)
> +       msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval)
>
>  enum mpath_frame_type {
>         MPATH_PREQ = 0,
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
