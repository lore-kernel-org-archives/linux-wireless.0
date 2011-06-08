Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab1FHLuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:50:01 -0400
Subject: Re: [RFC] cfg80211: Fix handling of previous_auth deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTikc-6hwZwT4Qt-dB-qBkwxEWLwrkg@mail.gmail.com> (sfid-20110608_134854_723417_7ED7D007)
References: <a194a41b3f1376f035113d4f443038eb2e64264f.1307403076.git.pstew@chromium.org>
	 <1307530922.3961.4.camel@jlt3.sipsolutions.net>
	 <BANLkTimdAHt9VUUmNB2uzgm8ymeo6J+EeA@mail.gmail.com>
	 <1307533479.3961.13.camel@jlt3.sipsolutions.net>
	 <BANLkTikc-6hwZwT4Qt-dB-qBkwxEWLwrkg@mail.gmail.com>
	 (sfid-20110608_134854_723417_7ED7D007)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 13:50:01 +0200
Message-ID: <1307533801.3961.14.camel@jlt3.sipsolutions.net> (sfid-20110608_135006_231679_1289BCED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-08 at 04:48 -0700, Paul Stewart wrote:

> >> It's a little confusing to me that the same function is in charge of
> >> outgoing and incoming packets, but yes, I see no point in removing
> >> anything from authtry_bsses[] for a received DEAUTH since it is not
> >> applicable.
> >
> > Yeah, indeed. Would not modifying authtry_bsses for a _received_ DEAUTH
> > fix it?
> 
> Sure, it would.  How do I differentiate between received and
> transmitted DEAUTH?  They seem to go through the same function, or
> maybe I'm wrong.  Do I check the MAC in the mgmt header? :-)

I think you have to check the address, yeah.

johannes

