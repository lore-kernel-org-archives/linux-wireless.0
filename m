Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4440 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab1FFIcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 04:32:13 -0400
Message-ID: <4DEC907E.9040405@broadcom.com> (sfid-20110606_103234_793682_2B38973E)
Date: Mon, 6 Jun 2011 10:31:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"george@znau.edu.ua" <george@znau.edu.ua>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"bernhardloos@googlemail.com" <bernhardloos@googlemail.com>
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
 <1307311658-15853-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1307311658-15853-2-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 12:07 AM, Hauke Mehrtens wrote:
> When using bcma on a embedded device it is initialized very early at
> boot. We have to do so as the cpu and interrupt management and all
> other devices are attached to this bus and it has to be initialized so
> early. In that stage we can not allocate memory or sleep, just use the
> memory on the stack and in the text segment as the kernel is not
> initialized far enough. This patch removed the kzallocs from the scan
> code. Some earlier version of the bcma implementation and the normal
> ssb implementation are doing it like this.
> The __bcma_dev_wrapper struct is used as the container for the device
> struct as bcma_device will be too big if it includes struct device.

Does this prevent using list_for_each() and friends to be used on the 
device list? If so, could you consider a different approach. There were 
good reasons to get rid of the bcma_dev_wrapper struct if I recall 
discussions on the mailing list correctly. I also see tendency to use 
ssb solutions without considering alternatives. For this particular 
example, please consider adding a bcma_zalloc(), which does kzalloc for 
non-embedded platforms and returns array pointers for embedded platform. 
You could also consider this behavior for the embedded bus only.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


