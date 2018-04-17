Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36761 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753125AbeDQMLD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 08:11:03 -0400
Received: by mail-wr0-f195.google.com with SMTP id q13so31427280wre.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2018 05:11:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: don't WARN on bad WMM parameters from buggy APs
Date: Tue, 17 Apr 2018 14:11:00 +0200
Message-ID: <50803899.jTqZALSPQ5@debian64> (sfid-20180417_141118_495845_BEE90DEC)
In-Reply-To: <20180326132104.26709-1-emmanuel.grumbach@intel.com>
References: <20180326132104.26709-1-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Monday, 26. March 2018 15:21:04 CEST Emmanuel Grumbach wrote:
> Apparently, some APs are buggy enough to send a zeroed
> WMM IE. Don't WARN on this since this is not caused by a bug
> on the client's system.
> 
> This aligns the condition of the WARNING in drv_conf_tx
> with the validity check in ieee80211_sta_wmm_params.
> We will now pick the default values whenever we get
> a zeroed WMM IE.
> 
> This has been reported here:
> https://bugzilla.kernel.org/show_bug.cgi?id=199161
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/mlme.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 39b660b9a908..a6b628964b84 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1785,7 +1785,8 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
>  		params[ac].acm = acm;
>  		params[ac].uapsd = uapsd;
>  
> -		if (params[ac].cw_min > params[ac].cw_max) {
> +		if (params->cw_min == 0 ||
I'm getting:
[  164.503843] wlan0: AP has invalid WMM params (CWmin/max=15/1023 for ACI 0), using defaults

The AP is running a recent OpenWrt and is using hostapd 2.7.

iw says the AP has the following WMM IE:
        Extended capabilities: Extended Channel Switching, SSID List, 6
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec

which looks reasonable.

What seems to be happening is that the code now expects to start
with ac = 0.

802.11-2012's Figure 8-192 EDCA Parameter Set element lists the AC_BE as the
first element in the IE and because of this ac variable gets set to 
IEEE80211_AC_BE [1] in the first round. This would be fine, if 
IEEE80211_AC_BE was 0, but it is 2 [2].

Should this be params[ac].cw_min? or params[aci].cw_min?
Or should the params->cw_min check be placed after the loop?
Can you please sent a fix? Thanks.

Regards,
Christian

[1] <https://elixir.bootlin.com/linux/v4.17-rc1/source/net/mac80211/mlme.c#L1768>
[2] <https://elixir.bootlin.com/linux/v4.17-rc1/source/include/net/mac80211.h#L148>
