Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56333 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939537AbdD1KiS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 06:38:18 -0400
From: "Mohammed Shafi Shajakhan (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "mohammed@codeaurora.org" <mohammed@codeaurora.org>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>
Subject: Re: [PATCH] mac80211: Fix possible sband related NULL pointer
 de-reference
Date: Fri, 28 Apr 2017 10:38:10 +0000
Message-ID: <1493375889856.46906@qti.qualcomm.com> (sfid-20170428_123841_644579_279551CC)
References: <1493277338-25726-1-git-send-email-mohammed@qca.qualcomm.com>,<1493371140.2431.6.camel@sipsolutions.net>
In-Reply-To: <1493371140.2431.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-27 at 12:45 +0530, Mohammed Shafi Shajakhan wrote:=0A=
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>=0A=
>=0A=
> Existing API 'ieee80211_get_sdata_band' returns default 2 GHz band=0A=
> even=0A=
> if the channel context configuration is NULL. This crashes for=0A=
> chipsets=0A=
> which support 5 Ghz alone when it tries to access members of 'sband'.=0A=
> Channel context configuration can be NULL in multivif case and when=0A=
> channel switch is in progress (or) when it fails. Fix this by=0A=
> replacing=0A=
> the API 'ieee80211_get_sdata_band' with  'ieee80211_get_sband' which=0A=
> returns a NULL pointer for sband when the channel configuration is=0A=
> NULL.=0A=
=0A=
Makes sense.=0A=
=0A=
Applied, but could you point to the one that actually crashed?=0A=
=0A=
[shafi] thanks johannes, it crashed @=0A=
=0A=
 405                 smps =3D (sband->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) =
>>=0A=
 406                         IEEE80211_HT_CAP_SM_PS_SHIFT;=0A=
