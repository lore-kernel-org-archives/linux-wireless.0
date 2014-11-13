Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43837 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639AbaKMMot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 07:44:49 -0500
Message-ID: <1415882683.2021.3.camel@sipsolutions.net> (sfid-20141113_134506_152448_998BB541)
Subject: Re: Can fb4e156886ce6e8309e912d8b370d192330d19d3 be reverted ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Date: Thu, 13 Nov 2014 13:44:43 +0100
In-Reply-To: <20141113123313.GA1926@redhat.com> (sfid-20141113_133628_786084_BDEA3269)
References: <20141113123313.GA1926@redhat.com>
	 (sfid-20141113_133628_786084_BDEA3269)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-13 at 13:33 +0100, Stanislaw Gruszka wrote:
> I've updated wireless code on RHEL and get complain that now
> cfg80211 and rfkill modules are loaded on machines that do not have
> wireless hardware. Modules are auto-loaded because NetworkManager send
> nl80211 messages to check if there are wireless devices in the system.
> 
> Hence my question, can we revert commit fb4e156886ce
> "nl80211: Add generic netlink module alias for cfg80211/nl80211" ?

Realistically, we can't revert it, but only remove the
MODULE_ALIAS_GENL_FAMILY() line.

> Auto loading nl80211 does not seems to be necessary, if there are
> wireless devices nl80211 will be loaded anyway.

Maybe other applications would like to see an empty list of devices? But
OTOH, if they're robust at all, they have to cope with kernels not even
compiled with nl80211, so I guess for me I don't really see a big
difference in whether the module alias exists or not.

johannes

