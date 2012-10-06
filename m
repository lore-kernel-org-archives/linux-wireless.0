Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33982 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab2JFK7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 06:59:45 -0400
Message-ID: <50700F1B.1050405@openwrt.org> (sfid-20121006_125948_387077_43B9308A)
Date: Sat, 06 Oct 2012 12:59:39 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Manoharan, Sujith" <c_manoha@qti.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 3.7 2/3] ath9k: improve suspend/resume reliability
References: <1349291272-93080-1-git-send-email-nbd@openwrt.org> <1349291272-93080-2-git-send-email-nbd@openwrt.org> <20588.62828.845432.706022@gargle.gargle.HOWL>,<506D5804.4090806@openwrt.org> <506697F5827BD842B7CB80D046EBE618A47245@aphydexd01b>
In-Reply-To: <506697F5827BD842B7CB80D046EBE618A47245@aphydexd01b>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-06 12:46 PM, Manoharan, Sujith wrote:
> On 2012-10-04 4:33 AM, Sujith Manoharan wrote:
>> Felix Fietkau wrote:
>>> Ensure that drv_start() always returns true, as a failing hw start usually
>>> eventually leads to crashes when there's still a station entry present.
>>> Call a power-on reset after a resume and after a hw reset failure to bring
>>> the hardware back to life again.
>>
>> In what situations did HW reset (via start() or resume()) fail ?
>> I don't know what situations caused it, but this happened on a few
>> ChromeOS devices in the wild, and my patch fixed it.
> 
> Well, the cause for the real issue, the HW reset failure is still unknown.
> I think we might be papering over some other bug here.
After a suspend/resume cycle, the card definitely needs at least one
power-on reset (since we can assume that the card was power cycled), as
is done on driver initialization as well. My patch ensures that this
happens by setting a flag on resume.

If for some reason the drv_start() reset still fails (and I'm not aware
of any such instances), it's still much better to return 0. The reset
failure will still appear in log messages.

If we return an error code in drv_start, this tends to create a mess of
either WARN_ON/BUG_ON calls triggered at a later point in time (if a
station was connected), or just a complete loss of wifi functionality.

- Felix
