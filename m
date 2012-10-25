Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33359 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992579Ab2JYUVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 16:21:14 -0400
Received: by mail-wg0-f42.google.com with SMTP id fm10so53631wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 13:21:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351196340-30551-1-git-send-email-johannes@sipsolutions.net>
References: <1351196340-30551-1-git-send-email-johannes@sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 25 Oct 2012 13:20:53 -0700
Message-ID: <CAPjQAd8OEDa1Yqs1Aybn+eDS=1Sv81qfUUczMpF9veP5Z1U3ow@mail.gmail.com> (sfid-20121025_222117_557181_2A50E40E)
Subject: Re: [PATCH v2] wireless: drop invalid mesh address extension frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 25, 2012 at 1:19 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The mesh header can have address extension by a 4th
> or a 5th and 6th address, but never both. Drop such
> frames in 802.11 -> 802.3 conversion along with any
> frames that have the wrong extension.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Javier Cardona <javier@cozybit.com>

> ---
>  net/wireless/util.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index ef35f4e..387d6dc 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -312,18 +312,15 @@ EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
>  static int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
>  {
>         int ae = meshhdr->flags & MESH_FLAGS_AE;
> -       /* 7.1.3.5a.2 */
> +       /* IEEE 802.11 - 8.2.4.7.3 */
>         switch (ae) {
> +       default:
>         case 0:
>                 return 6;
>         case MESH_FLAGS_AE_A4:
>                 return 12;
>         case MESH_FLAGS_AE_A5_A6:
>                 return 18;
> -       case (MESH_FLAGS_AE_A4 | MESH_FLAGS_AE_A5_A6):
> -               return 24;
> -       default:
> -               return 6;
>         }
>  }
>
> @@ -373,6 +370,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
>                         /* make sure meshdr->flags is on the linear part */
>                         if (!pskb_may_pull(skb, hdrlen + 1))
>                                 return -1;
> +                       if (meshdr->flags & MESH_FLAGS_AE_A4)
> +                               return -1;
>                         if (meshdr->flags & MESH_FLAGS_AE_A5_A6) {
>                                 skb_copy_bits(skb, hdrlen +
>                                         offsetof(struct ieee80211s_hdr, eaddr1),
> @@ -397,6 +396,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
>                         /* make sure meshdr->flags is on the linear part */
>                         if (!pskb_may_pull(skb, hdrlen + 1))
>                                 return -1;
> +                       if (meshdr->flags & MESH_FLAGS_AE_A5_A6)
> +                               return -1;
>                         if (meshdr->flags & MESH_FLAGS_AE_A4)
>                                 skb_copy_bits(skb, hdrlen +
>                                         offsetof(struct ieee80211s_hdr, eaddr1),
> --
> 1.7.10.4
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
