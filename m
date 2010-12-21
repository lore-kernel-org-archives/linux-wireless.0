Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64560 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0LUMU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 07:20:58 -0500
Received: by qwa26 with SMTP id 26so3909140qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 04:20:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292931273.13493.2.camel@maggie>
References: <1292928622-27651-1-git-send-email-zajec5@gmail.com>
	<1292928622-27651-2-git-send-email-zajec5@gmail.com>
	<1292931273.13493.2.camel@maggie>
Date: Tue, 21 Dec 2010 13:20:57 +0100
Message-ID: <AANLkTi=--XSasFtDpiq-uXDrMWjQzrK-cnGZVyqFsSif@mail.gmail.com>
Subject: Re: [PATCH 2/4] b43: N-PHY: implement radio 2056 init steps
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 21 grudnia 2010 12:34 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Tue, 2010-12-21 at 11:50 +0100, Rafał Miłecki wrote:
>> +static void b43_radio_init2056_post(struct b43_wldev *dev)
>> +{
>> +     b43_radio_set(dev, B2056_SYN_COM_CTRL, 0xB);
>> +     b43_radio_set(dev, B2056_SYN_COM_PU, 0x2);
>> +     b43_radio_set(dev, B2056_SYN_COM_RESET, 0x2);
>> +     mdelay(1);
>
> Please don't use mdelay() ever. The driver is fully preemptible.
> Use msleep() instead.

So, using "msleep" allows kernel to switch context, while using
"mdelay" does not?

If so, should be convert our longer udelay calls (like 300us) to usleep?

-- 
Rafał
