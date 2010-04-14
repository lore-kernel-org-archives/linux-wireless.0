Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46108 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab0DNTAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 15:00:09 -0400
Date: Wed, 14 Apr 2010 14:49:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] cfg80211: Avoid sending IWEVASSOCREQIE and
	IWEVASSOCRESPIE events with NULL event body
Message-ID: <20100414184859.GA4352@tuxdriver.com>
References: <1271163717-26654-1-git-send-email-nishants@marvell.com> <1271164963.4885.45.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271164963.4885.45.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 13, 2010 at 03:22:43PM +0200, Johannes Berg wrote:
> On Tue, 2010-04-13 at 06:01 -0700, Nishant Sarmukadam wrote:
> > In a scenario, where a cfg80211 driver (station mode) does not send assoc request
> > and assoc response IEs in cfg80211_connect_result after a successful association
> > to an AP, cfg80211 sends IWEVASSOCREQIE and IWEVASSOCRESPIE to the user space
> > application with NULL data. This can cause an issue at the event recipient.
> > 
> > An example of this is when cfg80211 sends IWEVASSOCREQIE and IWEVASSOCRESPIE
> > events with NULL event body to wpa_supplicant. The wpa_supplicant overwrites
> > the assoc request and assoc response IEs for this station with NULL data.
> > If the association is WPA/WPA2, the wpa_supplicant is not able to generate
> > EAPOL handshake messages, since the IEs are NULL.
> > 
> > With the patch, req_ie and resp_ie will be NULL by avoiding the
> > assignment if the driver has not sent the IEs to cfg80211. The event sending
> > code sends the events only if resp_ie and req_ie are not NULL. This
> > will ensure that the events are not sent with NULL event body.
> > 
> > Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> > ---
> > v2: Incorporated comments from Johannes, added some more information and
> > did formatting changes
> 
> Thanks.
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Somehow, I never got the original email.  The MARC archive seems to
have missed the original as well:

http://marc.info/?l=linux-wireless&m=127116497024611&w=2

Any chance for a resend?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
