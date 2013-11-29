Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55358 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3K2PhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 10:37:22 -0500
Message-ID: <1385739434.8656.0.camel@jlt4.sipsolutions.net> (sfid-20131129_163725_731361_6719E05B)
Subject: Re: [PATCH v2 1/3] ath10k: use nss provided by mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 29 Nov 2013 16:37:14 +0100
In-Reply-To: <CA+BoTQmtkBGpktbLRfmiLuLDKP9TnUeWu4OMeGUsVcq7m05u4Q@mail.gmail.com> (sfid-20131127_112551_029392_CB0E2653)
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
	 <1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
	 <1385474260-22385-2-git-send-email-michal.kazior@tieto.com>
	 <CA+BoTQmtkBGpktbLRfmiLuLDKP9TnUeWu4OMeGUsVcq7m05u4Q@mail.gmail.com>
	 (sfid-20131127_112551_029392_CB0E2653)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-27 at 11:25 +0100, Michal Kazior wrote:
> On 26 November 2013 14:57, Michal Kazior <michal.kazior@tieto.com> wrote:
> > Calculating STA NSS just from the mcs rateset is
> > not the greatest idea.
> >
> > This should prevent connectivity issues if
> > mac80211 is ever to set rx_nss to something other
> > rather than base on max mcs map. As an example
> > operation mode change notification in assoc
> > request may change rx_nss initial values in the
> > future.
> >
> > Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> > ---
> 
> Drop this single patch, please.
> 
> I just noticed rx_nss doesn't seem to have correct value when associating..

FWIW, there are pending changes to make the opmode data come from
hostapd to mac80211 so that this would be set correctly when the station
is associating.

Or where did you find it wasn't set correctly?

johannes

