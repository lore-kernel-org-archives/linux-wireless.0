Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1835 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab2EYUU1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 16:20:27 -0400
Message-ID: <4FBFE95F.2080306@broadcom.com> (sfid-20120525_222031_818489_0885C5A0)
Date: Fri, 25 May 2012 22:19:43 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: BCM4331 tx failures after S3
References: <20120522165251.GA31347@thinkpad-t410>
 <4FBCAE3E.6050206@broadcom.com> <20120523135506.GB30165@thinkpad-t410>
 <4FBE0110.5020209@broadcom.com> <20120524212115.GD26760@thinkpad-t410>
 <4FBEA96D.8030207@hauke-m.de> <20120525141339.GB2895@thinkpad-t410>
 <4FBFB79F.4060609@broadcom.com> <20120525183451.GD2895@thinkpad-t410>
In-Reply-To: <20120525183451.GD2895@thinkpad-t410>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2012 08:34 PM, Seth Forshee wrote:
> On Fri, May 25, 2012 at 06:47:27PM +0200, Arend van Spriel wrote:
>> On 05/25/2012 04:13 PM, Seth Forshee wrote:
>>> On Thu, May 24, 2012 at 11:34:37PM +0200, Hauke Mehrtens wrote:
>>>> Hi Seth,
>>>>
>>>> rmmod and insmod of b43 does not help but doing this with b43 and bcma
>>>> works is that correct?
>>>> Have you tried to add this code from bcma_host_pci_probe() to resume:
>>>>
>>>> 	/* Disable the RETRY_TIMEOUT register (0x41) to keep
>>>> 	 * PCI Tx retries from interfering with C3 CPU state */
>>>> 	pci_read_config_dword(dev, 0x40, &val);
>>>> 	if ((val & 0x0000ff00) != 0)
>>>> 		pci_write_config_dword(dev, 0x40, val & 0xffff00ff);
>>>>
>>>> Could you also try to run bcma_sprom_get() after resume.
>>>
>>> Okay, this one fixes it. The part that's needed seems to be:
>>>
>>>         if (bus->chipinfo.id == 0x4331)
>>>                 bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
>>>
>>> I could have sworn I tried adding this to resume before, but apparently
>>> I didn't.
>>>
>>> Hmm. It turns out that BCMA_CC_CHIPCTL is completely reset to 0 when on
>>> S3 without AC power, meaning all other fields in the register get
>>> cleared as well. On this MBP that's affecting
>>> BCMA_CHIPCTL_4331_BT_COEXIST. So we could save the value at suspend and
>>> restore it during resume, but maybe the initialization of this register
>>> also needs to be improved. Thoughts?
>>>
>>> Thanks,
>>> Seth
>>>
>>>
>>
>> Well let me explain some behaviour. Upon suspend mac80211 takes down the
>> driver with the last callback being .stop(). Upon resume mac80211 calls
>> the driver with .start() callback.
>>
>> The brcmsmac driver has two bool states that are in play here: driver_up
>> and hw_up. Upon .stop() callback the driver_up is set to false, but
>> hw_up remains true. A subsequent .start() will perform some
>> reconfiguration and driver_up will be made true.
>>
>> The suspend/resume scenario is different for brcmsmac. bcma will call
>> brcmsmac .suspend() callback in which we set hw_up to false. This
>> changes the behaviour of the .start() callback after resume. Basically,
>> it reinitializes the hardware.
> 
> I'm having a bit of a hard time understanding the relevance of your
> description, since we're talking about b43. Are you suggesting that b43
> should do something similar? But even then I don't see any of the
> reinitialization done by brcmsmac setting BCMA_CC_CHIPCTL with the
> needed value. Am I missing something?
> 
> Seth
> 

Yes, that is my suggestion. I dived into the b43 driver, but I do not
see a .resume callback for bcma:

static struct bcma_driver b43_bcma_driver = {
	.name		= KBUILD_MODNAME,
	.id_table	= b43_bcma_tbl,
	.probe		= b43_bcma_probe,
	.remove		= b43_bcma_remove,
};

So upon suspend/resume b43 seems to take no extra steps, but I may be
missing it as I am not a b43 specialist (let me CC the b43 developer
list :-) ).

In brcmsmac the brcms_b_hw_up() is called in brcms_c_up() when the flag
hw_up is false:

int brcms_c_up(struct brcms_c_info *wlc)
{
	if (!wlc->pub->hw_up) {
		brcms_b_hw_up(wlc->hw);
		wlc->pub->hw_up = true;
	}

/* Initialize just the hardware when coming out of POR or S3/S5 system
states */
static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)

You are right that this particular code does not fiddle with
BCMA_CC_CHIPCTL. Where in the code did you print the value of this
register? Before or after the mac80211 .start() callback has been called?

Gr. AvS

