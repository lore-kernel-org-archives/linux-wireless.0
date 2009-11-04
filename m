Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34860 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZKDBr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 20:47:27 -0500
Received: by bwz27 with SMTP id 27so8326202bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2009 17:47:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cb0375e10911031538n62fe7473x4dd41329b9264b5c@mail.gmail.com>
References: <cb0375e10911031538n62fe7473x4dd41329b9264b5c@mail.gmail.com>
Date: Tue, 3 Nov 2009 19:47:31 -0600
Message-ID: <51058d550911031747t3d038294qfca3f96b2cb69de1@mail.gmail.com>
Subject: Re: iwlwifi connection troubles, maybe aggregation related
From: Greg Oliver <oliver.greg@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 3, 2009 at 5:38 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> Hi all-
>
> My laptop (Intel 5350) has trouble using the wireless networks here.
> I'm at MIT, which has a bunch of Cisco 1250 AP's (dual-band, MIMO,
> etc).  Running Windows, everything works perfectly.  On Linux
> (2.6.31-rc5, but I've seen problems with other, older kernels as
> well), it sometimes works, but I frequently find the network almost
> completely unusable.  I can associate and ping just fine, but, as soon
> as I try to send any significant amount of data, I can no longer
> transmit.  I can still receive both broadcast and unicast frames, but
> the network doesn't see anything I send.  An older laptop (presumably
> with 4965,
>
> This seems to be correlated with a line like:
>
> iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:21:d8:49:4a:52 tid = 0
>
> appearing in dmesg.
>
> Running "iw dev wlan0 disconnect" will make the connection start
> working until I try to send data again (presumably because either NM
> or wpa_supplicant will reassociate).
>
> Turning on or off power management and fiddling with
> no_sleep_autoadjust makes no difference.  Setting tx_agg_tid_enable to
> zero in debugfs while the connection was working seemed to make it a
> little more reliable (it lasted long enough to do "git pull" but not
> much longer).
>
> After running "iw dev wlan0 disconnect" a few times, I start to get
> errors like this:
>
> [18078.209635] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
> [18078.313461] iwlagn 0000:03:00.0: No space for Tx
> [18078.313467] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
> enqueue_hcmd failed: -28
> [18078.313470] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
> [18078.522409] iwlagn 0000:03:00.0: No space for Tx
> [18078.522414] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
> enqueue_hcmd failed: -28
>
> The driver doesn't recover until I do "echo 1 >
> /sys/kernel/debug/ieee80211/phy0/reset"  Oddly enough, after resetting
> just now, I couldn't trigger the failure again, even though it was
> 100% reproducible before resetting.

I too have been battling this issue with a 5300 for quite some time..
I *thought* it was fixed with the 2.6.32 compat-wireless series
(excluding the -rc4 which kernel oops'ed), only to find out that it
was because I was farther away from the AP, and negotiating lower
rates...

My card seems to work just fine through MCS13, about 60% at MCS14, and
almost always fails at 15..  The intel folks were very helpful in
trying to fix it, but it was never actually resolved.  I've been
battling it so long though, though, I was just prepared to wait for
the magic fix to just show up one day :)

My machine (like yours), once reliably connected will preform 100%
until I reboot or unload the module..  It may take 10 insmods to get a
reliable connection though..

I guess what I'm saying is that I can help debug the issue as well...
It would be very nice to have this go away...  I have an icon on my
desktop to reload the wireless subsystem if that tells you how many
times I have to do it until it loads up reliably...

-Greg
