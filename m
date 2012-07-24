Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab2GXSEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 14:04:25 -0400
Message-ID: <500EE3A0.3020005@canonical.com> (sfid-20120724_200440_697029_31E83FAE)
Date: Tue, 24 Jul 2012 11:04:16 -0700
From: Brad Figg <brad.figg@canonical.com>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Warning in brcms_c_wait_for_tx_completion
References: <20120703134520.GB5626@thinkpad-t410> <4FF322DD.1050900@broadcom.com> <20120703170903.GC5626@thinkpad-t410>
In-Reply-To: <20120703170903.GC5626@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2012 10:09 AM, Seth Forshee wrote:
> On Tue, Jul 03, 2012 at 06:50:37PM +0200, Arend van Spriel wrote:
>> On 07/03/2012 03:45 PM, Seth Forshee wrote:
>>> Hi Arend,
>>>
>>> This message is off-list, only because I know it's been discussed
>>> on-list in the past. Feel free to pull in any individuals or mailing
>>> lists if you wish.
>>
>> The issue is popping up regularly in Fedora 17. See [1]
>>
>>> Brad (on Cc) just received a MacBook Air with BCM4313 wireless, and he's
>>> able to very reliably trigger the WARN_ON_ONCE in
>>> brcms_c_wait_for_tx_completion() in his environment. He also gets an
>>> endless stream of these messages when wireless drops out.
>>>
>>>   ieee80211 phy0: brcms_c_prec_enq_head: No where to go, prec == 4
>>
>> I only seen this regularly with Fedora 17. Ubuntu 11.04 with 3.5-rc4
>> installed in our smoketest setups does not show it. Basically, it means
>> that packet queue in our driver is full and packets are dropped. As we
>> do not inform mac80211 that traffic is stalled this is expected to happen.
>>
>>> This is in the 3.5-rc kernels. We're carrying the regulatory patches, in
>>> the Ubuntu kernel, but Brad tested an older rc without the patches and
>>> still gets this.
>>>
>>> We've done a little debugging and have found a couple of points. First,
>>> all the stack traces I've seen from Brad's machine show that the warning
>>> triggers during a scan. Second, we added debug to brcms_b_mute() to
>>> check whether tx was somehow getting muted in the driver without being
>>> unmuted, but this is not the case.
>>
>> I did a little debugging as well and also concluded a scan triggers it.
>> I change the WARN_ON_ONCE to a WARN_ON and it seems to correlate with
>> the duration between scan_start and scan_complete. When it is in 8-10
>> sec. range the warning kicks in. I was going to add debugging for the tx
>> mute.
>>
>>> I wanted to get in touch with you in case there was anything you wanted
>>> Brad to try to help with identifying the cause of this issue. Also you
>>> can find details of his AP setup below.
>>
>> The issue is either driver related or caused by firmware behaviour. I
>> suspect the firmware, but I have not 100% certainty yet.
>>
>> Gr. AvS
>>
>> [1] https://bugzilla.redhat.com/show_bug.cgi?id=799168
> 
> Thanks for the update, Arend. Brad and I are eager to help in any way we
> can, so please let us know if there's anything we can do to assist.
> 
> Seth
> 

Arend,

Any progress on this issue? This Macbook Air is barely usable in my environment.
It will only stay connected for approx. 30 minutes before I have to reset the
wireless.

Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com
