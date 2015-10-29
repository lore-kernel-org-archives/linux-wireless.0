Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:33430 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbbJ2O3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 10:29:25 -0400
Received: by ykft191 with SMTP id t191so43932476ykf.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 07:29:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Oct 2015 19:59:24 +0530
Message-ID: <CAE2MWkmxL9Ez81VizxYcCMdmmpXVbjSp8NLVy_sTK6xDvJs2iw@mail.gmail.com> (sfid-20151029_152928_820760_03DAB33F)
Subject: Re: mwifiex problem: incompatible network settings
From: Ujjal Roy <royujjal@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Julien Cubizolles <j.cubizolles@free.fr>,
	Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit/Julien,

On Thu, Oct 29, 2015 at 5:57 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
>
> Hi Julien,
>
> > From: Julien Cubizolles [mailto:j.cubizolles@free.fr]
> > Sent: Thursday, October 29, 2015 3:09 AM
> > To: Dan Williams
> > Cc: Amitkumar Karwar; linux-wireless@vger.kernel.org
> > Subject: Re: mwifiex problem: incompatible network settings
> >
> > Dan Williams <dcbw@redhat.com> writes:
> >
> > > He actually meant the wpa_supplicant configuration file, not the
> > > supplicant's dbus config file.  But when driven by NetworkManager,
> > > there is no supplicant configuration file.
> >
> > Sorry about that.
> >
> > > Instead, you can find out what config NM is pushing to the supplicant
> > > by checking the NetworkManager logs, where NM will log lines like:
> >
> > Here are the relevant entries from the syslog file:
> >
> > I included the failed attempt to connect to the WPA protected network
> > named "southcentral" and the successful one to a non protected one named
> > "FreeWifi".
> >
>
> Thanks for the logs. I compared your network manager log with the one on my setup. Both are same. Basically network manager log doesn't show security info (WPA/WPA2, encryption mode etc). So we can't rely on that.
> I checked your kernel log shared in previous email. It's incomplete. It didn't include information when connection was actually attempted. Probably you can run "dmesg -c >> dmesg.log" in loop with some delay to capture complete info. Otherwise sharing "/var/log/messages" is also an option.
> I have created a driver debug patch(attached). Could you please apply it and share complete dmesg log?
>
> Btw, do you see the problem if AP is configured in WPA2 security mode?
>

You could check it by disabling the NetworkManager and connect using
wpa_supplicant manually. Sometimes NetworkManager does some problem
which is solved by disabling the NetworkManager.

Thanks,
UjjaL
