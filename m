Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57391 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbbAME0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 23:26:34 -0500
Received: by mail-wg0-f45.google.com with SMTP id y19so664508wgg.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 20:26:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420642040-4530-2-git-send-email-arik@wizery.com>
References: <1420642040-4530-1-git-send-email-arik@wizery.com> <1420642040-4530-2-git-send-email-arik@wizery.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 13 Jan 2015 15:26:13 +1100
Message-ID: <CAGRGNgV1EeZ9Qz995wTqs6CnKmbhu1OTob3_k1h4mKYW1Oh7tw@mail.gmail.com> (sfid-20150113_052638_795968_D4AF3CD1)
Subject: Re: [PATCH v2 2/2] cfg80211: avoid reg-hints in self-managed only systems
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arik,

On Thu, Jan 8, 2015 at 1:47 AM, Arik Nemtsov <arik@wizery.com> wrote:
> When a system contains only self-managed regulatory devices all hints
> from the regulatory core are ignored. Stop hint processing early in this
> case. These systems usually don't have CRDA deployed, which results in
> endless (irrelevent) logs of the form:
> cfg80211: Calling CRDA to update world regulatory domain
>
> Make sure there's at least one self-managed device before discarding a
> hint, in order to prevent initial hints from disappearing on CRDA
> managed systems.
>
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> ---
>  net/wireless/reg.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 521f3a4..588e45f 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2120,6 +2120,26 @@ out_free:
>         reg_free_request(reg_request);
>  }
>
> +static bool reg_only_self_managed_wiphys(void)
> +{
> +       struct cfg80211_registered_device *rdev;
> +       struct wiphy *wiphy;
> +       bool self_managed_found = false;
> +
> +       ASSERT_RTNL();

Would it make sense to quickly return false here if the list is empty
rather than the whole mess with the new variable?

> +
> +       list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> +               wiphy = &rdev->wiphy;
> +               if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
> +                       self_managed_found = true;
> +               else
> +                       return false;
> +       }
> +
> +       /* make sure at least one self-managed wiphy exists */
> +       return self_managed_found;
> +}
> +
>  /*
>   * Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_*
>   * Regulatory hints come on a first come first serve basis and we

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
