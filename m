Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:9423 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbYHFT31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 15:29:27 -0400
Received: by nf-out-0910.google.com with SMTP id d3so39888nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 12:29:25 -0700 (PDT)
Message-ID: <4899FB91.8070501@gmail.com> (sfid-20080806_212931_231415_10FEFCC3)
Date: Wed, 06 Aug 2008 20:29:21 +0100
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere
 fw
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>	 <1217825304.10989.20.camel@dv>	 <1217864060.3139.10.camel@localhost.localdomain>	 <1217970944.2908.11.camel@dv>	 <1217973349.30531.1.camel@localhost.localdomain>	 <1217976491.2908.36.camel@dv> <1218028414.16977.5.camel@localhost.localdomain>
In-Reply-To: <1218028414.16977.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Tue, 2008-08-05 at 18:48 -0400, Pavel Roskin wrote:
>> The userspace is welcome to keep a pool of all APs found by any scans,
>> but I don't think drivers should do it.
> 
> Drivers need to keep a reasonably complete list of APs internally for
> association anyway.  You don't want to have to do a full scan just to
> associate if you have results from 10 seconds ago that are still valid.

This is not an issue for orinoco cards, as the firmware selects the AP to use independently of any driver scanning. The requirement to use ap_scan=2 means that wpa_supplicant doesn't need to look at the scan results either (except maybe to verify the configuration matches).

> Furthermore, drivers need to keep cached results so that two processes
> can request results of a scan after the scan is complete.

But this does apply to orinoco.


Regards,

Dave.
