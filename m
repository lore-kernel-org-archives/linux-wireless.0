Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60236 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3LCGvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 01:51:47 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so19540428pdj.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 22:51:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386045985-2398-2-git-send-email-clanctot@codeaurora.org>
References: <1386045985-2398-1-git-send-email-clanctot@codeaurora.org> <1386045985-2398-2-git-send-email-clanctot@codeaurora.org>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 3 Dec 2013 08:51:30 +0200
Message-ID: <CA+XVXfc1ryVcfqsMOc_592iEGYmpP4x3F_w88-10Ky4YG7zZmQ@mail.gmail.com> (sfid-20131203_075150_169768_D387FA76)
Subject: Re: [PATCH 1/2 V2] nl80211/cfg80211: Add support for drivers with AP
 SME that require PMF SA Query assistance
To: Chet Lanctot <clanctot@codeaurora.org>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 3, 2013 at 6:46 AM, Chet Lanctot <clanctot@codeaurora.org> wrote:
> This adds support for drivers that have AP SME integrated but do
> not implement the SA Query procedure that is part of Protected
> Management Frames (PMF, 802.11w).
>
> Instead, hostapd can be used to assist drivers that lack SA Query
> Procedure handling on their own by allowing them to specify this as
> a device capability flag.
>
> Also, a station flag is added to let hostapd indicate to the driver
> that the SA Query procedure is complete and the driver can process
> association requests from the station normally.
[...]
>   * enum nl80211_feature_flags - device/driver features
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 587ff84..14a14d4 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -3766,7 +3766,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
>                                   BIT(NL80211_STA_FLAG_ASSOCIATED) |
>                                   BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
>                                   BIT(NL80211_STA_FLAG_WME) |
> -                                 BIT(NL80211_STA_FLAG_MFP)))
> +                                 BIT(NL80211_STA_FLAG_MFP) |
> +                                 BIT(NL80211_STA_FLAG_SA_QUERY_REQUIRED)))

I didn't really read the patch, but noticed you're adding
NL80211_STA_FLAG_SA_QUERY_REQUIRED here and changing it to
NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED in the next one.
Pretty sure that's not on purpose :)

Arik
