Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wp227.webpack.hosteurope.de ([80.237.132.234]:41556 "EHLO
        wp227.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751295AbdJaPrW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 11:47:22 -0400
Subject: Re: ath10k: Wifi slow on the XPS13 (9360) (QCA6174)
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <5a4860eb-3734-7587-d81f-9c3de6ff11c8@leemhuis.info>
 <46f918c5-b07d-e397-2f3d-8136c7c1a8f3@qti.qualcomm.com>
 <74a979dc-f06d-be9d-7c3f-359cd481d16c@leemhuis.info>
 <87tvyi4dnv.fsf_-_@kamboji.qca.qualcomm.com>
From: Thorsten Leemhuis <linux@leemhuis.info>
Message-ID: <94b4b903-afeb-439b-2b96-81835ab6ebef@leemhuis.info> (sfid-20171031_164821_005394_404D3E32)
Date: Tue, 31 Oct 2017 16:47:18 +0100
MIME-Version: 1.0
In-Reply-To: <87tvyi4dnv.fsf_-_@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lo! On 29.10.2017 08:27, Kalle Valo wrote:
> [..]
> sorry for the late reply, I'm having problems keeping up with all the
> email. 

No worries, this problem is nothing new, I just thought it might be good
to finally bring this to ath10k, as I got the impressions it had not
gotten proper attention there yet.

> Thorsten Leemhuis <linux@leemhuis.info> writes:
>> On 03.10.2017 01:40, Ryan Hsu wrote:
>>> On 10/01/2017 01:59 AM, Thorsten Leemhuis wrote:
>>>>> ath10k_pci 0000:3a:00.0: Direct firmware load for
>>>>> ath10k/pre-cal-pci-0000:3a:00.0.bin failed with error -2
>>>>> ath10k_pci 0000:3a:00.0: Direct firmware load for
>>>>> ath10k/cal-pci-0000:3a:00.0.bin failed with error -2
>>>> Do they have anything to do with this? Hardware is
>>> This error message is confusing since QCA6174 is not supporting
>>> pre-calibration feature, this reminds me that we need to clean this up.
>> I guess that would be good to avoid confusion. But while at it: If you
>> have a minute, could you please explain to me how to properly set up the
>> wifi firmware files for my Dell XPS13 (9360)? The reasons why I'm
>> asking: Sending data via wifi is really slow on my laptop (scp copies
>> only get 2 to 5 MByte/s on networks that are known to be a lot faster).
>> I wonder if the firmware files or the calibration data is part of the
>> reason wifi Tx is slow. The machine is normally shipped with a slightly
>> enhanced Ubuntu 16.04. That among others contains a package with the
>> machine specific files board.bin and board-2.bin that replace the files
>> normally installed in /lib/firmware/ath10k/QCA6174/hw3.0/ Are those
>> machine specific files crucial to have or are the one from the
>> linux-firmware repo good enoguh? I'm using Fedora and could copy the
>> ones from Ubuntu over, but obviously they will get overwritten every
>> time Fedora ships a new linux-firmware package – IOW: every few weeks :-/
> Yes, the board file can affect throughtput, _both_ TCP and UDP. I don't
> know what board files Ubuntu is shipping but we should try to get those
> into upstream.

Out of curiosity (don't spend time answering this is you are busy): Is
there even a mechanism for this? Kind of "take
firmwaredir/board-Dell_Inc.-XPS_13_9360.bin if it exists and
firmwaredir/board.bin otherwise? Or can one file serve all machines?

>> Side note: You find a lot of reports about slow wifi is you search the
>> net with terms like "9360 wifi slow linux". Ubuntu fixed that a few
>> months ago with this patch:
>> http://kernel.ubuntu.com/git/ubuntu/ubuntu-xenial.git/commit/?id=9690f19f07fee2acb2b04ea5eaa5db184ee175d5
>> Some bugs about this:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1692836
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1670041
> But this again about interraction between ath10k and TCP stack. And it
> _only_ affects TCP, UDP should be unaffected.

Ahh, sorry, missed that. Seems I didn't properly read the second
launchpad link above. Sorry.

> So whenever testing
> throughput please always measure both TCP and UDP because then it's
> easier to pinpoint the reason.

Is there any data I could provide that might help getting this soled
once and for all?

>> But from what I gathered by searching the net and asking on #ath10k I
>> got the impression that patch is a massive ugly hack and no way
>> acceptable upstream.  Is that correct?
> Yes, it's a horrible hack and I cannot apply that. And like you said
> #1692836, also Eric Dumazet (one of TCP maintainers) agrees with that
Ahh, had missed that, sorry.

>> If yes: is there maybe a proper fix out there somewhere?
> Unfortunately there still is no good solution. In a week there's Netdev
> 2.2 and we have Linux Wireless summit there. We should bring up this
> topic there.

Thx for picking this up, much appreciated! Ciao, Thorsten
