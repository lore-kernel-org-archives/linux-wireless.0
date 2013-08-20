Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4541 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab3HTTFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 15:05:05 -0400
Message-ID: <5213BDD5.60308@broadcom.com> (sfid-20130820_210509_863169_28D803E0)
Date: Tue, 20 Aug 2013 21:04:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Felix Fietkau" <nbd@openwrt.org>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [REGRESSION] 3.10.{6,7} crashes on network activity
References: <CAG-2HqUXQeq=30EpGWmn6tkC=CP1W+=UZCVPTYhhE0WyU_C4nw@mail.gmail.com>
 <20130820000336.GA15548@kroah.com>
 <CAG-2HqUkxvtJNGx0UbZVfaBNvSY-OU+=anSSnroS3AfSR9H0SA@mail.gmail.com>
 <20130820002822.GA18023@kroah.com> <5212F6E8.3090107@openwrt.org>
 <52132589.5000306@broadcom.com> <5213A926.8060306@openwrt.org>
In-Reply-To: <5213A926.8060306@openwrt.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2013 07:36 PM, Felix Fietkau wrote:
> On 2013-08-20 10:15 AM, Arend van Spriel wrote:
>> Hi Felix,
>>
>> I have been diving into root causing why brcmsmac can not handle cck
>> fallback rates, because it should. Maybe it is better to flag no cck
>> support and only change brcmsmac.
> I prefer having a flag to enable it over one to disable it, because it
> fits better with the existing flags. Also, future drivers may not always
> be properly prepared to handle CCK in A-MPDU sessions either.

Ok. It just looked a bit strange that a problem in brcmsmac results in 
changing other drivers.

> By the way, I took a short look at brcmsmac and found more issues that
> you should look into if you want to fix this.
>
> First of all, you should probably make sure that the hardware does not
> try to send an A-MPDU using a CCK rate (prepare it as a single frame in
> brcms_c_ampdu_add_frame). It also does not seem to have any checks to
> ensure that rate control probing frames are not aggregated.

Thanks, Felix. I also noticed that our proprietary driver has code in 
place for these scenarios.

Gr. AvS

