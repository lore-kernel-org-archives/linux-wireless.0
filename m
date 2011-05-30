Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33384 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1E3KvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 06:51:24 -0400
Received: by gxk21 with SMTP id 21so1361642gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 03:51:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304529896-20934-1-git-send-email-javier@cozybit.com>
References: <1304513847.3563.15.camel@jlt3.sipsolutions.net>
	<1304529896-20934-1-git-send-email-javier@cozybit.com>
Date: Mon, 30 May 2011 16:21:23 +0530
Message-ID: <BANLkTinoKZ7QB-eJH+peNg4HopHssZtofg@mail.gmail.com> (sfid-20110530_125127_440969_07612A08)
Subject: Re: [PATCH] cfg80211: Use capability info to detect mesh beacons.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 4, 2011 at 10:54 PM, Javier Cardona <javier@cozybit.com> wrote:
> Mesh beacons no longer use all-zeroes BSSID.  Beacon frames for MBSS,
> infrastructure BSS, or IBSS are differentiated by the Capability
> Information field in the Beacon frame.  A mesh STA sets the ESS and IBSS
> subfields to 0 in transmitted Beacon or Probe Response management
> frames.

This breaks P2P mode as a P2P STA also sets the ESS and IBSS subfields
to zero. Is there any other way to find if it is a mesh other than
this check?

> index fbf6f33..62e542a 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c

> @@ -407,7 +407,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
>
>        res->ts = jiffies;
>
> -       if (is_zero_ether_addr(res->pub.bssid)) {
> +       if (WLAN_CAPABILITY_IS_MBSS(res->pub.capability)) {
>                /* must be mesh, verify */

Reverting the above change, makes P2P work. Any other better fix?

>                meshid = cfg80211_find_ie(WLAN_EID_MESH_ID,
>                                          res->pub.information_elements,
> --

Vivek.
