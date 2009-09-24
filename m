Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:62355 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZIXJAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 05:00:14 -0400
Received: by iwn8 with SMTP id 8so791958iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 02:00:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909241055.51604.hs4233@mail.mn-solutions.de>
References: <200909241055.51604.hs4233@mail.mn-solutions.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Sep 2009 01:59:57 -0700
Message-ID: <43e72e890909240159x6d733e1bj9c529f6fe77b32f5@mail.gmail.com>
Subject: Re: [PATCH]: nl80211: report age of scan results
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 1:55 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> Linux keeps scan results up to 15 seconds. This can be a problem for fast
> moving client: they get back stale data. But if the kernel reports the
> age of some BSS, then user-space can simply weed out old entries.
>
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>
> ---
>
> One question was if I should specify the age in ms, or if I should specify
> an absolute time. In the end I thought age in ms is better suited.
>
> If an absolute time would sent with every BSS item, then user-space would
> need an additional call to time() to find out which BSS items are too old.
> Now it can use the milliseconds directly.
>
> The case there user-space wants an absolute time ("At what hour did I get
> the last probe response from this AP?") seems to be a more theoretical
> problem. But if info is wanted, *THEN* you can call time() and substract the
> reported bss-item-age from it.
>
>
> Index: linux-wl/include/linux/nl80211.h
> ===================================================================
> --- linux-wl.orig/include/linux/nl80211.h       2009-09-24 09:19:03.000000000 +0200
> +++ linux-wl/include/linux/nl80211.h    2009-09-24 09:19:42.000000000 +0200
> @@ -1277,6 +1277,7 @@ enum nl80211_channel_type {
>  * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/beacon
>  *     in unspecified units, scaled to 0..100 (u8)
>  * @NL80211_BSS_STATUS: status, if this BSS is "used"
> + * @NL80211_BSS_AGE_MS: age of this BSS entry in ms
>  * @__NL80211_BSS_AFTER_LAST: internal
>  * @NL80211_BSS_MAX: highest BSS attribute
>  */
> @@ -1291,6 +1292,7 @@ enum nl80211_bss {
>        NL80211_BSS_SIGNAL_MBM,
>        NL80211_BSS_SIGNAL_UNSPEC,
>        NL80211_BSS_STATUS,
> +       NL80211_BSS_AGE_MS,

Wil want to #define NL80211_BSS_AGE_MS NL80211_BSS_AGE_MS as well so
userspace apps can ifdef around that feature to know if its supported.

  Luis
