Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61029 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965788Ab0GPPAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 11:00:08 -0400
Received: by pvc7 with SMTP id 7so819035pvc.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jul 2010 08:00:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277999967.4197.92.camel@rchatre-DESK>
References: <AANLkTikqJzkFFtmOowq-OzzDFSC9_1SFuAfT4UGZBhqW@mail.gmail.com>
	<1277999967.4197.92.camel@rchatre-DESK>
From: Andrew Lutomirski <andy@luto.us>
Date: Fri, 16 Jul 2010 10:59:43 -0400
Message-ID: <AANLkTil5UKUG0687dmtDA32Kp3qGJaIRN78ueVd8YCLn@mail.gmail.com>
Subject: Re: rfkill failure in 2.6.35-rc3+
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I haven't been able to reproduce this, so I haven't tried unloading
the platform driver.  I will if it happens again, though.

--Andy

On Thu, Jul 1, 2010 at 11:59 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Wed, 2010-06-30 at 19:59 -0700, Andrew Lutomirski wrote:
>> I just toggled rfkill on and back off on my X200s (WiFi Link 5350, rev
>> 0x24) and the link didn't come up.  Toggling rfkill again didn't fix
>> it, but rmmod + modprobe did.
>>
>> dmesg said:
>>
>> [13629.424869] iwlagn 0000:03:00.0: RF_KILL bit toggled to disable radio.
>> [13629.432761] iwlagn 0000:03:00.0: Not sending command - RF KILL
>> [13629.432771] iwlagn 0000:03:00.0: Error sending REPLY_RXON:
>> enqueue_hcmd failed: -5
>> [13629.432778] iwlagn 0000:03:00.0: Error setting new RXON (-5)
>> [13631.268646] iwlagn 0000:03:00.0: RF_KILL bit toggled to enable radio.
>> [13631.311232] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [13675.710821] iwlagn 0000:03:00.0: RF_KILL bit toggled to disable radio.
>> [13675.713438] iwlagn 0000:03:00.0: Not sending command - RF KILL
>> [13675.713448] iwlagn 0000:03:00.0: Error sending REPLY_RXON:
>> enqueue_hcmd failed: -5
>> [13675.713455] iwlagn 0000:03:00.0: Error setting new RXON (-5)
>> [13683.090789] iwlagn 0000:03:00.0: RF_KILL bit toggled to enable radio.
>> [13683.145267] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>
>> This is 2.6.35-rc3+ with firmware 8.24.2.12.  I've never seen this before.
>
> Recently we have seen a few issues with rfkill state changes not being
> seen by the driver. In all cases it was "resolved" by unloading (or not
> loading from the beginning via blacklisting) of the platform driver. Can
> you try that?
>
> Reinette
>
>
>
