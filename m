Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1113 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab2HPRyz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 13:54:55 -0400
Message-ID: <502D33E6.4050106@broadcom.com> (sfid-20120816_195459_786157_EF422AFF)
Date: Thu, 16 Aug 2012 10:54:46 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Dani Camps" <danicamps81@yahoo.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Forcing wi-fi chipset to sleep from bcm4329 driver
References: <1345115328.54417.YahooMailNeo@web29702.mail.ird.yahoo.com>
In-Reply-To: <1345115328.54417.YahooMailNeo@web29702.mail.ird.yahoo.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2012 04:08 AM, Dani Camps wrote:
> Dear all,
>
> I would like to be able to control the power state (i.e. sleep/awake) of a broadcom wi-fi chipset controlled by the bcm4329 driver. My understanding of sleep/awake is the following: wi-fi chipsets support power saving protocols that allow them to enter into a low power state in order to save energy, this is what I understand as the sleep state. On the other hand when the chipset is fully powered and can directly receive data from the AP, this is what I understand as the chipset being in awake state.
>
> Now, in the bcm4329 driver I have seen that the power mode of the wi-fi chipset can be configured with the parameters PM_MAX, PM_FAST and PM_OFF. My understanding though is that these are simply parameters to configure an internal power saving algorithm that is implemented in the chipset itself, e.g. if I configure PM_MAX it does not mean that the chipset will enter sleep mode immediately, but it will only do it according to a certain particular algorithm that I cannot conttol. Therefore, my question is whether it is possible to control the power state (sleep/awake) of the wi-fi chipset directly from within bcm4329.
>

Hi Dani,

By bcm4329 I assume you are referring to the host driver could be found 
in Android's tree.

Anyway, bcm4329 and brcmfmac don't provide the capability to fully 
control the chip. As a fullmac mechanism the chip firmware handles the 
MAC stuff and knows the best timing of power management. Current PM 
implementation does quiet a good job. You can adjust some settings to 
further reduce the wake up frequency of the chip. But if you want 
anything better than that I am afraid cutting off the power supply is 
the only option.

Regards,
Franky

