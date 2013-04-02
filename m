Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55421 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759094Ab3DBQrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 12:47:08 -0400
Received: by mail-wi0-f180.google.com with SMTP id c10so654863wiw.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 09:47:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1364916033.9475.YahooMailNeo@web193504.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1364903851.35703.YahooMailNeo@web193501.mail.sg3.yahoo.com>
	<CAJ-Vmo=4Jbx6n8MO-=XkvNMOxvxHp-dN_hqKaHX9+nbGaqcn5A@mail.gmail.com>
	<1364916033.9475.YahooMailNeo@web193504.mail.sg3.yahoo.com>
Date: Tue, 2 Apr 2013 09:47:06 -0700
Message-ID: <CAJ-Vmokj=VHQuxb5BQE1nY5x-JtbivSWWfTXwTUscPN+yHRg=g@mail.gmail.com> (sfid-20130402_184726_262118_6933ABED)
Subject: Re: AR9287; mapping between GPIOs and COEX pins
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The point behind GPIO pins is that they're generic. There's a
multiplexer in the NIC which lets you map various GPIO pins to any
internal function.

So, you need to find which GPIO pins the bluetooth device is connected to.

Once you know that, you can set the GPIO input/output multiplexer bits
to give those GPIO pins the right BT behaviour.



Adrian


On 2 April 2013 08:20, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Mr.Adrian,
>     The card manufacturer like Compex systems for AR9287 has these pins
> available on PCIe interface. But my query is AR9287 specific. AR9287 is a 76
> pin IC. GPIO4 is Pin22, GPIO5 is Pin23, GPIO6 is Pin 24 and so on. The
> question is if I need to access COEX signals (WL_ACTIVE, BT_ACTIVE,
> BT_PRIORITY, BT_FREQUENCY), on which of these 76 pins can I access them?
> Please help.
>
> Regards
> Sandeep.
>
> From: Adrian Chadd <adrian@freebsd.org>
> To: sandeep suresh <sandeep.suresh@yahoo.co.in>
> Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>;
> "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
> Sent: Tuesday, 2 April 2013 8:23 PM
> Subject: Re: AR9287; mapping between GPIOs and COEX pins
>
> It depends on what the card manufacturer has done.
>
>
>
>
> Adrian
>
> On 2 April 2013 04:57, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
>> Hello All,
>>        In AR9287, there are ten GPIOs and GPIO[0:3] are mapped to JTAG.
>> Remaining GPIOs [4:9] are free. Can you please help me with the mapping of
>> GPIO pins to COEX pins? That means which GPIO is connected to:
>> a) WLAN_ACTIVE
>> b)BT_PRIORITY
>> c)BT_ACTIVE
>> d)BT_FREQUENCY
>>
>> Thanks & regards
>> Sandeep.
>
>
