Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:45794 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1K1Vo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:44:57 -0500
MIME-Version: 1.0
In-Reply-To: <1322515870-3392-2-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322515870-3392-1-git-send-email-mcgrof@qca.qualcomm.com> <1322515870-3392-2-git-send-email-mcgrof@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 28 Nov 2011 16:44:35 -0500
Message-ID: <CAB=NE6Wr0uNkyyZTxM_sOLn=Bqj_As=Hv+yPNqggTwU6hg1HYQ@mail.gmail.com> (sfid-20111128_224519_429258_1FFCD2C8)
Subject: Re: [PATCH v2 1/2] cfg80211: fix race on init and driver registration
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 28, 2011 at 4:31 PM, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:

> @@ -1823,6 +1837,10 @@ static void restore_regulatory_settings(bool reset_user)
>        /* First restore to the basic regulatory settings */
>        cfg80211_regdomain = cfg80211_world_regdom;
>
> +       if (last_request != &core_request_world)
> +               kfree(last_request);
> +       last_request = &core_request_world;
> +
>        mutex_unlock(&reg_mutex);
>        mutex_unlock(&cfg80211_mutex);
>

This hunk is redundant given that we call reset_regdomains() above,
will send a v3..

  Luis
