Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm5.bullet.mail.ird.yahoo.com ([77.238.189.62]:48906 "HELO
	nm5.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932639Ab2HQHTZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 03:19:25 -0400
References: <1345115328.54417.YahooMailNeo@web29702.mail.ird.yahoo.com> <502D33E6.4050106@broadcom.com>
Message-ID: <1345187963.23828.YahooMailNeo@web29704.mail.ird.yahoo.com> (sfid-20120817_091929_189361_8142E28C)
Date: Fri, 17 Aug 2012 08:19:23 +0100 (BST)
From: Dani Camps <danicamps81@yahoo.com>
Reply-To: Dani Camps <danicamps81@yahoo.com>
Subject: Re: Forcing wi-fi chipset to sleep from bcm4329 driver
To: Franky Lin <frankyl@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <502D33E6.4050106@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Hi Franky,

Thanks for your quick answer.

I am working on a research project, and our intention is to study the effect that the Wi-Fi radio has on the battery life of an Android mobile phone. In particular we would like to be able to configure the wi-fi radio to stay "awake" for a certain time period and "sleeping" for other time periods, and then study how the length of these intervals affects battery lifetime. From your answer, I understand that we cannot control exactly the power state of the chipset, but I wanted to check with you whether the following approach might work:

0- We let the mobile device associate with an Access Point.
1- When we want the chipset to stay awake, we send from the driver a PM_OFF configuration command to the chipset. What I expect it would happen is that the chipset sends a packet to the AP with PM=0, and stays awake all the time.
2- When we want to send the chipset to sleep, we send from the driver a PM_MAX configuration command to the chipset. What I expect it would happen is that the chipset sends a packet to the AP with PM=1, and goes to sleep. Now, IF we can guarantee that there is no traffic to/from the mobile device during the time that we want the chipset to be sleep, then the chipset will indeed be sleeping *most* of the time. The only exception will be that the chipset will regularly wake up to catch a Beacon frame, but probably it is also possible to configure how often that happens, and thus the effect on our measurements is not large.

Do you think the previous method is sound?

Best Regards

Daniel




----- Mensaje original -----
De: Franky Lin <frankyl@broadcom.com>
Para: Dani Camps <danicamps81@yahoo.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Enviado: Jueves 16 de agosto de 2012 19:54
Asunto: Re: Forcing wi-fi chipset to sleep from bcm4329 driver

On 08/16/2012 04:08 AM, Dani Camps wrote:
> Dear all,
> 
> I would like to be able to control the power state (i.e. sleep/awake) of a broadcom wi-fi chipset controlled by the bcm4329 driver. My understanding of sleep/awake is the following: wi-fi chipsets support power saving protocols that allow them to enter into a low power state in order to save energy, this is what I understand as the sleep state. On the other hand when the chipset is fully powered and can directly receive data from the AP, this is what I understand as the chipset being in awake state.
> 
> Now, in the bcm4329 driver I have seen that the power mode of the wi-fi chipset can be configured with the parameters PM_MAX, PM_FAST and PM_OFF. My understanding though is that these are simply parameters to configure an internal power saving algorithm that is implemented in the chipset itself, e.g. if I configure PM_MAX it does not mean that the chipset will enter sleep mode immediately, but it will only do it according to a certain particular algorithm that I cannot conttol. Therefore, my question is whether it is possible to control the power state (sleep/awake) of the wi-fi chipset directly from within bcm4329.
> 

Hi Dani,

By bcm4329 I assume you are referring to the host driver could be found in Android's tree.

Anyway, bcm4329 and brcmfmac don't provide the capability to fully control the chip. As a fullmac mechanism the chip firmware handles the MAC stuff and knows the best timing of power management. Current PM implementation does quiet a good job. You can adjust some settings to further reduce the wake up frequency of the chip. But if you want anything better than that I am afraid cutting off the power supply is the only option.

Regards,
Franky
