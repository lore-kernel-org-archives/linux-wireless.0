Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server4.hostdango.com ([70.86.37.74]:35478 "EHLO
	server4.hostdango.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0KLHZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 02:25:31 -0500
Received: from transmat-4.krellan.net ([71.133.204.142] helo=[10.6.9.2])
	by server4.hostdango.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <krellan@krellan.com>)
	id 1PGo0h-0001dP-68
	for linux-wireless@vger.kernel.org; Thu, 11 Nov 2010 23:25:23 -0800
Message-ID: <4CDCEBE9.8060905@krellan.com>
Date: Thu, 11 Nov 2010 23:25:29 -0800
From: Josh Lehan <krellan@krellan.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Distinguishing wrong password from other failure to connect?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.  Curious if there is a way to distinguish between the various
failure modes when failing to make an association to an AP.

In particular, I'd love to distinguish between these two states:

* User entered incorrect password

* User entered correct password, but the AP rejected them for some other
reason (perhaps signal was too weak, or the AP is using MAC address
filtering, or they couldn't negotiate a common encryption/authentication
protocol, or whatever).

Does the Linux wireless stack support a way for applications to gather
this information?  Are the "reason=0x00" bytes, sometimes displayed by
wpa_supplicant in the logs, standardized across all AP's?

This seems to be a common problem, because on many distributions, I see
NetworkManager constantly popping up the password entry box whenever an
association fails, when the user already knows the password is correct
(and in fact has entered it into the box already, as it's pre-filled in
the box, albeit starred out).

Thanks!

Josh
