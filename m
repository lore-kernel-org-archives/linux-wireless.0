Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:35567 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbbJVNuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 09:50:39 -0400
Subject: Re: [PATCH] rtl8xxxu: Enable data frame reception in rtl8xxxu_start
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <1445462932-23679-1-git-send-email-br1@einfach.org>
 <wrfjoafrrf1s.fsf@redhat.com> <56289543.1070008@thinktube.com>
 <wrfjtwpjoxqj.fsf@redhat.com> <5628E309.6020203@einfach.org>
 <wrfjk2qfow8r.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
From: Bruno Randolf <br1@einfach.org>
Message-ID: <5628E9AB.1060907@einfach.org> (sfid-20151022_155042_138021_7B7811D1)
Date: Thu, 22 Oct 2015 14:50:35 +0100
MIME-Version: 1.0
In-Reply-To: <wrfjk2qfow8r.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2015 02:42 PM, Jes Sorensen wrote:
> Making things work against random kernel versions of OpenWRT is not
> particularly "credible". If the driver needs hacks to work with older
> kernels, then they should be applied for the older kernels. Linux does
> not have a history of carrying hacks in current drivers to accommodate
> older kernels.

Well forget OpenWRT. The point is that this is not a hack - it's the
behavior that mac80211 expects and documents and moreover it does NOT
pass more data frames than before.

It does not pass more data frames before association because the RCR
RCR_ACCEPT_AP bit is not set and the RCR_CHECK_BSSID_* bits are set.

bruno
