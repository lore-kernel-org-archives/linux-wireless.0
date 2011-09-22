Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36852 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1IVJMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 05:12:42 -0400
Received: by wyg34 with SMTP id 34so2773134wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 02:12:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0CC8ABE6@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<20110920132203.GB7800@tuxdriver.com>
	<20110920140020.GA11386@kroah.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
	<CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
	<20110922003523.0bf6a460@milhouse>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DE92@SJEXCHCCR01.corp.ad.broadcom.com>
	<20110922012851.2f3b7801@milhouse>
	<400C43189542CE41BC0A5B252FC90136BC0CC8ABB9@SJEXCHCCR02.corp.ad.broadcom.com>
	<CACna6rxD_U+beqbWxv4VJ7nWHQuJjb47seRQECEBFR3DHW8t+Q@mail.gmail.com>
	<400C43189542CE41BC0A5B252FC90136BC0CC8ABE6@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Thu, 22 Sep 2011 11:12:41 +0200
Message-ID: <CACna6rzq+Bcrx79MWVepkhBbCqQvxczMcmn=FNYRAqf72qAwWQ@mail.gmail.com> (sfid-20110922_111246_656901_D8B99ED3)
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch #2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
	Brett Rudley <brudley@broadcom.com>, Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jonas.gorski@gmail.com" <jonas.gorski@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/22 Arend Van Spriel <arend@broadcom.com>:
>> From: Rafał Miłecki [mailto:zajec5@gmail.com]
>> Sent: donderdag 22 september 2011 10:57
>> To: Arend Van Spriel
>> Cc: Michael Büsch; Brett Rudley; Greg KH; John W. Linville; Franky
>> (Zhenhui) Lin; gregkh@suse.de; devel@linuxdriverproject.org; linux-
>> wireless@vger.kernel.org; jonas.gorski@gmail.com
>> Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for
>> mainline patch #2
>>
>> W dniu 22 września 2011 10:53 użytkownik Arend Van Spriel
>> <arend@broadcom.com> napisał:
>> >> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> >> owner@vger.kernel.org] On Behalf Of Michael Büsch
>> >> Sent: donderdag 22 september 2011 1:29
>> >> To: Brett Rudley
>> >> Cc: Rafał Miłecki; Greg KH; John W. Linville; Franky (Zhenhui) Lin;
>> >> gregkh@suse.de; devel@linuxdriverproject.org; linux-
>> >> wireless@vger.kernel.org
>> >> Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for
>> >> mainline patch #2
>> >>
>> >> On Wed, 21 Sep 2011 16:15:10 -0700
>> >> "Brett Rudley" <brudley@broadcom.com> wrote:
>> >>
>> >> > We did however initially propose (and implement) a dividing line
>> of
>> >> ssb chips for b43 and AXI based chips for brcmsmac but b43 team
>> chose
>> >> to ignore/reject that.
>> >>
>> >> Well, what about embedded, for instance?
>> >
>> > The brcmsmac driver has been tested on a MIPS platform by Jonas
>> Gorski
>> > although only in STA mode (on a bcm63xx). Not having AP mode has been
>> > explained in other emails.
>> >
>> > Also we fully intend to transition to BCMA but that would also be new
>> > feature added. Having AP mode and BCMA would enable you guys for
>> using
>> > it in the embedded targets, right?
>> >
>> >> > I'm not totally opposed to that idea but it does not solve the
>> >> primary issue of conflicting b43 and brcmsmac modules.
>> >>
>> >> I'm not convinced that this is an issue at all and I'm not convinced
>> >> that it has to be resolved.
>> >> At least not now.
>> >>
>> >
>> > It never hurts to look ahead. Both drivers have their use in the
>> linux
>> > tree and we should align which driver is doing what. Apparently we
>> should
>> > have yelled really hard when b43 was adding bcma support, because
>> then
>> > it snatched the chipsets we support as well. You learn your lessons
>> the
>> > hard way in Linux land, or so it seems ;-)
>>
>> And I should have notice you add code for N-PHY with your initial
>> brcm80211 commit ;) There's always something that you won't notice at
>> the correct time.
>>
>> --
>> Rafał
>
> Were you unaware of the chipsets that brcmsmac was supporting? When you
> Were working on N-PHY it was to enable certain chipsets, right? Was that
> in ssb context?

I was aware of supported chipsets (by their names), but I got no idea
that they (BCM43224 and BCM43225) are N-PHY based ones. I though that
that are some totally new PHYs (like SSLPN/HT/LCN/LCNXN/etc.).

-- 
Rafał
