Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2A1EjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 23:39:00 -0500
Message-ID: <4F237BC3.3060208@sipsolutions.net> (sfid-20120128_053905_379573_415D1D17)
Date: Fri, 27 Jan 2012 20:38:27 -0800
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Do not encrypt EAPOL frames in IBSS Mode.
References: <1327581742-15460-1-git-send-email-cavallar@lri.fr> (sfid-20120126_134252_162490_7A6AB3DA)
In-Reply-To: <1327581742-15460-1-git-send-email-cavallar@lri.fr> (sfid-20120126_134252_162490_7A6AB3DA)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2012 4:42 AM, Nicolas Cavallari wrote:
> Currently, EAPOL Frames in IBSS mode are encrypted if a PTK
> is available.  This patch turn off encryption for all EAPOL
> frames when on IBSS mode, as there is no suitable userspace
> calls to configure the control port protocol and settings.
>
> IBSS RSN sort-of worked without this patch because PTKs
> are only installed after the completion of a successful
> EAPOL exchange,  so unicast operations would work,  but
> multicast and rekeying would often fail.
>
> Signed-off-by: Nicolas Cavallari<cavallar@lri.fr>
> ---
>   net/mac80211/ibss.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index bed30ba..9d8e699 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -1022,6 +1022,8 @@ void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
>   {
>   	struct ieee80211_if_ibss *ifibss =&sdata->u.ibss;
>
> +	sdata->control_port_no_encrypt = true;

In addition to my earlier comment about this being totally wrong -- if 
you REALLY wanted it, you should probably just add the few API tweaks to 
be able to set it from userspace and tweak your userspace.

johannes
