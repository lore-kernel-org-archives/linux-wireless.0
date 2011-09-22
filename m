Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49145 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1IVKH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 06:07:57 -0400
Received: by fxe4 with SMTP id 4so2576530fxe.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 03:07:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0CC8ABB9@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <20110920130338.GA9885@kroah.com> <20110920132203.GB7800@tuxdriver.com>
 <20110920140020.GA11386@kroah.com> <7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
 <CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
 <20110922003523.0bf6a460@milhouse> <7A94256FD72B884D9E7C55586C3CBCEE195814DE92@SJEXCHCCR01.corp.ad.broadcom.com>
 <20110922012851.2f3b7801@milhouse> <400C43189542CE41BC0A5B252FC90136BC0CC8ABB9@SJEXCHCCR02.corp.ad.broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 22 Sep 2011 12:07:36 +0200
Message-ID: <CAOiHx==ubVZBHwVBph5uAJSsT_0g6fv5w2YPT-3T7Tkv6wsZgA@mail.gmail.com> (sfid-20110922_120806_208042_F051EB40)
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch #2
To: Arend Van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
	Brett Rudley <brudley@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/22 Arend Van Spriel <arend@broadcom.com>:
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Michael Büsch
>> Sent: donderdag 22 september 2011 1:29
>> To: Brett Rudley
>> Cc: Rafał Miłecki; Greg KH; John W. Linville; Franky (Zhenhui) Lin;
>> gregkh@suse.de; devel@linuxdriverproject.org; linux-
>> wireless@vger.kernel.org
>> Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for
>> mainline patch #2
>>
>> On Wed, 21 Sep 2011 16:15:10 -0700
>> "Brett Rudley" <brudley@broadcom.com> wrote:
>>
>> > We did however initially propose (and implement) a dividing line of
>> ssb chips for b43 and AXI based chips for brcmsmac but b43 team chose
>> to ignore/reject that.
>>
>> Well, what about embedded, for instance?
>
> The brcmsmac driver has been tested on a MIPS platform by Jonas Gorski
> although only in STA mode (on a bcm63xx). Not having AP mode has been
> explained in other emails.

This just happened to be a MIPS, but apart from that it was still a
mostly standard fare PCIe connected BCM4313, no nothing really
embedded. What Michael (and Hauke, and Rafal) is talking about are
BCM47xx SoC where AMBA/AXI is the System Bus, and there is no PCI(e)
at all (except maybe for connecting a /second/ wifi).

This was one of the main motivations of the bcma driver.

Regards,
Jonas

P.S: Which reminds me, do you plan to (not) support the integrated
wifi in the BCM6362? This one seems to be neither bcma nor ssb, but
it's definitely Broadcom ;) (Haven't gotten my hands yet on a device
though).
