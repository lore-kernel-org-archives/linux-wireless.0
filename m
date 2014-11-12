Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaKLVA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:00:27 -0500
Message-ID: <1415826023.28424.7.camel@dcbw.local> (sfid-20141112_220032_578056_FCB0A8F8)
Subject: Re: MAC acl equivalent to iwpriv for nl80211 drivers
From: Dan Williams <dcbw@redhat.com>
To: Patrick Bosch <patrick.d.bosch@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Nov 2014 15:00:23 -0600
In-Reply-To: <loom.20141112T152857-158@post.gmane.org>
References: <loom.20141112T152857-158@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-12 at 14:31 +0000, Patrick Bosch wrote:
> Hello everybody
> 
> I hope I do post this in the correct mailing list.
> 
> My problem is the following:
> 
> I want to add/delete new MAC addresses to the acl without restarting
> anything. Without restarting I mean that there shouldn't be a time frame
> where no beacon frames are sent. This happened to me on an OpenWRT
> router and I want to avoid this effect.

This would be something that should be done with hostapd or whatever is
actually managing the AP mode.  It looks like the procedure here is to
update your "deny MAC" and "accept MAC" files, then issue the
hostapd_cli command "SET deny_mac_file /path/to/deny" and "SET
accept_mac_file /path/to/accept" commands, which will immediately
disconnect any clients that aren't in the ACL, without restarting
anything.

> It seems to me that iwpriv offers exactly this functionality. You can add
> a list of MAC addresses and define how they should be handled. Iw
> doesn't seem to offer this option. Is there any other way to get this
> functionality? 

iwpriv is simply a driver passthrough, it doesn't offer any
functionality other than "push this random data to the driver" in a
slightly formatted way.  The options are defined by the driver itself.
The upstream kernel wifi community is trying very hard to *not* allow
this sort of functionality, at least as it has been used in the past
with iwpriv, since almost the stuff iwpriv used to do, can be done in a
more standard way with 'iw', or should be done elsewhere
(wpa_supplicant, hostapd).

Dan

> Another question would be, if there is a way to forge management
> frames, similar to what hostapd_cli can do for deauthentication and
> disassociation frames? 
> 
> Any help is appreciated!

