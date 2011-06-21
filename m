Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53023 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1FUPC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 11:02:58 -0400
Received: by iyb12 with SMTP id 12so2916607iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 08:02:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110621130752.GB8462@internetdog.org>
References: <BANLkTimvMcb5yRHSE91VPTLdy7k5WEDo0Q@mail.gmail.com>
	<20110621130752.GB8462@internetdog.org>
Date: Tue, 21 Jun 2011 17:02:57 +0200
Message-ID: <BANLkTi=EygUbm5VB+H-mm+ofpbuaK8xafA@mail.gmail.com> (sfid-20110621_170301_586333_8738362F)
Subject: Re: Makefile deletes previous driver install when two WiFi interfaces
 are from the same chip vendor
From: Fred Plissonneau <cohomewp4@gmail.com>
To: ali@internetdog.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ali,

On Tue, Jun 21, 2011 at 3:07 PM, Ali Bahar <ali@internetdog.org> wrote:
> On Tue, Jun 21, 2011 at 11:59:17AM +0200, Fred Plissonneau wrote:
>> From: Fred Plissonneau <cohomewp4@gmail.com>
>> To: linux-wireless@vger.kernel.org
>>
>>
>> Anyone can help ?
>
> Not me!
> But let me see if I at least understand your problem:
>
>
>> On Tue, Jun 14, 2011 at 4:19 PM, ch wp4 <cohomewp4@gmail.com> wrote:
>> > Hello,
>> >
>> > I am facing an issue during installation of an external USB-WiFi stick
>> > on my Linux box (Ubuntu 10.04).
>> > Actually, I have already successfully compiled and installed ath9k
>> > driver using compat-wireless-2.6.38.2-2.
>> > The internal WiFi NIC is fully operational.
>> > Now, I want to add temporarily an external USB-WiFi stick (D-Link DWA
>> > 160). I've found that this hardware
>> > is using an ar9170 chipset and therefore I've recompiled
>> > compat-wireless targeting now the carl9170 driver.
>> > Once again, this working perfectly.
>
> So you have an on-board ath9k, which does work, and an ar9170 USB
> stick, which does work.

Exactly

>
>
>> > But when I switch-off and back on my PC, only the latest installed
>> > WiFi interface is working.
>
> So only the on-board ath9k fails?

In fact only the last installed driver remains in the system
directories (/lib/modules/...)
The last-but-one installed driver has been removed during the "make
install" of the second one.

>
>
>> > Digging into the system, I've found that ath9k has disappeared from the
>> > /lib/modules/2.6.32-27-generic/updates/drivers/net/wireless/ath directory.
>> > It looks like the 'make install' command is doing some cleaning which
>
> Ha? Why does 'make install' run after a power-cycle?!! That ran only
> after you compiled the driver.
>

No, no it is not after the power-cycle. I just mention here that after
power-on, my first installed
driver as disappeared and I suspect the Makefile to contain "rm"
command which does too much cleaning
in my particular case.

I am following the README information here (or may I've made a
mistake, let me know).
./scripts/driver-select ath9k
make
sudo make install (I'm running UBUNTU)
sudo modprode ath9k

./scripts/driver-select carl9170
make
sudo make install
sudo modprode carl9170

If I don't switch off, everything works fine (just because both
modules are loaded into the memory).


-->> Last minute (4:30PM today !-) :
I've found the lines causing the problem. There located just after the
"uninstall:" tag which is also built during "make install".
If I delete lines #318 to #326 in the Makefile (right after the "make"
command and before "make install") it works fine now.
That is to say, the ath9k.ko file is not deleted anymore during the
installation of the second driver.
This workaround is working fine. I am not sure my specific problem is
relevant in the normal use case .

Thanks,
Fred.

>
>> > has, in my particular use case, an undesirable
>> > side-effect.
>> > Can someone point me to the line in the Makefile causing this problem
>> > or is it the desired behaviour ?
>
> Again, the makefile does not come into this. After you've installed
> the drivers, you can forget about the makefile.
>
> So are you saying that the ath9k module somehow got deleted from your
> file system?
>


> later,
> ali
>
