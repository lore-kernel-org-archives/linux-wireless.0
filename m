Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15560 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbYJIWqC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 18:46:02 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2008 15:46:02 -0700
Date: Thu, 9 Oct 2008 08:45:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
CC: "lrodrigues@atheros.com" <lrodrigues@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081009154547.GB13349@tesla> (sfid-20081010_004608_478424_BAB0A7CA)
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 09, 2008 at 03:17:18PM -0700, Kolekar, Abhijeet wrote:
> Hello Luis,
>   I have been trying to implement new regulatory api for iwlwifi drivers. One of the problem we are facing
> is that , when we tried to remove iwlagn driver without removing the cfg80211,and then again inserting the
> same module , we cannot set the regulatory domain.  The reasons for this probably be ,as  we are just giving a pointer to
> regulatory domain in regulatory_hint function which may lead to potential memory link.

This was done intentionally by design so we can allow cfg80211 to free
the regulatory domain structure itself.

> Cfg80211 should copy the regulatory domain
> information in its own memory rather than a pointer to driver memory.

That is one way of doing it but we discussed this particular point on
the lists IIRC and at OLS too and we decided to let cfg80211 rather
be the father of the pointer and to be in charge of freeing it later.
This allows us to have a central place which will be in charge of this
pointer once gobbled up and therefore make it less prone to error
amongst callers.

Did you try to see where or why it was actually failing?

My guess is it fails when ignore_request() is called, particularly in
this section:

	switch (set_by) {

	/* -- stuff -- */

        case REGDOM_SET_BY_DRIVER:
                BUG_ON(!wiphy);
                if (last_request->initiator == set_by) {
                        /* Two separate drivers hinting different things,
                         * this is possible if you have two devices
                         * present on a system with different EEPROM regulatory
                         * readings. XXX: Do intersection, we support
                         * only
                         * the first regulatory hint for now */
                        if (last_request->wiphy != wiphy)
                                return -EALREADY;
                        if (rd)
                                return -EALREADY;
                        /* Driver should not be trying to hint different
                         * regulatory domains! */
                        BUG_ON(!alpha2_equal(alpha2,
                                        cfg80211_regdomain->alpha2));
                        return -EALREADY;
                }


In your case I think you hit this after rmmod and modprobe:

	if (last_request->wiphy != wiphy)
		return -EALREADY;

since the last wiphy != your new wiphy. The reason this check was added
though, as the comment indicates, was to prevent two drivers with
different regulatory domains from trying to set it. In your case this
doesn't affect your requested setting as the old regulatory domain
is still set. This check currently also forces the first device detected
on the system and its regutory_hint() to be respected over any other
devices considering that your built in wireless card on your laptop
will probably be detected first over your cardbus card, or USB card
for example.

In other words this you can treat -EALREADY return value as non
critical, as per the documentation (please see include/net/wireless.h).

  Luis
