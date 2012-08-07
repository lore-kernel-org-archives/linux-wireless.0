Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2HGKWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 06:22:13 -0400
Date: Tue, 7 Aug 2012 12:22:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: unloading WiFi modules is usually triggering kernel crash
Message-ID: <20120807102208.GA12589@redhat.com> (sfid-20120807_122251_638707_C726E9B9)
References: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 31, 2012 at 01:54:52PM +0100, Pedro Francisco wrote:
> I've noticed in the past few days a pattern: sometimes nm-applet
> starts showing empty bars for the signal strength.

RSSI reporting problem or maybe NM issue. When you change kernel to
older or newer does this problem go away ?

> Running the script:
> sudo ifconfig wlan0 down; sleep 1
> sudo rmmod hp_wmi; sudo rmmod iwl3945; sudo rmmod iwlegacy; sudo rmmod
> mac80211; sudo rmmod cfg80211
> sleep 2; sudo rmmod rfkill; sync
> sudo modprobe rfkill; sudo modprobe cfg80211; sudo modprobe mac80211;
> sudo modprobe iwlegacy
> sudo modprobe iwl3945; sudo modprobe hp_wmi; sleep 1; sudo ifconfig wlan0 up

I run a bit modified script (I do not have hp_wmi.ko and rfkill.ko) for few
hours, and did not get any WARNING/crash. I used 3.5, can you check if that
problem is also fixed on your system on 3.5 or newer.

Stanislaw
