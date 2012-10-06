Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27518 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2JFKqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 06:46:50 -0400
From: "Manoharan, Sujith" <c_manoha@qti.qualcomm.com>
To: "nbd@openwrt.org" <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH 3.7 2/3] ath9k: improve suspend/resume reliability
Date: Sat, 6 Oct 2012 10:46:29 +0000
Message-ID: <506697F5827BD842B7CB80D046EBE618A47245@aphydexd01b> (sfid-20121006_124704_598805_31A7AFAD)
References: <1349291272-93080-1-git-send-email-nbd@openwrt.org>
 <1349291272-93080-2-git-send-email-nbd@openwrt.org>
 <20588.62828.845432.706022@gargle.gargle.HOWL>,<506D5804.4090806@openwrt.org>
In-Reply-To: <506D5804.4090806@openwrt.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-04 4:33 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Ensure that drv_start() always returns true, as a failing hw start usually
>> eventually leads to crashes when there's still a station entry present.
>> Call a power-on reset after a resume and after a hw reset failure to bring
>> the hardware back to life again.
>
> In what situations did HW reset (via start() or resume()) fail ?
I don't know what situations caused it, but this happened on a few
ChromeOS devices in the wild, and my patch fixed it.

Well, the cause for the real issue, the HW reset failure is still unknown.
I think we might be papering over some other bug here.

Sujith
