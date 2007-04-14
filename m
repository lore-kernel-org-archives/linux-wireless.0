Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:46434 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbXDNXLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 19:11:25 -0400
Received: by ug-out-1314.google.com with SMTP id 44so802248uga
        for <linux-wireless@vger.kernel.org>; Sat, 14 Apr 2007 16:11:24 -0700 (PDT)
Message-ID: <1ba2fa240704141611s6f010075o1c7d5d69e7a30cf2@mail.gmail.com>
Date: Sun, 15 Apr 2007 02:11:23 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: [PATCH 0/4] mac80211 and drivers: Improve wireless statistics
Cc: "John Linville" <linville@tuxdriver.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Michael Buesch" <mb@bu3sch.de>, bcm43xx-dev@berlios.de,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46214155.20106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <46211955.4080006@lwfinger.net>
	 <1ba2fa240704141300w2ec2beabm9cd1376c1b9ef2bb@mail.gmail.com>
	 <46214155.20106@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/15/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> Tomas Winkler wrote:
> > Those are really bad names.
> > __signal__ is not meaning a value __signal level__ or __signal
> > strength__ means value
> > __level__ is too general to describes anything
> > RSSI on other hand is well defined. Maybe it's too hw/vendor dependent
> > to use in stack
> > but at least its names says what it is.
> > Quality should be a relative number depends on maxim
> > I don't think this renaming make things clearer
> > Tomas
>
> Perhaps my names are bad; however, the existing system is broken. With it, passing the rssi value
> and the signal strength from bcm43xx-mac80211 results the following output from iwconfig: "Link
> Quality=216/146  Signal level=-197 dBm  Noise level=-63 dBm". In bcm43xx-softmac, the code in the
> driver is identical and results in "Link Quality=90/100  Signal level=-36 dBm  Noise level=-69 dBm".
>
> When I proposed a patch to fix mac80211, Michael Wu NACKed it and requested the name changes I
> propose here. I don't care what names things get, but it needs to be fixed!
>
> Larry
>
Yeah, I wasn't much constructive in my critique
So here is my humble suggestion. I suggesting not to kill rssi.
u8 rssi  (signal is already in rSsi)
s8 signal_level (always in dBm)
s8 signal_noise
u8 link_qual

rssi should stay rssi and its range is from 0 to 255 i.e. one byte. 0
means no signal
and maximal value should be set by underlying driver.

signal_level is in dBm.
There should not be mixing between signal_level and rssi as it is now in wext.
'man iwconfig'
 rssi -  Received signal strength (RSSI - how strong the received
signal is). May be arbitrary units or dBm,

The confusion comes from fact that
signal_level (dBm) is usually computed by some magic equation from
RSSI  but they are not the same.
In general wext should be interested only in dBm values for 'Signal Level'

Link quality computation should be left to underlying driver as it is
totally hw dependent and may includes different parameters that are
hard to generalize in subsystem level.
It should be equal  neither  to rssi  nor to  signal level.

The only reason to keep also rssi is that it's necessary for the
underlying driver and it's easier and to compute with.

As you can see the in the  code it self the intention of wext was just that.

/*
 *      Quality of the link
 */
struct  iw_quality
{
        __u8            qual;           /* link quality (%retries, SNR,
                                           %missed beacons or better...) */
        __u8            level;          /* signal level (dBm) */
        __u8            noise;          /* noise level (dBm) */
        __u8            updated;        /* Flags to know if updated */
};
