Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbaIZOfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 10:35:34 -0400
Message-ID: <1411742131.27290.1.camel@dcbw.local> (sfid-20140926_163544_355360_C5FB850C)
Subject: Re: how can we fast roaming between multi-aps
From: Dan Williams <dcbw@redhat.com>
To: jammy <benxuelan0402@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Fri, 26 Sep 2014 09:35:31 -0500
In-Reply-To: <00852C2A-209F-48A8-9F46-2F2520CEF7EE@gmail.com>
References: <509C5E93-4D6C-4CCE-A4F6-BA1CEC80AB98@gmail.com>
	 <CAA2SeNKdOBTPnkz2y=WUFqa1sSUmxeMwDCHaT50TwL0O0uJfgQ@mail.gmail.com>
	 <00852C2A-209F-48A8-9F46-2F2520CEF7EE@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-26 at 11:22 +0800, jammy wrote:
> Hi all，
> 
> I have build a multi-aps network，and there are wifi clients roaming in the network. Now I use the standard ath9k driver，and I found that the time of handoff is as long as 3 to 4 seconds，it is too long to process the Voip service and so on. 
> I think the problem can be solved by modify the driver，anyone has tried it？

Are all the SSIDs the same?

What kind of authentication?  WPA Enterprise/802.1x?  What EAP methods?

Is pre-authentication enabled on the network and in the client?

Is background scanning enabled in wpa_supplicant, and if so what is the
interval?

Some sanitized logs (with -dddt!) showing the slow roaming attempts
would be very helpful in figuring out what might be going wrong.  There
are a ton of moving parts, and all of them have to be working correctly
for roaming to happen quickly.

Dan

> Any help will be appreciated.
> 
> Waiting for your reply.
> 
> from jammy's iPhone
> 
> 在 2014年9月22日，20:59，Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> 写道：
> 
> >> Hi, all，
> > 
> > Hi,
> > 
> >> I have read the http://www.spinics.net/lists/linux-wireless/msg124980.html for patching the ath9k driver in compat-wireless-2014-05-22 in openwrt trunk, but when I patch, for example, “the [PATCH 01/10] ath9k: export methods related to ack timeout estimation”, it failed.
> > 
> > please use latest dynack patchset:
> > http://www.spinics.net/lists/linux-wireless/msg127038.html
> > 
> >> the command window showed that：
> >> patching file drivers/net/wireless/ath/ath9k/hw.h
> >> Hunk #1 FAILED at 1080.
> >> 1 out of 1 hunk FAILED -- saving rejects to file drivers/net/wireless/ath/ath9k/hw.h.rej.
> >> 
> >> i have checked the hw.h file, but I can not see anything wrong, how should i do further?
> > 
> > You should port dynack on compat-wireless-2014-05-22. E.g:
> > 
> > --- a/drivers/net/wireless/ath/ath9k/hw.h
> > +++ b/drivers/net/wireless/ath/ath9k/hw.h
> > @@ -1080,6 +1080,10 @@ void ar9002_hw_load_ani_reg(struct ath_hw *ah,
> > struct ath9k_channel *chan);
> > void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
> > void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
> > 
> > +void ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us);
> > +void ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us);
> > +void ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
> > +
> > #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
> > static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
> > {
> > 
> > this chunk will fail since OpenWRT uses CPTCFG_ATH9K_BTCOEX_SUPPORT
> > insted of CONFIG_ATH9K_BTCOEX_SUPPORT
> > 
> >> another question is，if I patch them manualy，I can not see the dnyack choice in the menuconfig，what should I do then？
> > 
> > You should add dynack to OpenWRT mac80211 package Makefile
> > 
> >> I am waiting for your suggestions.
> >> 
> >> from jammy's iPhone--
> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > Regards,
> > Lorenzo
> > 
> > -- 
> > UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
> > unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
> > umount; make clean; sleep
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


