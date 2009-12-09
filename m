Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:35146 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbZLISlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 13:41:25 -0500
Received: by iwn1 with SMTP id 1so4776068iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 10:41:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fd145f7d0912091036o2a38a028p686f791744de0ae3@mail.gmail.com>
References: <fd145f7d0912082203l1d7ebc50j291cc36dd65a4408@mail.gmail.com>
	<43e72e890912090918m55d2816co9b04065e91e4d4f1@mail.gmail.com>
	<fd145f7d0912091013o702d1ee2ueb41a97ae43a0f27@mail.gmail.com>
	<43e72e890912091022r151ec85awb1844b3ac9c08871@mail.gmail.com>
	<fd145f7d0912091036o2a38a028p686f791744de0ae3@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 9 Dec 2009 10:41:12 -0800
Message-ID: <43e72e890912091041k31207f34r59cab066cc0f34d@mail.gmail.com>
Subject: Re: WARNING at mac80211_ieee80211_rx
To: Jeffrey Baker <jwbaker@gmail.com>
Cc: hostap@lists.shmoo.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 9, 2009 at 10:36 AM, Jeffrey Baker <jwbaker@gmail.com> wrote:
> On Wed, Dec 9, 2009 at 10:22 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Wed, Dec 9, 2009 at 10:13 AM, Jeffrey Baker <jwbaker@gmail.com> wrote:
>>> On Wed, Dec 9, 2009 at 9:18 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>> On Tue, Dec 8, 2009 at 10:03 PM, Jeffrey Baker <jwbaker@gmail.com> wrote:
>>>>> My access point with an AR9220 stopped passing traffic,
>>>>
>>>> Jeffrey, thanks for your report, can you be a little more verbose here
>>>> and elaborate as to what you mean by this? Do you mean that you stop
>>>> hostapd or that it hostapd is still running and that somehow you
>>>> notice it stops sending data between its associated STAs?
>>>
>>> Yes, hostapd was still running, however stations were unable to pass
>>> traffic.  Actually the AP also stopped sending beacons I think,
>>> because the AP no longer appeared in scans.  Restarting hostapd had no
>>> effect.  I rebooted the machine.
>>
>> Well something told mac80211 it was stopped, so curious if you can
>> provide more logs, both from hostapd and the kernel. Are you using git
>> version of hostapd?
>
> No, I'm using 0.6.9-3 package from Debian.

Can't say I keep track of the differences of hostapd from old stable
to now so can you try latest hostapd? I should note if using
compat-wireless you'll be using newer drivers and hostapd from git
will likely take advantage of any new features introduced. Can't also
say if the 0.6.9 release you are using might have issues expected with
using bleeding edge code so CC'ing hostap mailing list in case someone
there does.

> I don't see anything in
> daemon.log relating to hostapd other than the usual.  Here's a snippet
> around the time in question:
>
> Dec  8 12:28:00 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
> 802.11: authenticated
> Dec  8 12:28:00 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
> 802.11: associated (aid 1)
> Dec  8 12:28:00 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb RADIUS:
> starting accounting session 386D440C-00000046
> Dec  8 12:33:05 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
> 802.11: disassociated due to inactivity
> Dec  8 12:33:06 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
> 802.11: deauthenticated due to inactivity
> Dec  8 21:21:59 mango hostapd: wlan0: STA 00:1d:e0:38:18:d7 IEEE
> 802.11: authenticated
> Dec  8 21:21:59 mango hostapd: wlan0: STA 00:1d:e0:38:18:d7 IEEE
> 802.11: associated (aid 1)
> Dec  8 21:21:59 mango hostapd: wlan0: STA 00:1d:e0:38:18:d7 RADIUS:
> starting accounting session 4B1F3304-00000000
> Dec  8 21:46:43 mango hostapd: wlan0: STA 00:1d:e0:38:18:d7 IEEE
> 802.11: disassociated
> Dec  8 21:46:44 mango hostapd: wlan0: STA 00:1d:e0:38:18:d7 IEEE
> 802.11: deauthenticated due to inactivity
> Dec  8 22:35:26 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
> 802.11: authenticated
> Dec  8 22:35:26 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
> 802.11: associated (aid 1)
> Dec  8 22:35:26 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb RADIUS:
> starting accounting session 4B1F3304-00000001
> Dec  8 22:48:16 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
> 802.11: disassociated due to inactivity
> Dec  8 22:48:17 mango hostapd: wlan0: STA 04:1e:64:ec:22:eb IEEE
> 802.11: deauthenticated due to inactivity
>
> I'm not sure that this kernel stack is the definite cause of the AP
> stopping, because now that I look in kern.log I see many instances of
> it.  Just about one every other day, on average.

Can you still share the kernel log?

  Luis
