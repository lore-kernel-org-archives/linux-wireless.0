Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:21691 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYHFVIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 17:08:55 -0400
Received: by nf-out-0910.google.com with SMTP id d3so63525nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 14:08:53 -0700 (PDT)
Message-ID: <489A12E2.8060909@gmail.com> (sfid-20080806_230859_543138_25FA6071)
Date: Wed, 06 Aug 2008 22:08:50 +0100
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere
 fw
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>	 <1217825304.10989.20.camel@dv>	 <1217864060.3139.10.camel@localhost.localdomain>	 <1217970944.2908.11.camel@dv>	 <1217973349.30531.1.camel@localhost.localdomain>	 <1217976491.2908.36.camel@dv>	 <1218028414.16977.5.camel@localhost.localdomain>	 <4899FB91.8070501@gmail.com> <1218056165.12240.0.camel@localhost.localdomain>
In-Reply-To: <1218056165.12240.0.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Wed, 2008-08-06 at 20:29 +0100, Dave wrote:
>> Dan Williams wrote:
>>> On Tue, 2008-08-05 at 18:48 -0400, Pavel Roskin wrote:
>>>> The userspace is welcome to keep a pool of all APs found by any scans,
>>>> but I don't think drivers should do it.
>>> Drivers need to keep a reasonably complete list of APs internally for
>>> association anyway.  You don't want to have to do a full scan just to
>>> associate if you have results from 10 seconds ago that are still valid.

>> This is not an issue for orinoco cards, as the firmware selects
>> the AP to use independently of any driver scanning. The requirement to
>> use ap_scan=2 means that wpa_supplicant doesn't need to look at the scan
>> results either (except maybe to verify the configuration matches).

> Well, since the driver supports SSID scanning, we can use ap_scan=1
> anyway.  ap_scan=2 is actually pretty evil since it depends on WEXT
> ordering and whatnot.

ap_scan=1 requires the use of SIOCSIWWAP (to set desired BSSID), which
the Agere firmware doesn't support. The firmware only supports setting a
desired SSID (via SIOCSIWESSID), so Agere based orinoco is stuck with
ap_scan=2 :(

Symbol and Intersil don't have this problem.

Dave.
