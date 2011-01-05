Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46101 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1AEG5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 01:57:45 -0500
Received: by wwa36 with SMTP id 36so15983923wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 22:57:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTin0W1_Tjr1zj0D0U+VeBpoGFRmB9iCdOfnMB-nR@mail.gmail.com>
References: <AANLkTim0AM3=T=TMu79ZQi79+CKANamBcz620n2xm8bW@mail.gmail.com>
	<201101041946.56978.helmut.schaa@googlemail.com>
	<AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
	<AANLkTi=KFG-7GPw2=6VTZqEceEcJM6OdWoTQaN_83NqP@mail.gmail.com>
	<AANLkTikREOFV+WGWgo9yh9bTrz346kF0muKE8gs5N+km@mail.gmail.com>
	<AANLkTikCcgEiqeJLDn0Pes_2=usj6ZXo7hhL48MBnH_-@mail.gmail.com>
	<AANLkTin0W1_Tjr1zj0D0U+VeBpoGFRmB9iCdOfnMB-nR@mail.gmail.com>
Date: Tue, 4 Jan 2011 22:57:44 -0800
Message-ID: <AANLkTimCsvR2zBfS+oCudhcUz68qPJhXM9-eu1L-FWHp@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
From: Aleksandar Milivojevic <alex@milivojevic.org>
To: Wolfgang Kufner <wolfgang.kufner@gmail.com>
Cc: Luis Correia <buga@loide.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 4, 2011 at 2:31 PM, Wolfgang Kufner
<wolfgang.kufner@gmail.com> wrote:
> Hi Aleksandar,
>
> I know just about nothing about regulatory domains but I think it
> might be good to try with a current compat-wireless next. I notice
> that the these log lines:
>
> "cfg80211: Received country IE:"
> "cfg80211: We intersect both of these and get:"
>
> do not exist in linux-next anymore since this commit:
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=4f366c5dabcb936dd5754a35188bd699181fe1ce
>
> Maybe a fix for this issue is already in compat-wireless.

Might be.  I'll try compiling linux-next and see if it helps (could be
few days, I need to setup this box for the task first).

In the mean-time I played with things a bit.

I've created /etc/modprobe.d/cfg80211 as follows:
options cfg80211 ieee80211_regdom=US

This seems to have set user preference so that enabled frequencies are
set correctly initially (and also instead of switching to "world" (00)
when it looses connection to my AP, now it switches to US instead).

Next, I installed the "iw" tool, and it showed interesting results.
When connected to my Apple wireless router (5GHz WiFi-a/n network), I
get:

# iw reg get
country 98:
	(5170 - 5250 @ 40), (3, 17)
	(5735 - 5835 @ 40), (3, 30)

The log files show switching from US to 98 and back to US, but output
of iw reg get always claims country is 98 with above two frequency
ranges.

On the other hand, if I connect to my Linksys router (2.4GHz WiFi-b/g
network), there's no mention in log files about any switching between
regulatory domains, and output of iw reg get shows country correctly
set to US:

# iw reg get
country US:
	(2402 - 2472 @ 40), (3, 27)
	(5170 - 5250 @ 40), (3, 17)
	(5250 - 5330 @ 40), (3, 20), DFS
	(5490 - 5600 @ 40), (3, 20), DFS
	(5650 - 5710 @ 40), (3, 20), DFS
	(5735 - 5835 @ 40), (3, 30)

However, after several minutes, the connection to my Linksys WiFi
router fails again with nothing useful logged, the green LED on
WUSB600N wireless adapter goes off permanently, and attempt to connect
to any network (either of my two WiFi networks) fails.  NetworkManager
still shows list of all networks (on both 2.4GHz and 5GHz bands), and
output of iw reg get still shows country set to US and all frequencies
listed for US as per above.
