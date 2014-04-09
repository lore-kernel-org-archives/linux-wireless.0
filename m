Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52835 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaDIRez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 13:34:55 -0400
Message-ID: <5345849A.5090603@candelatech.com> (sfid-20140409_193458_655191_CF2298DC)
Date: Wed, 09 Apr 2014 10:34:18 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com> <5341F1A9.2030202@candelatech.com> <CA+BoTQndgEB7X-RUPPkxdjnp96LJzbv6=Q9K4XTTrky-QwE4Ww@mail.gmail.com> <53435F89.60500@candelatech.com> <CA+BoTQk6G4-h8HQENbK9snrXo6j6FW4D+07XKZMEEuvWiu03ww@mail.gmail.com> <53441D95.9000409@candelatech.com> <CA+BoTQkCDiUiV7dsg-myOZXQEB=B7JHH8NWm5BHsp1xExjLkSA@mail.gmail.com>
In-Reply-To: <CA+BoTQkCDiUiV7dsg-myOZXQEB=B7JHH8NWm5BHsp1xExjLkSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2014 11:25 PM, Michal Kazior wrote:

> Additional kernel config:
> 
> CONFIG_ATH10K_DEBUG=y
> CONFIG_ATH10K_DEBUGFS=y
> CONFIG_ATH10K_TRACING=y
> CONFIG_MAC80211_MESSAGE_TRACING=y
> 
> This probably requires this to be set first:
> 
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> 
> (it's in Kernel Hacking)
> 
> Once you have this you can use trace-cmd command to gathers logs:
> 
>   trace-cmd record -e mac80211 -e cfg80211 -e ath10k
> 
> And then perform whatever tortures on ath10k you wish.
> 
> This creates trace.dat in your current directory. The file can get
> pretty heavy and it might not fit into an email so we might need to
> transfer it "out of band" somehow.
> 
> If you use wpa_supplicant/hostapd you can pass -T argument to those to
> get all their messages into tracing as markers. This way you're able
> to get unified logs in one file with correct chronological order.

My version of supplicant does not support -T.  I have just sync'd down the
latest upstream hostapd code and will see if that adds the support.

Here are the trace output logs and /var/log/messages.

http://www.candelatech.com/tmp/ath10k-debug.tar.bz2

Test case is to create 32 stations, bring them up and get DHCP, start
10Mbps TCP traffic on each, and re-set them.  When resetting them system generally craps
out and user-space app trying to reset the ports hangs..  Logs are full
of ath10k driver error messages.

In previous tests, I think I was running traffic while bringing up
additional interfaces, so that is probably why I could not even bring
them up properly with your patches.

This is with your RFTv2 patches on top of some of my patches and
recent wl-ath tree.  This is using my modified firmware since this
test case cannot work at all on standard firmware.

Let me know if I can offer any additional logs or info.

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

