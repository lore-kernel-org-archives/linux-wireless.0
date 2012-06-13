Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34101 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2FMIAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 04:00:01 -0400
Received: by obbtb18 with SMTP id tb18so509789obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 01:00:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339570296.4519.7.camel@jlt3.sipsolutions.net>
References: <1339570296.4519.7.camel@jlt3.sipsolutions.net>
Date: Wed, 13 Jun 2012 11:00:01 +0300
Message-ID: <CAB3XZEf++ayd3s1v61Z9BAeDEFVcehddaAPVabenm25Fhf_6Rw@mail.gmail.com> (sfid-20120613_100007_084191_42644787)
Subject: Re: [PATCH 3.5] mac80211: stop polling in disassociation
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2012 at 9:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: David Spinadel <david.spinadel@intel.com>
>
> Stop connection monitor poll during disassociation.
> This clears the polling flags and if a scan was
> deferred it will be run.
>
> Without this fix, if a scan was deferred due to
> connection monitoring while disassociation happens,
> this scan blocks further scan requests until interface
> down/up which causes problems connecting to another AP.
>
> Signed-off-by: David Spinadel <david.spinadel@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> @@ -1329,6 +1329,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>        u32 changed = 0;
>        u8 bssid[ETH_ALEN];
>
> +       ieee80211_stop_poll(sdata);
> +
>        ASSERT_MGD_MTX(ifmgd);

it doesn't matter much, but maybe better add the call after the
function "prologue" (lockdep, WARN_ONs, ...)?

Eliad.
