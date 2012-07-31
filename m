Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55677 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2GaNPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 09:15:20 -0400
Date: Tue, 31 Jul 2012 09:13:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>,
	johannes@sipsolutions.net
Subject: Re: unloading WiFi modules is usually triggering kernel crash
Message-ID: <20120731131311.GA19067@tuxdriver.com> (sfid-20120731_151525_010497_920AD533)
References: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 31, 2012 at 01:54:52PM +0100, Pedro Francisco wrote:
> I've noticed in the past few days a pattern: sometimes nm-applet
> starts showing empty bars for the signal strength.
> 
> Running the script:
> sudo ifconfig wlan0 down; sleep 1
> sudo rmmod hp_wmi; sudo rmmod iwl3945; sudo rmmod iwlegacy; sudo rmmod
> mac80211; sudo rmmod cfg80211
> sleep 2; sudo rmmod rfkill; sync
> sudo modprobe rfkill; sudo modprobe cfg80211; sudo modprobe mac80211;
> sudo modprobe iwlegacy
> sudo modprobe iwl3945; sudo modprobe hp_wmi; sleep 1; sudo ifconfig wlan0 up
> 
> usually triggers a kernel crash. This has happened twice so far. I
> tried it now for the third time but it didn't crash.
> 
> Logs (running with slub_debug ):
> https://dl.dropbox.com/u/1332655/WiFi-issues/notTainted-cfg80211_mlme_disassoc-WARNING.log
> https://dl.dropbox.com/u/1332655/WiFi-issues/alreadyTainted-debug_print_object-WARNING.log
> (debug_print_object-WARNING was caused by running the above script
> rmmoding things)
> https://dl.dropbox.com/u/1332655/WiFi-issues/iw_dev_scan.log
> https://dl.dropbox.com/u/1332655/WiFi-issues/gshell-wifiBars_empty.png
> 
> Any ideas on what is going on? Looking at other mails around here it
> seems not to be driver specific, at least the cfg80211_mlme_disassoc
> part.

Looks the same as this one, FWIW...

	https://bugzilla.redhat.com/show_bug.cgi?id=834158

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
