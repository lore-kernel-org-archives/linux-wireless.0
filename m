Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:47584 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaAONHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:07:38 -0500
Message-ID: <1389791254.8062.25.camel@porter.coelho.fi> (sfid-20140115_140741_536974_E2950523)
Subject: Re: [RFC 2/9] mac80211: treat IBSS CSA finish failure seriously
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Wed, 15 Jan 2014 15:07:34 +0200
In-Reply-To: <1389787494-7361-3-git-send-email-michal.kazior@tieto.com>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	 <1389787494-7361-3-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
> Other interface modes are checked against failure.
> This should avoid false-positive channel switch
> events where IBSS CSA actually failed.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/mac80211/cfg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 8c78572..2ab5f49 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -3040,7 +3040,9 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
>  			goto unlock;
>  		break;
>  	case NL80211_IFTYPE_ADHOC:
> -		ieee80211_ibss_finish_csa(sdata);
> +		err = ieee80211_ibss_finish_csa(sdata);
> +		if (err < 0)
> +			goto unlock;
>  		break;
>  #ifdef CONFIG_MAC80211_MESH
>  	case NL80211_IFTYPE_MESH_POINT:

This makes sense, but there have been lots of changes in this code that
Johannes just applied on mac80211-next.git.  Maybe it would be better to
rebase your patches on top of mac80211-next or wait until they get into
wireless-testing?

--
Luca.

