Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:62950 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032143Ab2CPXbd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 19:31:33 -0400
Message-ID: <4F63CD33.7030009@lri.fr> (sfid-20120317_003203_062380_8EC73CDE)
Date: Sat, 17 Mar 2012 00:30:59 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
CC: linux-wireless@vger.kernel.org, mathieu-tl@ubuntu.com
Subject: Re: Issues with IBSS/WPA being created unsecured IBSS
References: <4F63A135.1060909@canonical.com>
In-Reply-To: <4F63A135.1060909@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/03/2012 21:23, Mathieu Trudel-Lapierre wrote:
>
> Hi,
>
> I'm trying to figure out how to fix WPA-secured IBSS; which appears
> to be silently falling back to creating unsecured IBSS networks at
> the kernel level (or IBSS/RSN really, if need be, as it seems to
> react pretty much just the same, although I understand it's not
> supported by all devices).

If you are talking about WPA-none, it's been broken for a loooong time
(2009?).
First, wpasupplicant tries to set the key just after requesting an ibss
join without
waiting for the driver to actually join the IBSS. With current kernels,
you cannot
set keys until joined, so that fails. But even if
wpasupplicant did it right, it would still break, because, among other
things, the
kernel will just refuse to decrypt unicast frames with anything else
than pairwise keys.


If wpasupplicant supports IBSS RSN (which is disabled in ubuntu, IIRC),
at least mac80211 based drivers will not send/accept plaintext frames,
whether IBSS RSN is supported by the driver or not.


