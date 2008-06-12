Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1665 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYFLIX1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 04:23:27 -0400
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: Make packet injection work in
	iwl3945
From: Zhu Yi <yi.zhu@intel.com>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <69e28c910806111305k6b32390ey1d44d5c2b7639241@mail.gmail.com>
References: <69e28c910806111305k6b32390ey1d44d5c2b7639241@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Date: Thu, 12 Jun 2008 16:23:01 +0800
Message-Id: <1213258981.7814.739.camel@debian.sh.intel.com> (sfid-20080612_102331_750066_2015A90B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-11 at 22:05 +0200, Stefanik G=A8=A2bor wrote:
> -       /* drop all data frame if we are not associated */
> -       if ((!iwl3945_is_associated(priv) ||
> -            ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !
> priv->assoc_id)) &&
> -           ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)=
) {
> -               IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n")=
;
> -               goto drop_unlock;
> -       }
> -

Skip this checking will cause firmware problem for the STA and Ad-hoc
cases. I saw you had some check for "sta_id !=3D
priv->hw_params.bcast_sta_id". Where is it now?

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
