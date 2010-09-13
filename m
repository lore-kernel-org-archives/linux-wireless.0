Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37370 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0IMXM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 19:12:27 -0400
Received: by fxm16 with SMTP id 16so3506110fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 16:12:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: ath9k, virtual stations, and WPA:  No luck so far.
Date: Tue, 14 Sep 2010 01:12:23 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4C8EA7D6.4040101@candelatech.com>
In-Reply-To: <4C8EA7D6.4040101@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009140112.23751.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 September 2010 00:38:14 Ben Greear wrote:
> I'm having no luck getting WPA to work with two STA interfaces
> on the same ath9k NIC.
>
> So far, I've done a bunch of hacking to only scan on the one
> channel that we're currently using if 1+ stations are associated,
> and some other logic to not call change-channel logic unnecessarily.
>
> Currently, I see wlan0 able to associate and authenticate with wpa_supplicant,
> but sta1 (the other STA interface), won't work.  A snippet from it's supplicant
> log is below.  No-encryption and WEP seems to work fine.
> If anyone has any suggestions as to where I should look to debug this,
> I'd welcome the pointers!

First things first: Have you tried your "idea" with mac80211_hwsim?
Also, have you disabled the hardware crypto accelerator? Because if
you spend one second to look at ath9k's set_key code, you "will see"
why the hardware has a problem dealing with multiple keys for a
single MAC (of your AP).

> I'll work on cleaning up the scan patch for review as well.
