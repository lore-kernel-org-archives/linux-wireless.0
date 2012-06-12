Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53507 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2FLOu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 10:50:58 -0400
Received: by dady13 with SMTP id y13so6965830dad.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 07:50:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339510185.4531.12.camel@jlt3.sipsolutions.net>
References: <1339497630-31589-1-git-send-email-eyal@wizery.com> <1339510185.4531.12.camel@jlt3.sipsolutions.net>
From: Eyal Shapira <eyal@wizery.com>
Date: Tue, 12 Jun 2012 17:50:37 +0300
Message-ID: <CAF8O4-ziVXstVZ19tjnQyCZYEArvrcizw17Pb13EfRe7Kg3iwQ@mail.gmail.com> (sfid-20120612_165102_443866_CF7CAE38)
Subject: Re: [PATCH] mac80211: handle auth failure returned with unmatching
 auth algo
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 June 2012 17:09, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2012-06-12 at 13:40 +0300, Eyal Shapira wrote:
> > Some Netgear APs like WNAP210 have a quirk behavior when
> > configured for WEP Shared. They send an auth response with algo
> > SHARED and status code NOT_SUPPORTED_AUTH_ALG (13) when being
> > sent a request made with auth algo OPEN. Enable such response to
> > propagate to userspace instead of discarding it so wpa_s can
> > reattempt to auth with SHARED.
>
> Does cfg80211 need to handle this? How does wpa_s even handle it?

wpa_s has the following code in wpa_supplicant/sme.c/sme_event_auth()
to automatically
"escalate" in the auth algorithms it tries (from OPEN to SHARED to LEAP) :

		switch (data->auth.auth_type) {
		case WLAN_AUTH_OPEN:
			wpa_s->current_ssid->auth_alg = WPA_AUTH_ALG_SHARED;

			wpa_dbg(wpa_s, MSG_DEBUG, "SME: Trying SHARED auth");
			wpa_supplicant_associate(wpa_s, wpa_s->current_bss,
						 wpa_s->current_ssid);
			return;

		case WLAN_AUTH_SHARED_KEY:
			wpa_s->current_ssid->auth_alg = WPA_AUTH_ALG_LEAP;

			wpa_dbg(wpa_s, MSG_DEBUG, "SME: Trying LEAP auth");
			wpa_supplicant_associate(wpa_s, wpa_s->current_bss,
						 wpa_s->current_ssid);
			return;

I have a patch for that code in wpa_s as well which attempts SHARED in
case we sent OPEN
and got the NOT_SUPPORTED_AUTH_ALG response on SHARED.
I first wanted to see that the kernel patch which allows the response
to go through is accepted.

You're right of course that I also need to take care of cfg80211 when
using its SME.
I'll send an additional patch for that.

>
> johannes
>
