Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36296 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756086AbcILPJ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 11:09:28 -0400
Received: by mail-oi0-f65.google.com with SMTP id o7so3769857oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 08:09:27 -0700 (PDT)
Subject: Re: Support of rtl8723bs
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Bastien Nocera <hadess@hadess.net>
References: <688574b6-1141-f408-d397-535f1f69999e@hanno.de>
 <1473683031.2930.3.camel@hadess.net> <wrfjtwdli39u.fsf@redhat.com>
Cc: Hanno Zulla <abos@hanno.de>, linux-wireless@vger.kernel.org,
        anthony.wong@canonical.com
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5b920339-abcd-0fc4-f054-039155c531a0@lwfinger.net> (sfid-20160912_170932_168892_1CBAE8E3)
Date: Mon, 12 Sep 2016 10:09:25 -0500
MIME-Version: 1.0
In-Reply-To: <wrfjtwdli39u.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2016 09:47 AM, Jes Sorensen wrote:
> Bastien Nocera <hadess@hadess.net> writes:
>> On Mon, 2016-09-12 at 11:20 +0200, Hanno Zulla wrote:
>>> Hi Jes,
>>> hello linux-wireless,
>>> it as a guinea pig to test on my hardware. The newer vendor driver
>>> crashed on Ubuntu' 4.4 sources and doesn't compile yet on Ubuntu 4.8-
>>> rc
>>> sources.
>>> https://github.com/anthonywong/rtl8723bs/issues/1
>>
>> I really don't care about the vendor driver. There's no way to track
>> changes other than through code dumps.
>>
>> Longer term, it seems likely that improving Jes' driver is the way to
>> go. At least there's 170k less lines of code to read in the rtl8723bs
>> driver to get things going.
>
> Longer term I think it makes sense to add SDIO support to rtl8xxxu. The
> differences between the USB version and the SDIO version are rather
> small.
>
> That said, I have quite a lot of things on my TODO list so it is going
> to take some time until I can look at this. It may make sense to pull
> a cleaned up version of the vendor driver into staging until then if
> there is a desperate need for it, but otherwise any help would be
> appreciated :)

I agree with Jes that adding support for SDIO in rtl8xxxu would be a useful 
step. If anyone wants to help, that would be the place to start. I disagree that 
this driver should be dumped into staging. If one reads the various issues 
associated with the GitHub repo, you will see that this driver has severe 
problems that are unlikely to be fixed with a cleanup. The latest report is that 
the driver causes the loss of clock interrupts, which is not surprising given 
the sorry state of locking in the driver.

Complicating matters is that no one outside Realtek ever sees the details of any 
commit. At intervals, they make a dump of their current code and release it. The 
differences between two such releases amounts to many thousands of lines, and 
finding any changes due to bug fixes is a "needle in the haystack" problem.

Larry
