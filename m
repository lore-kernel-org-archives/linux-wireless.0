Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51957 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932359AbbJ0SzV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 14:55:21 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Julien Cubizolles <j.cubizolles@free.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mwifiex problem: incompatible network settings
Date: Tue, 27 Oct 2015 18:55:17 +0000
Message-ID: <1445972115005.99995@marvell.com> (sfid-20151027_195524_547238_EB0E08AD)
References: <87wpu9632c.fsf@free.fr>
 <1445875814.31216.18.camel@redhat.com>,<87twpd8fk4.fsf@free.fr>
In-Reply-To: <87twpd8fk4.fsf@free.fr>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julien,

>Yes, I'm using NetworkManager, version 1.0.4-ubuntu5, and I'm guessing
>it's using wpa_supplicant. I deleted the configuration for this network
>and created it again. The network is configured for WPA in
>NetworkManager but I still get the same error message.

Looks like driver has received encryption mode as TKIP, but didn't receive WPA ie. Hence the configuration didn't match with AP. Could you share wpa_supplicant configuration file if possible? Also, check if "sme->ie" is received in mwifiex_cfg80211_assoc() routine. Enable driver debug for the test using "echo 0xffffffff > /sys/kernel/debug/mwifiex/mlan0/debug_mask" and share dmesg logs.

Regards,
Amitkumar