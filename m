Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3BVLwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 06:52:09 -0500
Message-ID: <1361533924.8146.5.camel@jlt4.sipsolutions.net> (sfid-20130222_125214_541642_A714B822)
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Piotr Haber <phaber@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 22 Feb 2013 12:52:04 +0100
In-Reply-To: <1361524092-4814-2-git-send-email-phaber@broadcom.com> (sfid-20130222_100804_524805_03F665CB)
References: <1361524092-4814-1-git-send-email-phaber@broadcom.com>
	 <1361524092-4814-2-git-send-email-phaber@broadcom.com>
	 (sfid-20130222_100804_524805_03F665CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-22 at 10:08 +0100, Piotr Haber wrote:
> Some devices share antenna/analog front end between Wifi
> and Bluetooth. The hardware coexistence interface allows
> them to do so, but there are situations when it would
> be beneficial if software had a way to have influence on it
> as well. It can be used to protect time sensitive
> traffic in presence of Bluetooth voice stream,
> for an example EAPOL handshake or DHCP negotiation.
> 
> This patch adds new attribute to SET_WIPHY command
> and a new field in struct wiphy to allow control of the
> coexistence behavior. Devices that do not share resources
> with Bluetooth can ignore this parameter.

Apart from a few minor technical comments that I'll omit for now, I'm
not sure what value this really has? EAPOL can already be "protected" by
way of knowing when the station is marked authorized, and DHCP is pretty
tricky because it could take "forever", might not be there at all, etc.

What application would actually call this? I don't really see how it
could be integrated like that.

johannes

