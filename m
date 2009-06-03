Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:45618 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbZFCOuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 10:50:20 -0400
Message-ID: <4A268DAC.4010805@lwfinger.net>
Date: Wed, 03 Jun 2009 09:50:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: always init poll delayed work
References: <1244015729.7176.28.camel@johannes.local>
In-Reply-To: <1244015729.7176.28.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> The rfkill core didn't initialise the poll delayed work
> because it assumed that polling was always done by specifying
> the poll function. cfg80211, however, would like to start
> polling only later, which is a valid use case and easy to
> support, so change rfkill to always initialise the poll
> delayed work and thus allow starting polling by calling the
> rfkill_resume_polling() function after registration.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---

This patch fixed to kernel BUG_ON, but there are still problems. This
has been tested with b43.

1. A minor one - the radio LED switch never comes on. Module led-class
is loaded.

2. Much more serious - When the radio kill switch is turned off, the
radio is killed just as expected, but it is not restored when the
switch is turned on. The only way to restore the radio is to
rmmod/insmod b43. Similarly, if the module is loaded with the switch
off, it is not possible to turn the radio on. An unload/load resquence
is then needed.

Larry

