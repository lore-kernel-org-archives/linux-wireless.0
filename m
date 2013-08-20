Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60315 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab3HTRgk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 13:36:40 -0400
Message-ID: <5213A926.8060306@openwrt.org> (sfid-20130820_193644_393018_3B850981)
Date: Tue, 20 Aug 2013 19:36:38 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [REGRESSION] 3.10.{6,7} crashes on network activity
References: <CAG-2HqUXQeq=30EpGWmn6tkC=CP1W+=UZCVPTYhhE0WyU_C4nw@mail.gmail.com> <20130820000336.GA15548@kroah.com> <CAG-2HqUkxvtJNGx0UbZVfaBNvSY-OU+=anSSnroS3AfSR9H0SA@mail.gmail.com> <20130820002822.GA18023@kroah.com> <5212F6E8.3090107@openwrt.org> <52132589.5000306@broadcom.com>
In-Reply-To: <52132589.5000306@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-20 10:15 AM, Arend van Spriel wrote:
> Hi Felix,
> 
> I have been diving into root causing why brcmsmac can not handle cck 
> fallback rates, because it should. Maybe it is better to flag no cck 
> support and only change brcmsmac.
I prefer having a flag to enable it over one to disable it, because it
fits better with the existing flags. Also, future drivers may not always
be properly prepared to handle CCK in A-MPDU sessions either.

By the way, I took a short look at brcmsmac and found more issues that
you should look into if you want to fix this.

First of all, you should probably make sure that the hardware does not
try to send an A-MPDU using a CCK rate (prepare it as a single frame in
brcms_c_ampdu_add_frame). It also does not seem to have any checks to
ensure that rate control probing frames are not aggregated.

- Felix
