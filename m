Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:34437 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab1BJUkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 15:40:14 -0500
Date: Thu, 10 Feb 2011 22:40:10 +0200
From: Jouni Malinen <j@w1.fi>
To: Chaoxing Lin <CLin@3eti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: FW: hostapd problem on reconfig (SIGHUP)
Message-ID: <20110210204010.GA7571@jm.kir.nu>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D0571DFA0@RockMX01.rock.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D0571DFA0@RockMX01.rock.corp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 10, 2011 at 02:55:14PM +0000, Chaoxing Lin wrote:
> I see a problem while testing the latest hostapd/kernel/wpa_supplicant. I believe the problem in on hostapd side.

Could you please re-test with the current hostap.git snapshot?

> 1. If there's a client associated, a SIGHUP signal to hostapd can cause problem that no clients can associate (almost 100% reproducible)

I would assume the clients could still re-associate if you were to
manually request them to do so. They may not do this automatically until
the STA entry in hostapd times out (though, with the change I just added
to hostap.git, this happens immediately in case of SIGHUP).

> 2. "segmentation fault" happens a few times(not all the time)  to hostapd by repeating SIGHUP and SIGUSR1 to hostapd.

Fixed.

> 3. Another minor thing. Actually a suggestion, hostapd does not need to re-config if configuration file is not changed. This is preferred because when hostapd controls multiple radios (e.g hostapd radio1.conf radio2.conf), it’s desirable that service on other radio is not disrupted when one of the conf is changed. 

How frequently are you changing the configuration? Is this really a big
enough issue to justify extra complexity in figuring out whether the
configuration has changed? Anyway, an easier approach would be to add a
new control interface command RECONFIGURE (which is already available in
wpa_supplicant) which would allow the reconfiguration to be done
separately for a single radio.

>     a. The already associated client still thinks itself associated. This is verified by "iw wlan0 link" on client side. 
> 　　It timed out later on and can no longer associate.

The client was probably in sleep state when the AP sent out the
broadcast Deauthentication frames or for some other reason missed it at
the time. It should be able to reassociate after the timeout, though.. I
did not see issues with this in my tests.

>     b. driver (ath9k in kernel 2.6.38-rc4, operate over ar9380) says it has already deauthenticated the clients per 
>            hostapd flush instruction. This is verified by "iw wlan0 station dump" on ap side.
>         I sniffed the air. Deauthentication packets (as broadcast) were sent out by driver. The associated client does not 
> 　　deauthenticate and re-associate (bug in wpa_supplicant?).

Please let me know if you can still reproduce this after having updated
hostapd to the current hostap.git snapshot.

>     c. hostapd still thinks the associated client is associated, which is wrong. This is verified by "killall -SIGUSR1 hostapd"
>        followed by "cat /tmp/hostapd.dump"

Fixed.

>     d. Tried to use new client to associate. No success.
>        Both old and clients stuck 

Strange.. I have been unable to reproduce this. What kind of hostapd
configuration are you using?

-- 
Jouni Malinen                                            PGP id EFC895FA
