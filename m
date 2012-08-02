Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44592 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab2HBNo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 09:44:26 -0400
Message-ID: <501A842A.2080807@hauke-m.de> (sfid-20120802_154429_356614_BC6D80A4)
Date: Thu, 02 Aug 2012 15:44:10 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 0/2] Fix lockdep warning in brcmsmac
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com> <20120802002353.GD1785@zod.bos.redhat.com> <20120802015320.GA25933@thinkpad-t410> <20120802120230.GE1785@zod.bos.redhat.com> <20120802125102.GF1785@zod.bos.redhat.com>
In-Reply-To: <20120802125102.GF1785@zod.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2012 02:51 PM, Josh Boyer wrote:
> On Thu, Aug 02, 2012 at 08:02:30AM -0400, Josh Boyer wrote:
>> On Wed, Aug 01, 2012 at 08:53:20PM -0500, Seth Forshee wrote:
>>> On Wed, Aug 01, 2012 at 08:23:54PM -0400, Josh Boyer wrote:
>>>> On Wed, Aug 01, 2012 at 03:58:41PM -0500, Seth Forshee wrote:
>>>>> As reported by Josh Boyer, brcmsmac is producing lockdep warnings by
>>>>> calling freq_reg_info() without holding cfg80211_lock. Currently
>>>>> freq_reg_info() is the only way for a wireless driver to tell whether
>>>>> OFDM is allowed on the current channel, but cfg80211_lock is outside the
>>>>> scope of the wireless drivers.
>>>>>
>>>>> Since other regulatory restrictions are communicated in the channel
>>>>> definition, it makes sense to do the same for OFDM. These patches add a
>>>>> new flag, IEEE80211_CHAN_NO_OFDM, which is set by regulatory to
>>>>> indicated OFDM operation is prohibited. brcmsmac is modifified to use
>>>>> this flag instead of consuming the regulatory data directly.
>>>>>
>>>>> Thanks,
>>>>> Seth
>>>>>
>>>>>
>>>>> Seth Forshee (2):
>>>>>   cfg80211: add channel flag to restrict OFDM
>>>>>   brcmsmac: use channel flags to restrict OFDM
>>>>
>>>> I would love to test these, but at the moment I can't.  Oddly, the very
>>>> same machine I hit the problem with originally is no longer presenting
>>>> any devices on the bcma bus.  The driver is loaded, brcmsmac is loaded,
>>>> but neither output the devices that showed up in my original email.
>>>> This is with both the kernel I originally reported the problem with, and
>>>> other kernels.  Nothing shows up for the BCM4313 in lspci either.
>>>>
>>>> I did power it off and then back on today after I hit the original
>>>> problem, but I'd expect the hardware in the box to still show up on a
>>>> power on...  Is there some specific module load order, or something
>>>> else I can do to try and get the device to show up?
>>>>
>>>> I did build a kernel with your patches applied, so at least I know they
>>>> build.  If I can get this machine to probe the chip again, I'll be happy
>>>> to test.
>>>>
>>>> At the moment, I'm just very confused and slightly afraid it's going to
>>>> just refuse to work at all.
>>>
>>> Do you have 1f03bf06e4e3b8ed9a69e7fc4cdb1be4c6c6c819? That fixed a bug
>>> that had caused some very odd behavior, like changing PCI device ids.
>>> Recovering after booting a bad kernel required a cold boot to a kernel
>>> with the fix; a warm reboot wasn't enough.
>>
>> The kernel I'm testing should have that commit in it.  I'll try a cold
>> boot to it to make sure.
> 
> That didn't help.  I've tried multiple module load orderings without
> anything being shown on the bcma bus.  The modules all load, but no
> devices are created.  It's as if the hardware was removed or something.
> Puzzling.
> 
> josh

Are you sure you have the commit
1f03bf06e4e3b8ed9a69e7fc4cdb1be4c6c6c819 in your tree, this commit is
*not* in wireless-testing it is just in wireless-next-2.6 and linus tree
for 3.6-rc1. If lspci does not show the device, it has nothing to do
with some modules being loaded or not, at least when non of then is
controlling your PCIe bus. It could also be that a cold boot is not
enough to reset your device, what device are you using the BCM4313 in?

Hauke
