Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33879 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0GJFFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jul 2010 01:05:37 -0400
Received: by qyk38 with SMTP id 38so3463455qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jul 2010 22:05:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278719330-56441-1-git-send-email-steve@cozybit.com>
References: <1278719330-56441-1-git-send-email-steve@cozybit.com>
Date: Fri, 9 Jul 2010 22:05:36 -0700
Message-ID: <AANLkTimmgD2E3c9FhU9PKt5mZDz7eVO_aHVLW4G9Vm4y@mail.gmail.com>
Subject: Re: [PATCH] mac80211: update mesh information element values
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, Steve deRosier <steve@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'd like to retract this patch.  Considering that it will break
backwards compatibility with older kernels (which I neglected to
mention that in the commit message) and it's not really critical at
this time, I think it's a bit premature.  Let's call it more a RFC
than a patch.

That said, about a month ago someone on this list complained about the
fact that WLAN_EID_MESH_CONFIG and WLAN_EID_MESH_ID numbers overlapped
with WLAN_EID_AP_CHAN_REPORT and	WLAN_EID_NEIGHBOR_REPORT numbers.
That's what prompted this patch.  I don't think that this patch fixes
the actual problem he had with mesh not working, but he might want to
try this just to eliminate that variable.

I apologize for the inconvenience.  I'll resubmit this patch at a more
appropriate time in the future.

Thanks,
- Steve

On Fri, Jul 9, 2010 at 4:48 PM, Steve deRosier <steve@cozybit.com> wrote:
> The old values conflicted with ANA approved values. The new values
> were chosen to be consistent with those for the ANA request plan
> for 802.11s.
>
> The Peer Link IE no longer exists in draft standards, replaced by
> the Peer Management IE.  Leaving the old definition in was prudent
> until mesh code can be changed to match.
>
> Signed-off-by: Steve deRosier <steve@cozybit.com>
> ---
>  include/linux/ieee80211.h |   23 +++++++++++++----------
>  1 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 97b2eae..1ed60b5 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -1142,17 +1142,20 @@ enum ieee80211_eid {
>        /* 802.11s
>         *
>         * All mesh EID numbers are pending IEEE 802.11 ANA approval.
> -        * The numbers have been incremented from those suggested in
> -        * 802.11s/D2.0 so that MESH_CONFIG does not conflict with
> -        * EXT_SUPP_RATES.
> +        * The numbers have been taken from ANA request plan for 802.11s
> +        *
> +        * Note that the Peer Link IE has been replaced with the similar
> +        * Peer Management IE.  We will keep the former definition until mesh
> +        * code is changed to comply with latest 802.11s drafts.
>         */
> -       WLAN_EID_MESH_CONFIG = 51,
> -       WLAN_EID_MESH_ID = 52,
> -       WLAN_EID_PEER_LINK = 55,
> -       WLAN_EID_PREQ = 68,
> -       WLAN_EID_PREP = 69,
> -       WLAN_EID_PERR = 70,
> -       WLAN_EID_RANN = 49,     /* compatible with FreeBSD */
> +       WLAN_EID_MESH_CONFIG = 113,
> +       WLAN_EID_MESH_ID = 114,
> +       WLAN_EID_PEER_MGMT = 115,
> +       WLAN_EID_PEER_LINK = 55,  /* no longer in 802.11s drafts */
> +       WLAN_EID_PREQ = 130,
> +       WLAN_EID_PREP = 131,
> +       WLAN_EID_PERR = 132,
> +       WLAN_EID_RANN = 126,
>
>        WLAN_EID_PWR_CONSTRAINT = 32,
>        WLAN_EID_PWR_CAPABILITY = 33,
> --
> 1.7.0
>
>
