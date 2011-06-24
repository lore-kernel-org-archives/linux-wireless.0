Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38444 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1FXOrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 10:47:00 -0400
Received: by eyx24 with SMTP id 24so947497eyx.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 07:46:59 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 Jun 2011 09:43:50 -0500
Message-ID: <BANLkTikB3OS+=w5qO6sb2jABhUSeGh86Tg@mail.gmail.com> (sfid-20110624_164704_803563_1E665427)
Subject: cfg80211 'iw reg set' no longer works after trying to set invalid
From: Laura Nayman <lnayman@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 'iw reg set' no longer works after trying to set invalid country
code

You can change the wireless region by using 'iw set reg'. Normally you can
switch back and forth just fine...

# iw reg set US
# iw reg get | grep country
country US:
# iw reg set JP
# iw reg get | grep country
country JP:
# iw reg set US
# iw reg get | grep country
country US:


However, if we try to use an invalid country code, such as XX:
# iw reg set XX
# iw reg get | grep country
country US:
... it doesn't take. Okay, no big deal. Let's try setting it back to JP:
# iw reg set JP
# iw reg get | grep country
country US:

We're now stuck at the country code we were at before we put the invalid one
in.

In dmesg, this exchange looks like:
# dmesg | grep cfg80211
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
cfg80211: Calling CRDA for country: JP
cfg80211: Regulatory domain changed to country: JP
cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
cfg80211: Calling CRDA for country: XX
... and we're stuck there.

What looks to be happening is that the kernel uses udev to call /sbin/crda
with a new COUNTRY= setting, but /sbin/crda bails out with -1 because of 'No
country match in regulatory database', and never sends a netlink message
back to the kernel to give it the regulatory information for that country.
The kernel then seems to be stuck waiting for a message that will never
come.

The only way I can figure to unstick it is to reboot.
