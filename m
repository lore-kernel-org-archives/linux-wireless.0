Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3994 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1LIRco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 12:32:44 -0500
Message-ID: <4EE24615.9020003@broadcom.com> (sfid-20111209_183247_615726_F795A69C)
Date: Fri, 9 Dec 2011 18:32:05 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Francesco Gringoli" <francesco.gringoli@ing.unibs.it>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Performance of BCM43224 (14e4:4353)
References: <4EE15A4E.1090500@lwfinger.net>
 <4EE1E2AC.8030002@broadcom.com> <4EE23AF5.8000400@lwfinger.net>
In-Reply-To: <4EE23AF5.8000400@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 05:44 PM, Larry Finger wrote:
> On 12/09/2011 04:27 AM, Arend van Spriel wrote:
>>
>> Hi Larry
>>
>> Could you perform your benchmark test on brcmsmac without the bcma
>> patches. It kind of surprises me that we are that far off compared to
>> the wl driver.
> 
> I wondered about that myself. Upon investigation, my test with bcma/brcmsmac 
> never worked. Without the patches, my netperf numbers for brcmsmac are RX 40.0 
> and TX 59.7 Mbps.In all cases, the reported number is the maximum of 10 tries of 
> 3 sec each.

Hi, Larry

That numbers do make more sense. Thanks for testing.

> With the patches, my dmesg contains the following:
> 
> [  908.282281] bcma: Bus registered
> [  908.353242] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 22
> [  908.380164] ieee80211 phy0: wl0: brcms_b_attach: si_attach failed
> [  908.380184] ieee80211 phy0: wl0: brcms_b_attach: failed with err 11
> [  908.380192] ieee80211 phy0: wl0: brcms_c_attach: failed with err 11
> [  908.380316] ieee80211 phy0: brcmsmac: attach() failed with code 11
> [  908.380379] brcmsmac: brcms_bcma_probe: brcms_attach failed!
> [  908.381715] brcms_module_init: register returned 0

That is too bad. I thought all individual commits were ok,  but I
reordered some. It could be the srom code failing, which will likely
become redundant as bcma can provide the info.

> As b43 is also loaded, which may be a second problem, it is run instead of brcmsmac.

With the submitted patches brcmsmac claims any revision of 802.11 cores.
Not sure what b43 claims. I have a patch internally to claim only
revisions 23 and 24, which are used in bcm43224, bcm43225, and bcm4313.

Gr. AvS

