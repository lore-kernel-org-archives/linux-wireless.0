Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1KHPco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 10:32:44 -0500
Subject: Re: [PATCH v3 2/3] nl80211: Pass probe response data to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1320762928-6782-2-git-send-email-arik@wizery.com> (sfid-20111108_153608_442677_579C7A50)
References: <1320762928-6782-1-git-send-email-arik@wizery.com>
	 <1320762928-6782-2-git-send-email-arik@wizery.com>
	 (sfid-20111108_153608_442677_579C7A50)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:32:40 +0100
Message-ID: <1320766360.24797.5.camel@jlt3.sipsolutions.net> (sfid-20111108_163247_180589_F48760F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 16:35 +0200, Arik Nemtsov wrote:
> Pass probe-response data from usermode via beacon parameters.
> 
> Signed-off-by: Guy Eilam <guy@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> v1->3:
> Set the probe response data as part of the addset_beacon function, instead
> of set_bss. This makes more sense since the probe response is always
> updated with the beacon.
> 
> include/linux/nl80211.h |    4 ++++
>  include/net/cfg80211.h  |    4 ++++
>  net/wireless/nl80211.c  |    9 +++++++++
>  3 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index e74afc4..3fa03b3 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1114,6 +1114,8 @@ enum nl80211_commands {
>   *	In addition this attribute holds a bitmap of the supported protocols
>   *	for offloading using &enum nl80211_probe_resp_offload_support_attr.
>   *
> + * @NL80211_ATTR_PROBE_RESP: Probe Response template data
> + *

That should say what kind of data is expected -- I think a full frame in
this case? Should it really be a full frame though? Maybe ath6kl
requires something else and we can make this somehow compatible with
both?

johannes

