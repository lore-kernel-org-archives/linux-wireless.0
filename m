Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbbJWUcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 16:32:01 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtl8xxxu: Enable data frame reception in rtl8xxxu_start
References: <1445462932-23679-1-git-send-email-br1@einfach.org>
	<wrfjoafrrf1s.fsf@redhat.com> <56289543.1070008@thinktube.com>
	<wrfjtwpjoxqj.fsf@redhat.com> <5628E309.6020203@einfach.org>
	<wrfjk2qfow8r.fsf@redhat.com> <5628E9AB.1060907@einfach.org>
Date: Fri, 23 Oct 2015 16:31:58 -0400
In-Reply-To: <5628E9AB.1060907@einfach.org> (Bruno Randolf's message of "Thu,
	22 Oct 2015 14:50:35 +0100")
Message-ID: <wrfj611xba2p.fsf@redhat.com> (sfid-20151023_223221_110453_4E238CE2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bruno Randolf <br1@einfach.org> writes:
> On 10/22/2015 02:42 PM, Jes Sorensen wrote:
>> Making things work against random kernel versions of OpenWRT is not
>> particularly "credible". If the driver needs hacks to work with older
>> kernels, then they should be applied for the older kernels. Linux does
>> not have a history of carrying hacks in current drivers to accommodate
>> older kernels.
>
> Well forget OpenWRT. The point is that this is not a hack - it's the
> behavior that mac80211 expects and documents and moreover it does NOT
> pass more data frames than before.
>
> It does not pass more data frames before association because the RCR
> RCR_ACCEPT_AP bit is not set and the RCR_CHECK_BSSID_* bits are set.

I have gone back and looked more at the vendor drivers over this issue.
Most versions of the vendor driver consistently mess with both FLTMAP*
and RCR, and disable packets when they go into a non-assoc state, but
non-assoc to the vendor driver also means non-AP, non-monitor, etc.

I really would like to know more about the difference between RCR and
FLTMAP registers - Larry is there a chance you could try and ping your
Realtek contacts about this?

For now I have applied your patch and pushed it into both branches.

Cheers,
Jes
