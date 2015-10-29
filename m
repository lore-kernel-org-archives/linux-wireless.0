Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19761 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbbJ2M16 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 08:27:58 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Julien Cubizolles <j.cubizolles@free.fr>,
	Dan Williams <dcbw@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Nishant Sarmukadam" <nishants@marvell.com>
Subject: RE: mwifiex problem: incompatible network settings
Date: Thu, 29 Oct 2015 12:27:52 +0000
Message-ID: <b2db7a93638f44b683aef052ca442c5c@SC-EXCH04.marvell.com> (sfid-20151029_132808_874024_86D34668)
References: <87wpu9632c.fsf@free.fr> <1445875814.31216.18.camel@redhat.com>
	<87twpd8fk4.fsf@free.fr> <1445972115005.99995@marvell.com>
	<87a8r4ugth.fsf@free.fr> <1446043853.24757.51.camel@redhat.com>
 <87vb9qsmg1.fsf@free.fr>
In-Reply-To: <87vb9qsmg1.fsf@free.fr>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julien,

> From: Julien Cubizolles [mailto:j.cubizolles@free.fr]
> Sent: Thursday, October 29, 2015 3:09 AM
> To: Dan Williams
> Cc: Amitkumar Karwar; linux-wireless@vger.kernel.org
> Subject: Re: mwifiex problem: incompatible network settings
> 
> Dan Williams <dcbw@redhat.com> writes:
> 
> > He actually meant the wpa_supplicant configuration file, not the
> > supplicant's dbus config file.  But when driven by NetworkManager,
> > there is no supplicant configuration file.
> 
> Sorry about that.
> 
> > Instead, you can find out what config NM is pushing to the supplicant
> > by checking the NetworkManager logs, where NM will log lines like:
> 
> Here are the relevant entries from the syslog file:
> 
> I included the failed attempt to connect to the WPA protected network
> named "southcentral" and the successful one to a non protected one named
> "FreeWifi".
> 

Thanks for the logs. I compared your network manager log with the one on my setup. Both are same. Basically network manager log doesn't show security info (WPA/WPA2, encryption mode etc). So we can't rely on that.
I checked your kernel log shared in previous email. It's incomplete. It didn't include information when connection was actually attempted. Probably you can run "dmesg -c >> dmesg.log" in loop with some delay to capture complete info. Otherwise sharing "/var/log/messages" is also an option.
I have created a driver debug patch(attached). Could you please apply it and share complete dmesg log?

Btw, do you see the problem if AP is configured in WPA2 security mode?

Regards,
Amitkumar
