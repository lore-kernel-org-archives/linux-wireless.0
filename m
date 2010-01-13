Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56839 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab0AMSsH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 13:48:07 -0500
Subject: Re: [PATCH v2] cfg80211: fix channel setting for wext
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e891001131004s1eab8bf2jdf94bdd4b2d59281@mail.gmail.com>
References: <1263405850-10180-1-git-send-email-abhijeet.kolekar@intel.com>
	 <43e72e891001131004s1eab8bf2jdf94bdd4b2d59281@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 10:47:21 -0800
Message-ID: <1263408441.10649.6.camel@abhi-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-01-13 at 10:04 -0800, Luis R. Rodriguez wrote:
> On Wed, Jan 13, 2010 at 10:04 AM, Abhijeet Kolekar
> <abhijeet.kolekar@intel.com> wrote:
> > Patch fixes the bug at
> > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2139
> >
> > Currently we cannot set the channel using wext extension
> > if we have already associated and disconnected. As
> > cfg80211_mgd_wext_siwfreq will not switch the channel if ssid is set.
> > This fixes it by clearing the ssid.
> > Following is the sequence which it tries to fix.
> > modprobe iwlagn
> > iwconfig wlan0 essid ""
> > ifconfig wlan0 down
> > iwconfig wlan0 chan X
> >
> > wext is marked as deprecate.If we use nl80211 we can easily play with
> > setting the channel.
> >
> > Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> Is this a stable fix as well?
> 
Yes it can be a candidate for stable. I will resubmit.

Thanks
Abhijeet
>   Luis


