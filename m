Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61888 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab1ISTwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 15:52:25 -0400
Received: by eya28 with SMTP id 28so1813903eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 12:52:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316082334-7664-5-git-send-email-arik@wizery.com>
References: <1316082334-7664-1-git-send-email-arik@wizery.com> <1316082334-7664-5-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 19 Sep 2011 22:52:08 +0300
Message-ID: <CA+XVXff_jxGTtAp6+WeXgcBCEiDj7bDf8KdvZ991TAKpYex8BA@mail.gmail.com> (sfid-20110919_215229_356744_58D6708D)
Subject: Re: [RFC 4/5] mac80211: add a HW flag for TDLS support
To: linux-wireless@vger.kernel.org
Cc: Kalyan C Gaddam <chakkal@iit.edu>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 15, 2011 at 13:25, Arik Nemtsov <arik@wizery.com> wrote:
> Allow TDLS operations and peers only in supporting hardware.
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Cc: Kalyan C Gaddam <chakkal@iit.edu>
> ---
>  include/net/mac80211.h |    4 ++++
>  net/mac80211/cfg.c     |   11 +++++++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2f01d84..25bd038 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1094,6 +1094,9 @@ enum sta_notify_cmd {
>  *     stations based on the PM bit of incoming frames.
>  *     Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
>  *     the PS mode of connected stations.
> + *
> + * @IEEE80211_HW_SUPPORTS_TDLS:
> + *     This device can operate as a TDLS (802.11z) peer.
>  */

I think that for v2 I'll replace this with a wiphy flag that will also
be propagated to usermode. An additional wiphy flag (something like
TDLS_EXTERNAL_LINK_SETUP) will toggle between the full-mac mode and
the mode used in mac80211.

Arik
