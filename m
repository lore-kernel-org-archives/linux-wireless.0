Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4961 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab2CEJbR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 04:31:17 -0500
Message-ID: <4F5487DA.2010805@broadcom.com> (sfid-20120305_103121_535318_E6D0FAEE)
Date: Mon, 5 Mar 2012 10:31:06 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] brcm80211: fmac: initialize host interface
 drivers regardless result
References: <1330725351-3803-1-git-send-email-arend@broadcom.com>
 <1330725351-3803-5-git-send-email-arend@broadcom.com>
 <CAGRGNgXbkV-OkB5XG8+HqmmxG6f3RfgAkfnb_XxhXYU5+yN6Ug@mail.gmail.com>
In-Reply-To: <CAGRGNgXbkV-OkB5XG8+HqmmxG6f3RfgAkfnb_XxhXYU5+yN6Ug@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/2012 11:49 PM, Julian Calaby wrote:
> Hi Arend,
>
> On Sat, Mar 3, 2012 at 08:55, Arend van Spriel<arend@broadcom.com>  wrote:
>> The module init function of brcmfmac calls init functions for SDIO and
>> USB doing driver registration. This patch removes terminating the module
>> init when a driver registration for one host interface fails.
>
> Would it be better to fail the module load if *none* of them succeed -
> there's probably no point in having the module loaded if it's not
> actually hooked up to anything.
>

Thanks, Julian

However, the next patch in this series would undo the init code 
behaviour you are proposing. The brcmf_sdio_init() already logs the 
failed driver registration. I will add the same to brcmf_usb_init() in a 
separate patch. Is that ok with you?

Gr. AvS


