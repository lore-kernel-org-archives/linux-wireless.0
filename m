Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:28106 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYG3IzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 04:55:15 -0400
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Cc: "Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	<200807290021.45400.herton@mandriva.com.br> <87d4kwl7hh.fsf@nokia.com>
	<200807300037.50088.herton@mandriva.com.br>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 30 Jul 2008 11:54:37 +0300
In-Reply-To: <200807300037.50088.herton@mandriva.com.br> (ext Herton Ronaldo Krzesinski's message of "Wed\, 30 Jul 2008 00\:37\:49 -0300")
Message-ID: <87fxprvjjm.fsf@nokia.com> (sfid-20080730_105522_372906_656A0D59)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski <herton@mandriva.com.br> writes:

> You are right, I was looking at wrong place, indeed the issue is on rtl8187. 
> The problem here is that mac80211 can call rtl8187_config while another 
> instance of it is still running, and on rtl8187_config this is a critical 
> section:
>

[...]

> My sequence of commands trigger this, so there are cases where it disables TX 
> loopback while there are another instance that can be still 
> inside ->set_chan, that's explain also why card stops to work. This section 
> should be lock protected or mac80211 ensure to not call local->ops->config 
> while another call is still running.

To tell you the truth, I don't know if ops->config() calls should be
serialized or not, but I have always used locking on the driver as a
precaution.

Johannes, can you comment on this, please?

-- 
Kalle Valo
