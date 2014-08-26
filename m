Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:55181 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaHZQju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 12:39:50 -0400
Received: by mail-ig0-f174.google.com with SMTP id c1so4802475igq.7
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2014 09:39:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2918019.CXq3d6nCM0@debian64>
References: <CALoNvyuUxX7Wv+nRnPDW_PdO3BsJbTfrF-MU7uoNuUbAXrbZnA@mail.gmail.com>
	<2918019.CXq3d6nCM0@debian64>
Date: Tue, 26 Aug 2014 09:39:49 -0700
Message-ID: <CALoNvysRU5oTXXeR891cb3Up73JLz6vefAMRXe3d0DHo1eQbbg@mail.gmail.com> (sfid-20140826_183954_629886_CA8B0524)
Subject: Re: rtl8192su driver compatibility with a rtl8188su device
From: David Madsen <david.madsen@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 26, 2014 at 8:19 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:

> The rtl8192su.git comes with two sets of firmware (for two different
> driver architectures).
>
> The rtl8712u firmware is much more integrated and can performs several
> high-level procedures (high-level for firmware) like scanning, link setup
> (auth, assoc, reassoc, deassoc, deauth), link monitoring, rate control,
> crypto, erp, beacon generation, etc... with little to no help from the
> driver. This firmware is used by the (staging) rtl8712u, v2.6.6.0.20120405
> and (abandoned) r92su driver.
>
> the rtl8192su* firmware can't do any of those. The driver +
> mac80211-stack has to perform the all the necessary procedures
> (starting from the phy/rf setup). This firmware is used by rtl8192su,
> AR-7284WnAB, windows and mac osx drivers.

Thanks for the clarifications on the differing firmwares.  I think
this is likely my first issue (using an incorrect firmware with
rtl8192su driver stack).

> The monitor mode of the rtl8712/r92su driver is limited by the firmware
> too. For example it is not possible to set the channel bandwidth to 40MHz.
> If that is not a problem and you don't need injection, you can try to get
> the abandoned r92su driver to work. It uses cfg80211 (not the old wireless
> extension) and has support for the monitor mode.

Thanks for the pointer to the r92su driver.  I think this may address
my immediate needs (basic RX monitoring).

>> If not I would be interested in helping out with porting/testing/debugging
>> to aid in getting the chipset functional.
> That would be: figuring out why the device dies after a random amount of time.
> This could be caused by a missing watchdog check or the firmware detected a
> problem and needs a reset. I think this will probably require someone taking
> USB traffic dumps from both the mac os x or windows driver and check what they
> do differently. [Not very trivial]

If I can get the device working I should be able to get the traces
(though analyzing them is another story).

Thanks for the help.

--
David Madsen
