Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:61033 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbZKIQc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 11:32:58 -0500
MIME-Version: 1.0
In-Reply-To: <4AF5FBC7.9000105@linux.intel.com>
References: <1257537660-5301-1-git-send-email-lrodriguez@atheros.com>
	<200911072152.57596.trenn@suse.de> <4AF5F47C.5000402@linux.intel.com>
	<200911072347.05786.trenn@suse.de> <4AF5FBC7.9000105@linux.intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 9 Nov 2009 08:32:43 -0800
Message-ID: <43e72e890911090832v1c809482yde7e767502271376@mail.gmail.com>
Subject: Re: [PATCH] cpu-freq: add troubleshooting section for FSB changes
To: Arjan van de Ven <arjan@linux.intel.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Aeolus Yang <Aeolus.Yang@atheros.com>,
	Jonathan May <Jonathan.May@atheros.com>
Cc: Thomas Renninger <trenn@suse.de>, davej@redhat.com,
	cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Garrett <mjg@redhat.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	Kishore Jotwani <Kishore.Jotwani@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 7, 2009 at 2:59 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>>> in addition, most FSB systems have the memory controller in the chipset,
>>> next to the PCI logic... so that the FSB bus for DMA transactions only
>>> carries the snoop traffic, not the whole data.
>>
>> So when should people look at this?
>
> at this point the atheros folks haven't even confirmed that this is the
> cause...

And we tested this (reducing the min cpu freq to one less than the
highest supported P state to avoid an FSB speed change) and it seems
doing the steps described here did not fix the issue. But at least now
if anyone else wants to verify this they can with some sort of
documentaiton.

So to confirm though -- we are seeing a huge performance depredation
mainly on RX on an Intel Pine Trail platform with SpeedStep enabled on
the BIOS.

Let me get into the specifics in case anyone is able to help. The
issue is with ath9k on RX and the CPU on C3 state requesting DMA over
PCI-E. We typically would get about 110 Mbps with an AR9285 (single
stream) but when SpeedStep is enabled it goes down to 25 Mbps. At the
PCI-E level we are seeing huge latencies introduced when SpeedStep is
used for DMA requests to the Intel root complex on the Intel Pine
trail platform. Latencies are about 20-60 us.

Is there a timeout threshold change that will cause the Intel chipset
wait for some time after completion before going into a C3 state? Are
there any other explanations for seeing such huge latencies on C3
state?

Thanks for your review and help with this. Any suggestions are greatly
appreciated.

  Luis
