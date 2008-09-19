Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:11967 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYISIEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 04:04:32 -0400
Received: by fk-out-0910.google.com with SMTP id 18so298555fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 01:04:30 -0700 (PDT)
Message-ID: <1ba2fa240809190104t361ea3fcyd9df6a204f6eac00@mail.gmail.com> (sfid-20080919_100437_148784_74732658)
Date: Fri, 19 Sep 2008 11:04:30 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: probe with correct SSID
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221793834.10419.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221793834.10419.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 6:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> While associated, we should probe with the SSID we're associated to,
> not the scan SSID.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/mlme.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- everything.orig/net/mac80211/mlme.c 2008-09-19 01:46:33.000000000 +0200
> +++ everything/net/mac80211/mlme.c      2008-09-19 01:46:47.000000000 +0200
> @@ -973,8 +973,8 @@ static void ieee80211_associated(struct
>                                disassoc = 1;
>                        } else
>                                ieee80211_send_probe_req(sdata, ifsta->bssid,
> -                                                        local->scan_ssid,
> -                                                        local->scan_ssid_len);
> +                                                        ifsta->ssid,
> +                                                        ifsta->ssid_len);
>                        ifsta->flags ^= IEEE80211_STA_PROBEREQ_POLL;
>                } else {
>                        ifsta->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
