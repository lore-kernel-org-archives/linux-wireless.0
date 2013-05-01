Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:34397 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3EATuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 15:50:21 -0400
MIME-Version: 1.0
In-Reply-To: <518166C5.4080904@openwrt.org>
References: <518166C5.4080904@openwrt.org>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 2 May 2013 01:19:58 +0530
Message-ID: <CABPxzYLP53mnMXAicD33oX8TW77xnZziS=XBuVCy_u4H2oyLUw@mail.gmail.com> (sfid-20130501_215042_523096_4594BE5E)
Subject: Re: Regression in 3.9 caused by "bridge: respect RFC2863 operational state"
To: Felix Fietkau <nbd@openwrt.org>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 2, 2013 at 12:32 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>
> In the long run, I'd like to sort out this mess by passing EAP frames to
> userspace via nl80211 - but since that will require userspace changes,
> what do we do about this issue in the mean time?

One quick solution i can think of is:

Temporarily we can make the interface UP as soon as
we are associated and then drop the data packets except for
EAPOL-KEY (ETH_H_PAE) frames in the mac80211.

ieee80211_frame_allowed has a rule to drops the unencrypted data frames
we just need to add a rule to drop encrypted data frames.
