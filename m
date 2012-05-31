Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2054 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab2EaRnu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 13:43:50 -0400
Message-ID: <4FC7ADCA.5020002@broadcom.com> (sfid-20120531_194354_171285_DFC89556)
Date: Thu, 31 May 2012 19:43:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: ensure ext PA lines are enabled for BCM4331
References: <1338472163-3810-1-git-send-email-seth.forshee@canonical.com>
 <4FC77D25.4060100@hauke-m.de> <20120531142652.GA32179@thinkpad-t410>
In-Reply-To: <20120531142652.GA32179@thinkpad-t410>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2012 04:26 PM, Seth Forshee wrote:
> On Thu, May 31, 2012 at 04:16:05PM +0200, Hauke Mehrtens wrote:
>> > Hi Seth,
>> > 
>> > why don't you call this from bcma_pmu_workarounds() in
>> > drivers/bcma/driver_chipcommon_pmu.c instead of calling this from b43? I
>> > think it looks better to call some workarounds on chip common from bcma
>> > and not from b43.
> Arend recommended calling it from within b43's start op, but I'm not
> sure of the reason. Arend?

Well, my comment on start op was regarding your observation of CHIPCTL
being zero. As the start op does reinitialize the hardware you should
check CHIPCTL register at the end of it. This is just to confirm the
register contains valid bits.

> Agreed though that if there's no need to run it every time the interface
> is started then bcma_pmu_workarounds() would be a nicer place for it.
> 

So I agree with Hauke and have this code in bcma. Just not sure whether
bcma_pmu_workarounds() is the place to put it. This is not a pmu related
register, but as the function was already there I will not stress to
move it to driver_chipcommon.c ;-)

Gr. AvS

