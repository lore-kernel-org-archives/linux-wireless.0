Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57874 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab2BSPhh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 10:37:37 -0500
Message-ID: <4F411729.5070705@hauke-m.de> (sfid-20120219_163806_967929_C73B2D90)
Date: Sun, 19 Feb 2012 16:37:13 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend Van Spriel <arend@broadcom.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] use alternate SPROM offset for 43224
References: <20120214040120.GA2077@eris.garyseven.net> <CACna6rwXEjsJEPK4EZ9pbh2sGJgvt05JRfo2HkeDKpT26YORwg@mail.gmail.com> <CAG=dh1pTDSkkhgXGOv=n8uferq61-Db0EFGexO=ZZ+oN6w8_hQ@mail.gmail.com> <CACna6rw=ZJe28ahRQFU-_9+BD8+L5SNV_xdwxLxUdNk-b3HHxg@mail.gmail.com> <20120214185202.GA5339@eris.garyseven.net> <4F3ABFB0.3020502@lwfinger.net> <4F3AC20E.8080502@hauke-m.de> <4F3ADA6E.4050301@lwfinger.net> <400C43189542CE41BC0A5B252FC90136BC8414D128@SJEXCHCCR02.corp.ad.broadcom.com>
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC8414D128@SJEXCHCCR02.corp.ad.broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 11:39 PM, Arend Van Spriel wrote:
>> Sent: dinsdag 14 februari 2012 23:04
>>
>> On 02/14/2012 02:20 PM, Hauke Mehrtens wrote:
>>>>>  I think it is more complicated than the above. On my 43224, I get
>> the
>>>>>  message "No SPROM available", which arises because
>> bcma_sprom_get() is
>>>>>  returning -ENOENT. The reason is that the value tested in "if
>>>>>  (!(sromctrl&  BCMA_CC_SROM_CONTROL_PRESENT))" is zero. The
>> contents of
>>>>>  sromctl are 0x12, and the mask is 1.
>>> This check is the main part of ai_is_sprom_available() in brcmsmac.
>> If
>>> this check fails, like in your case, brcmsmac tries otp_read_pci() to
>>> read out the sprom, which is not implemented in bcma.
>>
>> I will try implementing a similar routine in bcma.
>>
> 
> I started adding proper OTP support in BCMA, but I am currently working on async firmware loading feature. Different chipsets can either have an external SPROM or on-chip OTP. Some have both, but only one holds the data.
> 
> Gr. AvS
Nice to hear you are working on OTP support in bcma. In that process,
are you also working on making brcmsmac using the sprom provided by bcma?

Hauke

