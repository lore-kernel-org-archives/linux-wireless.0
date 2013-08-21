Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:37197 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3HUA5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 20:57:49 -0400
Received: by mail-we0-f175.google.com with SMTP id n5so51402wev.6
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 17:57:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1376997139-6228-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1376997139-6228-1-git-send-email-emmanuel.grumbach@intel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 21 Aug 2013 10:57:27 +1000
Message-ID: <CAGRGNgVdMKmd6fPi7ugrWUVaSZeU54K+jyT=gLY2tnxvyBPogQ@mail.gmail.com> (sfid-20130821_025752_257376_D4253F8D)
Subject: Re: [RFC 1/2] mac80211: allow APs to send SMPS frames
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

One minor thing I noticed:

On Tue, Aug 20, 2013 at 9:12 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> SMPS code checks all over the place that the vif is
> BSS. Remove that constraint and allow SMPS for AP too.
>
> Provide dummy implementation that will be used for
> further patches.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/cfg.c            |   15 ++++++++++++---
>  net/mac80211/debugfs_netdev.c |   24 +++++++++++++++---------
>  net/mac80211/ht.c             |   38 ++++++++++++++++++++++++++++----------
>  net/mac80211/ieee80211_i.h    |   13 ++++++++++---
>  net/mac80211/iface.c          |    2 ++
>  net/mac80211/mlme.c           |    2 +-
>  6 files changed, 68 insertions(+), 26 deletions(-)
>
> diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> index e601c9f..7609e47 100644
> --- a/net/mac80211/debugfs_netdev.c
> +++ b/net/mac80211/debugfs_netdev.c
> @@ -245,12 +248,15 @@ static const char *smps_modes[IEEE80211_SMPS_NUM_MODES] = {
>  static ssize_t ieee80211_if_fmt_smps(const struct ieee80211_sub_if_data *sdata,
>                                      char *buf, int buflen)
>  {
> -       if (sdata->vif.type != NL80211_IFTYPE_STATION)
> -               return -EOPNOTSUPP;
> -
> -       return snprintf(buf, buflen, "request: %s\nused: %s\n",
> -                       smps_modes[sdata->u.mgd.req_smps],
> -                       smps_modes[sdata->smps_mode]);
> +       if (sdata->vif.type == NL80211_IFTYPE_STATION)
> +               return snprintf(buf, buflen, "request: %s\nused: %s\n",
> +                               smps_modes[sdata->u.mgd.req_smps],
> +                               smps_modes[sdata->smps_mode]);
> +       if (sdata->vif.type == NL80211_IFTYPE_AP)
> +               return snprintf(buf, buflen, "request: %s\nused: %s\n",
> +                               smps_modes[sdata->u.ap.req_smps],
> +                               smps_modes[sdata->smps_mode]);
> +       return -EINVAL;

Do you intend to change the return value for this function when we
can't do SMPS from -EOPNOTSUPP to -EINVAL?

You've also included a couple of other cases where you return -EINVAL.
I'm assuming those are correct.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
