Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:58363 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZIXScS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:32:18 -0400
Received: by iwn8 with SMTP id 8so1141805iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 11:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090924180242.14503.11148.stgit@tikku>
References: <20090924180048.14503.9579.stgit@tikku> <20090924180242.14503.11148.stgit@tikku>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Sep 2009 11:32:01 -0700
Message-ID: <43e72e890909241132r2c684de2i9e80537bc3d13c63@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: add firmware and hardware version to wiphy
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 11:02 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> From: Kalle Valo <kalle.valo@nokia.com>
>
> It's useful to provide firmware and hardware version to user space and have a
> generic interface to retrieve them. Users can provide the version information
> in bug reports etc.
>
> Add fields for firmware and hardware version to struct wiphy and return
> them to user space in NL80211_CMD_GET_WIPHY reply.

Wow that was quick :)

> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>
>  include/linux/nl80211.h |    3 +++
>  include/net/cfg80211.h  |    5 +++++
>  net/wireless/nl80211.c  |   11 +++++++++++
>  3 files changed, 19 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index a8d71ed..6d6651f 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -714,6 +714,9 @@ enum nl80211_attrs {
>
>        NL80211_ATTR_PID,
>
> +       NL80211_ATTR_FW_VERSION,
> +       NL80211_ATTR_HW_VERSION,
> +

Some kdoc on this would be nice.

>        /* add attributes here, update the policy in nl80211.c */
>
>        __NL80211_ATTR_AFTER_LAST,
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 3d874c6..de3da19 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1070,6 +1070,8 @@ struct cfg80211_ops {
>  * and registration/helper functions
>  */
>
> +#define CFG80211_VERSION_LEN 32

Probably best to just remove this or at least make this not just
CFG80211_VERSION_LEN, seems like this is related to cfg80211's version
somehow.

  Luis
