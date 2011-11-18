Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1KRUbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 15:31:01 -0500
Subject: Re: [PATCH v10 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1321644720-8245-2-git-send-email-greearb@candelatech.com> (sfid-20111118_203218_329178_9FB3658A)
References: <1321644720-8245-1-git-send-email-greearb@candelatech.com>
	 <1321644720-8245-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111118_203218_329178_9FB3658A)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 21:30:57 +0100
Message-ID: <1321648257.10266.77.camel@jlt3.sipsolutions.net> (sfid-20111118_213106_147001_8A49446E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 11:32 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This implements ht-cap over-rides for mac80211 drivers.
> HT may be disabled, making an /a/b/g/n station act like an
> a/b/g station.  HT40 may be disabled forcing the station to
> be HT20 even if the AP and local hardware support HT40.
> 
> MAX-AMSDU may be disabled.
> AMPDU-Density may be increased.
> AMPDU-Factor may be decreased.
> 
> This has been successfully tested with ath9k using patched
> wpa_supplicant and iw.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v10:
>  *  Add check in ieee80211_apply_htcap_overrides to make
>     sure we are type NL80211_IFTYPE_STATION.
> 
>  *  Memset u.mgd.ht_capa and ht_capa_mask to 0 in
>     ieee80211_set_disassoc to make sure we do not try to
>     use stale data.
> 
>  *  Add cpu_to_le16 when dealing with u.mgd.ht_capa*
>     Appears to make no change on x86, but should help
>     with certain other platforms.
> 
>  *  Addressed other issues brought up in review of v9.

Thanks. I haven't tested it, but see no obvious bugs. :-)

johannes

