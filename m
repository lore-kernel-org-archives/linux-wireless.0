Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50885 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1KGI35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 03:29:57 -0500
Received: by bke11 with SMTP id 11so3380303bke.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Nov 2011 00:29:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111104101943.704950080@sipsolutions.net>
References: <20111104101809.711636760@sipsolutions.net> <20111104101943.704950080@sipsolutions.net>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Mon, 7 Nov 2011 10:29:41 +0200
Message-ID: <CA+XVXfemN4dZC2GkKqpvGsFxs81dST4Mth0rEDd-MQrXc8rnXw@mail.gmail.com> (sfid-20111107_093001_329284_53B2308E)
Subject: Re: [PATCH 05/12] nl80211: advertise device AP SME
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 4, 2011 at 12:18, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Add the ability to advertise that the device
> contains the AP SME and what features it can
> support.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[...]
>
> +/**
> + * enum nl80211_ap_sme_features - device-integrated AP features
> + * @NL80211_AP_SME_WSC: The driver is capable of indicating received probe
> + *     request frames to userspace via management frame subscription events
> + *     if the payload includes the WSC IE. The driver is capable of adding
> + *     the WSC IE as configured from userspace into beacons, probe responses
> + *     and (re)association reponse frame and allows userspace to update them
> + *     during the lifetime of the BSS.
> + */
> +enum nl80211_ap_sme_features {
> +       NL80211_AP_SME_WSC      = 1 << 0,
> +};

Perhaps we should break up this feature into two? With the upcoming
probe-resp patches a wl12xx card will be able to indicate
probe-requests with WSC IE up, but won't be able to add a userspace
provided WSC IE into beacons.
Also I'm wondering what this is used for. For instance this contains
no indication about WPS1 and p2p. Pretty sure ath6kl handles these in
a similar fashion (at least for the put-IE-from-userspace-in-beacon
part).

And as a final nit-pick, I think WPS2 is more appropriate, as this is
also the name of the option in the hostapd code and config file.

Arik
