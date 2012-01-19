Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61707 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab2ASLh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 06:37:27 -0500
Received: by iagf6 with SMTP id f6so7563133iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2012 03:37:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120119083102.873553392@sipsolutions.net>
References: <20120119082956.486569312@sipsolutions.net>
	<20120119083102.873553392@sipsolutions.net>
Date: Thu, 19 Jan 2012 13:37:26 +0200
Message-ID: <CAB3XZEd9F+0oOeSmn4UWPZ2iwWdRZ83KcRYRfD4q8ZrGm7m=4Q@mail.gmail.com> (sfid-20120119_123743_241675_D0B49047)
Subject: Re: [PATCH 2/2] mac80211: make CQM RSSI support per virtual interface
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 19, 2012 at 10:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Similar to the previous beacon filtering patch,
> make CQM RSSI support depend on the flags that
> the driver set for virtual interfaces.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

>
> -       if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)) {
> -               if (sdata->vif.type != NL80211_IFTYPE_STATION)
> -                       return -EOPNOTSUPP;
> -               return 0;
> -       }
> -
>        /* tell the driver upon association, unless already associated */
> -       if (sdata->u.mgd.associated)
> +       if (sdata->u.mgd.associated &&
> +           sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
>                ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
>
should you return EOPNOTSUPP if the vif doesn't support it?

Eliad.
