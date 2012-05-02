Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:37863 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059Ab2EBQCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 12:02:09 -0400
Message-ID: <4FA15A70.2020108@stericsson.com> (sfid-20120502_180213_541293_D054C200)
Date: Wed, 2 May 2012 18:01:52 +0200
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
To: Kevin Groeneveld <kgroeneveld@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
In-Reply-To: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

>> Please find below in the patchset implementation of a new driver for
>> the ST-Ericsson cw1200 wlan device.
> Hello Dmitry,
>
> What firmware version is this driver tested with?  Where can I get the
> firmware files?
The driver was tested with WSM_A30.02.0380 (and lot of other releases:)).
The firmware was available at igloocommunity.org, I will try to find a link.

>
> I have build 328 and 380 but I cannot get the driver to work with
> either of these.  Everything looks like it is working okay but when I
> run "iw wlan0 scan" it does not find anything.  The debugfs counters
> show I am not receiving any valid packets:
>
Could you enable following options and send kernel log:
CW1200_DEBUGFS=y
CW1200_WSM_DEBUG=y
CW1200_WSM_DUMPS=y
CW1200_BH_DEBUG=y

and also please send content of 
/sys/kernel/debug/ieee80211/phy0/cw1200/status

Best regards,
Dmitry
