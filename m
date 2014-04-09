Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37092 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933983AbaDIUcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 16:32:41 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so3904547wib.10
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 13:32:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5345A814.8090301@sp.consulting.lsexperts.de>
References: <534464F9.1080805@sp.consulting.lsexperts.de> <1397029645.4964.1.camel@jlt4.sipsolutions.net>
 <5345A814.8090301@sp.consulting.lsexperts.de>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 10 Apr 2014 02:02:19 +0530
Message-ID: <CABPxzYLdo39jh67j0t-+kaP5aEp8m1MT4WKmeAwTk7N20roaSA@mail.gmail.com> (sfid-20140409_223245_448354_36C12566)
Subject: Re: iwlwifi: Invalid RXON when trying to join IBSS network
To: Stefan Pietsch <stefan.pietsch@lsexperts.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 10, 2014 at 1:35 AM, Stefan Pietsch
<stefan.pietsch@lsexperts.de> wrote:
>
> On 09.04.2014 09:47, Johannes Berg wrote:
> > On Tue, 2014-04-08 at 23:07 +0200, Stefan Pietsch wrote:
> >> Dear list,
> >>
> >> trying to join an IBSS network gives me these kernel messages:
> >>
> >>
> >>
> >> [  383.857059] iwlwifi 0000:03:00.0: mac/bssid mcast!
> >
> > How did you manage to get a multicast address as the BSSID?
> >
> > johannes
>
>
> I changed the BSSID on the remote station.
>
> This seems to make no difference:
>
>
>
> [  489.184233] wlan0: Trigger new scan to find an IBSS to join
> [  489.320584] wlan0: Selected IBSS BSSID 55:44:33:22:11:00 based on
> configured SSID
> [  489.381485] iwlwifi 0000:03:00.0: mac/bssid mcast!
> [  489.381492] ------------[ cut here ]------------
> [  489.381516] WARNING: CPU: 2 PID: 206 at
> /build/linux-l673CV/linux-3.13.7/drivers/net/wireless/iwlwifi/dvm/rxon.c:843
> iwlagn_commit_rxon+0x551/0xbb0 [iwldvm]()
> [  489.381519] Invalid RXON (0x10), channel 1
>
 Even this MAC is a group mac address (55 in the MSB).
can you try with 00 as MSB?
