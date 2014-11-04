Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41474 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaKDJDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 04:03:13 -0500
Received: by mail-wi0-f171.google.com with SMTP id q5so8711212wiv.16
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 01:03:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415090436-12588-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1415090436-12588-1-git-send-email-emmanuel.grumbach@intel.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 4 Nov 2014 14:32:51 +0530
Message-ID: <CABPxzYKfoO+NYi7Zs+5t6mRU+XwW5u=dKiBMsrzZ5VLO3ABDAg@mail.gmail.com> (sfid-20141104_100321_204993_EAED9E95)
Subject: Re: [PATCH] mac80211: Increase uapsd max SP frames number
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 4, 2014 at 2:10 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
>
> Deliver up to 128 frames during SP instead of 8 if unlimited max SP
> is specified during association.
>
> Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/sta_info.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index de494df..3352741 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -1531,7 +1531,7 @@ void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta)
>                 break;
>         case 0:
>                 /* XXX: what is a good value? */
> -               n_frames = 8;
> +               n_frames = 128;
>                 break;
>         }
What is criteria for deciding the threshold?
Any specific use case for 128?
