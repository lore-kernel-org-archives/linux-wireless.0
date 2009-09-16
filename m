Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f171.google.com ([209.85.216.171]:52880 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760019AbZIPUro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 16:47:44 -0400
Received: by pxi1 with SMTP id 1so4474386pxi.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 13:47:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F704306DB9CFDB7@SC-VEXCH1.marvell.com>
References: <1253058359-1934-1-git-send-email-bzhao@marvell.com>
	 <45e8e6c40909151641o423cbc70y22033061505661b6@mail.gmail.com>
	 <477F20668A386D41ADCC57781B1F704306DB9CFDB7@SC-VEXCH1.marvell.com>
Date: Wed, 16 Sep 2009 13:47:48 -0700
Message-ID: <45e8e6c40909161347l23caaf4ct14d4ef7b416b3387@mail.gmail.com>
Subject: Re: [PATCH] libertas: Add auto deep sleep support for
	SD8385/SD8686/SD8688
From: Andrey Yurovsky <andrey@cozybit.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 16, 2009 at 1:20 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Andrey,
>
>> -----Original Message-----
>> From: Andrey Yurovsky [mailto:andrey@cozybit.com]
>> Sent: Tuesday, September 15, 2009 4:41 PM
>> To: Bing Zhao
>> Cc: libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org; Amitkumar Karwar; Dan Williams
>> Subject: Re: [PATCH] libertas: Add auto deep sleep support for SD8385/SD8686/SD8688
>>
>> Hi Bing.  This is not specific to the actual implementation of the
>> deep sleep commands in your patch but,
>>
>> On Tue, Sep 15, 2009 at 4:45 PM, Bing Zhao <bzhao@marvell.com> wrote:
>> > +       Path: /sys/kernel/debug/libertas_wireless/ethX/
>>
>> Is the sysfs interface really necessary?  It seems like yet another
>> non-standard configuration option to keep track of.
>
> Actually the debugfs interface is used in the patch.
>
> Some information (such as the interface name and path) in README file is out of date. We just copy-and-paste it for the new deepsleep command. We need a separate patch to clean up the REAME file and keep it up to date.

Ok.  Either way, this is another out-of-band interface (regardless of
if it's debugfs or sysfs).  That said, I believe that debugfs should
be used for debugging, not for configuring driver/device features like
these.

>> Deep sleep seems to pretty much "turn off" the wifi card (as far as
>> the user is concerned) so how about a simpler approach: enter deep
>> sleep when the interface is brought down (ifconfig wlanN down) and
>> exit deep sleep when it's brought up.  Do this only when deep sleep is
>> supported/possible.  Alternately, maybe this belongs as an rfkill
>> feature?
>
> Entering/exiting deep sleep doesn't have to depend on wlanN interface's up and down. User can still put the chip into sleep when wlanN is up. And, with auto deep sleep feature, the driver automatically wakes the chip up for sending user commands (for example, scan) and put the chip back to sleep after certain time period of inactivity. The deepsleep command through debugfs interface provides the flexibility of deep sleep options.
>
> The rfkill shuts down the RF transmitter of the device but most of other modules may be still functioning. The deep sleep shuts down most of the modules (including the RF) on the chip to save as much power as possible.

It seems that when the device is in deep sleep, it's effectively
"turned off" as far as the user is concerned.  That seems really
similar to "ifconfig down" or rfkill, does the user really care about
anything beyond that?  I understand that it's possible to control this
feature independently of either of those functions, but is it ever
necessary?  If not, it would be great to just integrate it into one
(or both) of these already standard network interface semantics and
not introduce a whole new configuration parameter.

  -Andrey

> Regards,
>
> Bing
>
>>
>>   -Andrey
>
