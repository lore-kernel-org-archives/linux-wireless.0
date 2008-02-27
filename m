Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:31822 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYB0N7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 08:59:24 -0500
Received: by mu-out-0910.google.com with SMTP id i10so4457820mue.5
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2008 05:59:21 -0800 (PST)
Message-ID: <43e72e890802270559g408f75bdm62682f12bd40fa6c@mail.gmail.com> (sfid-20080227_135928_726623_604FFC01)
Date: Wed, 27 Feb 2008 08:59:19 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Lars Ericsson" <Lars_Ericsson@telia.com>
Subject: Re: Roaming issues.
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <004501c87946$e5f1f490$0b3ca8c0@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <004501c87946$e5f1f490$0b3ca8c0@gotws1589>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2008 at 8:44 AM, Lars Ericsson <Lars_Ericsson@telia.com> wrote:

>  AP deauthentication.
>  =====================
>  When any of the ieee80211_rx_mgmt_deauth() or ieee80211_rx_mgmt_disassoc()
>  are executed, the mac layer takes two actions.
>  1) Tells wpa_supplicant what had happened.
>  2) Start reestabliching the connaction again.
>
>  The later action will stop or significantly delay the decisions/action taken
>  by wpa_supplicant as a result of action 1. Normally the supplicant will
>  start an AP scan.
>  But the mac layer is busy with reestablishing the link and will not start
>  any scan action.

Thanks for reviewing this, some comments below.

>  Timeout handling
>  =================
>  When any of the ieee80211_authenticate() or ieee80211_associate() function
>  are executed.
>  The mac silently set its state to IEEE80211_DISABLED and waits for the
>  wpa_supplicant to timeout its current action.

This doesn't seem to account for pre-authentication, which should
assist roaming. During pre-auth we'd authenticate with local APs even
if we're not going to complete an assoc(), we'd leave the assoc() for
a later time once the signal strength of the new AP is better. I'm not
sure how wpa_supplicant handles with pre-authentication settings
though or if it even supports it but the point here is we should be
able to authenticate many times while we only have one assoc() pre
STA.

  Luis
