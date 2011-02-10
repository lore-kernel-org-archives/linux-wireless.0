Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58832 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1BJShU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 13:37:20 -0500
Received: by qwa26 with SMTP id 26so970539qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 10:37:20 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D0571DFA0@RockMX01.rock.corp>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D0571DFA0@RockMX01.rock.corp>
Date: Thu, 10 Feb 2011 19:37:20 +0100
Message-ID: <AANLkTikQnCfXZ+exMgLpLZxANFxFDkqp8v_HzXWbb=dM@mail.gmail.com>
Subject: Re: FW: hostapd problem on reconfig (SIGHUP)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Chaoxing Lin <CLin@3eti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please, see the wiki at <wireless.kernel.org>, especially [1] and [2].

- Sedat -

[1] http://wireless.kernel.org/en/users/Support
[2] http://wireless.kernel.org/en/developers/MailingLists

On Thu, Feb 10, 2011 at 3:55 PM, Chaoxing Lin <CLin@3eti.com> wrote:
> Sorry if this message is duplicate.
>
> I am confused which email address to send.
> linux-wireless@vger.kernel.org or linux-wireless-owner@vger.kernel.org
>
>
>
> -----Original Message-----
> From: Chaoxing Lin
> Sent: Wednesday, February 09, 2011 5:23 PM
> To: 'linux-wireless-owner@vger.kernel.org'
> Subject: hostapd problem on reconfig (SIGHUP)
>
>
> Hello Experts,
>
> I see a problem while testing the latest hostapd/kernel/wpa_supplicant. I believe the problem in on hostapd side.
> It is easy to recreate the problem. So it can be an easy fix for hostapd maintainer.
>
> Thanks
>
>
> Problem: hostapd not working after SIGHUP signal
>
> Symptoms
>
> 1. If there's a client associated, a SIGHUP signal to hostapd can cause problem that no clients can associate (almost 100% reproducible)
>
> 2. "segmentation fault" happens a few times(not all the time)  to hostapd by repeating SIGHUP and SIGUSR1 to hostapd.
>
> 3. Another minor thing. Actually a suggestion, hostapd does not need to re-config if configuration file is not changed. This is preferred because when hostapd controls multiple radios (e.g hostapd radio1.conf radio2.conf), it’s desirable that service on other radio is not disrupted when one of the conf is changed.
>
>
> Some facts:
>     a. The already associated client still thinks itself associated. This is verified by "iw wlan0 link" on client side.
> It timed out later on and can no longer associate.
>
>     b. driver (ath9k in kernel 2.6.38-rc4, operate over ar9380) says it has already deauthenticated the clients per
>            hostapd flush instruction. This is verified by "iw wlan0 station dump" on ap side.
>         I sniffed the air. Deauthentication packets (as broadcast) were sent out by driver. The associated client does not
> deauthenticate and re-associate (bug in wpa_supplicant?).
>
>     c. hostapd still thinks the associated client is associated, which is wrong. This is verified by "killall -SIGUSR1 hostapd"
>        followed by "cat /tmp/hostapd.dump"
>
>     d. Tried to use new client to associate. No success.
>        Both old and clients stuck
>
> Workaround:
>
>          Do NOT use SIGHUP. User has to kill hostapd and restart hostapd.
>
> Software version info:
> 1. hostapd-0.7.3 and the latest unofficial snapshot release 0.8-snapshot
> 2. Tried both kernel 2.6.38-rc3 and 2.6.38-rc4.
> 3. ath9k operates over AR9380 chipset
> 4. wpa_supplicant-0.7.3 is used for client test.
>
>
