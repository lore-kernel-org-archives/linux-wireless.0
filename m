Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:20238 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYJ1LbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 07:31:14 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2655892rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 04:31:13 -0700 (PDT)
Message-ID: <1ba2fa240810280431m21080a96i7655e67769cb1579@mail.gmail.com> (sfid-20081028_123121_352038_AF941CD5)
Date: Tue, 28 Oct 2008 13:31:13 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: print reason code for deauth/dissoc frames
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225180711-5204-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225180711-5204-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 9:58 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> The patch prints reason code for deauth/dissoc frames to give users
> more ideas what's happened for the disconnection.

Do anyone has idea how to push it to the user space?
We already use ieee80211_sta_send_apinfo (SIOCGIWAP) for notification.
Can be reason code attached without breaking user space?  The
iwreq_data it self has enough space to add this and this can be queued
at the end.

struct {
 sockaddr ap_addr; /** 0 address means association failed (Xeros
address dilemma)
 __u16 reason_code /** IEEE reason code */
 __u16 status_code /** IEEE reason code */
__u32 internal_reason /* mac80211/driver crashed/it's raining/too etc */
};


Thanks
Tomas


>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  net/mac80211/mlme.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index d5006b2..0752e09 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1134,7 +1134,8 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
>        reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
>
>        if (ifsta->flags & IEEE80211_STA_AUTHENTICATED)
> -               printk(KERN_DEBUG "%s: deauthenticated\n", sdata->dev->name);
> +               printk(KERN_DEBUG "%s: deauthenticated (Reason: %u)\n",
> +                               sdata->dev->name, reason_code);
>
>        if (ifsta->state == IEEE80211_STA_MLME_AUTHENTICATE ||
>            ifsta->state == IEEE80211_STA_MLME_ASSOCIATE ||
> @@ -1166,7 +1167,8 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
>        reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
>
>        if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
> -               printk(KERN_DEBUG "%s: disassociated\n", sdata->dev->name);
> +               printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",
> +                               sdata->dev->name, reason_code);
>
>        if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED) {
>                ifsta->state = IEEE80211_STA_MLME_ASSOCIATE;
> --
> 1.5.3.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
