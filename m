Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:40818 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0AVWId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:08:33 -0500
Received: by pzk28 with SMTP id 28so400953pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 14:08:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B5A20C3.6020304@redfish-solutions.com>
References: <Pine.LNX.4.64.0912261245080.5112@cheetah.psv.nu>
	<20091229020027.GE30201@bombadil.infradead.org> <4B59FC5E.1020802@redfish-solutions.com>
	<43e72e891001221153w5c4c4bc6g63883b5012d384b7@mail.gmail.com>
	<4B5A20C3.6020304@redfish-solutions.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Jan 2010 14:08:13 -0800
Message-ID: <43e72e891001221408y11355794k73b79ad6dee22b1c@mail.gmail.com>
Subject: Re: Compat-wireless bleeding-edge daily builds broken since
	2009-12-11
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Peter Svensson <petersv@psv.nu>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2010 at 2:03 PM, Philip A. Prindeville
<philipp_subx@redfish-solutions.com> wrote:
> On 01/22/2010 11:53 AM, Luis R. Rodriguez wrote:
>> On Fri, Jan 22, 2010 at 11:28 AM, Philip A. Prindeville
>> <philipp_subx@redfish-solutions.com> wrote:
>>> On 12/28/2009 06:00 PM, Luis R. Rodriguez wrote:
>>>> On Sat, Dec 26, 2009 at 12:50:23PM +0100, Peter Svensson wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> The bleeding edge nightly snapshopts in
>>>>>   http://wireless.kernel.org/download/compat-wireless-2.6/
>>>>> are not updated since the compat-bluetooth were introduced (I think) on
>>>>> 2009-12-11.
>>>>>
>>>>> When built from the git sources the driver works very nicely, and much
>>>>> more stable than the last drop on 2009-12-11.
>>>>>
>>>> This will be fixed soon, just need to re-instate access to the box.
>>>>
>>>>   Luis
>>>>
>>>
>>>
>>> Is this the issue I'm seeing?  Has it been fixed yet?
>>
>> Well so I now have access to the box but the box got a face lift and
>> during that time I didn't want to clone linux-next on it. While all
>> that happened in the background I just started making bleeding edge
>> compat-wireless releases on orbit-lab.org along with updating the
>> symlink to point to the latest dated release.
>>
>> wireless.kernel.org upgrade has now completed but I think I prefer to
>> continue doing the bleeding edge compat-wireless updates on
>> orbit-lab.org as I have full access there and can soon start doing
>> compile tests for each kernel as I have unlimited disk space (or so I
>> like to believe). I see it useful to still have the bleeding edge
>> tarball on wireless.kernel.org though due to the URL name, etc, but I
>> can just scp it over. I haven't gotten to that yet.
>>
>> For now use:
>>
>> http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
>>
>> for bleeding edge
>>
>> Seems my cronjobs aren't kicking off yet, will debug that today too.
>>
>>   Luis
>
> Just ran against the tarball of 2010-01-20 on linux 2.6.27.42:
>
> br1: port 1(ap0) entering disabled state
> br1: topology change detected, propagating
> br1: port 1(ap0) entering forwarding state
> Starting dnsmasq...
> Starting ntpd...
> BUG: unable to handle kernel NULL pointer dereference at 0000019f
> IP: [<d09cbe50>] :mac80211:invoke_tx_handlers+0x58f/0xe6a
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT
> Modules linked in: aes_i586 aes_generic lm90 hwmon scx200_acb i2c_core bridge stp llc dummy ath9k ath9k_common mac80211 ath9k_hw ath cfg80211 rfkill_backport compat dahdi_dummy dahdi sha512_generic sha256_generic deflate zlib_deflate arc4 ecb sha1_generic blowfish des_generic cbc cryptosoft cryptodev(P) ocf(P) geodewdt geode_rng geode_aes crypto_blkcipher via_rhine rtc leds_alix
>
> Pid: 1721, comm: hostapd Tainted: P          (2.6.27.42-astlinux #1)
> EIP: 0060:[<d09cbe50>] EFLAGS: 00010246 CPU: 0
> EIP is at invoke_tx_handlers+0x58f/0xe6a [mac80211]

Fun, can you run gdb net/mac80211/mac80211.ko

And then on the gdb prompt run:

l *(invoke_tx_handlers+0x58f)

  Luis
