Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61288 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2GaRAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 13:00:53 -0400
Received: by wibhr14 with SMTP id hr14so3110801wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2012 10:00:51 -0700 (PDT)
References: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net> <1343734541-14934-2-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1343734541-14934-2-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <01F94E3A-B132-46B2-9B4E-E2F78135458D@gmail.com> (sfid-20120731_190056_899109_0EBAB7F2)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/3] wireless: add radiotap A-MPDU status field
Date: Tue, 31 Jul 2012 19:00:49 +0200
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 31 jul. 2012, at 13:35, Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Define the A-MPDU status field in radiotap, also
> update the radiotap parser for it and the MCS field
> that was apparently missed last time.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> include/net/ieee80211_radiotap.h |   11 +++++++++++
> net/wireless/radiotap.c          |    2 ++
> 2 files changed, 13 insertions(+)
> 
> diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
> index 7139254..b273c5b 100644
> --- a/include/net/ieee80211_radiotap.h
> +++ b/include/net/ieee80211_radiotap.h
> @@ -183,6 +183,9 @@ struct ieee80211_radiotap_header {
>  *     Contains a bitmap of known fields/flags, the flags, and
>  *     the MCS index.
>  *
> + * IEEE80211_RADIOTAP_AMPDU_STATUS    u32, u16, u8, u8    unitlesss

Just a minor nit, but there seems to be an 's' too many in unitlesss above.

---
Gertjan