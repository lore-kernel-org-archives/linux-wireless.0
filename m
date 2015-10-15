Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34125 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbbJOXEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 19:04:14 -0400
Received: by igbni9 with SMTP id ni9so2717926igb.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2015 16:04:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444902418-25668-5-git-send-email-johannes@sipsolutions.net>
References: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net> <1444902418-25668-5-git-send-email-johannes@sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 16 Oct 2015 10:03:54 +1100
Message-ID: <CAGRGNgUZXfrmCA+KpgTW2_yFEqVao7DmQofNrFpiiRAWhUaYXw@mail.gmail.com> (sfid-20151016_010417_089181_030B30DE)
Subject: Re: [PATCH 5/6] cfg80211: reg: make CRDA support optional
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, Oct 15, 2015 at 8:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> If there's a built-in regulatory database, there may be little point
> in also calling out to CRDA and failing if the system is configured
> that way. Allow removing CRDA support to save ~1K kernel size.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/Kconfig   |  10 +++++
>  net/wireless/nl80211.c | 104 +++++++++++++++++++++++++------------------------
>  net/wireless/reg.c     |  73 +++++++++++++++++++++++-----------
>  3 files changed, 114 insertions(+), 73 deletions(-)
>
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 4f5543dd2524..ab7017951083 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -174,6 +174,16 @@ config CFG80211_INTERNAL_REGDB
>
>           Most distributions have a CRDA package.  So if unsure, say N.
>
> +config CFG80211_CRDA_SUPPORT
> +       bool "support CRDA" if EXPERT
> +       default y
> +       depends on CFG80211
> +       help
> +         You should enable this option unless you know for sure you have no
> +         need for it, for example when using internal regdb (above.)
> +
> +         If unsure, say Y.
> +

Is there a way to force the kernel builder to select at least one of
these if they're building cfg80211?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
