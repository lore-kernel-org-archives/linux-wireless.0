Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62503 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0IVQKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 12:10:25 -0400
Received: by yxp4 with SMTP id 4so218204yxp.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 09:10:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinaaAp8XXbqEmA-BCEbSQ8oMV5M-BNSs2iKmyNk@mail.gmail.com>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
	<201009221336.14382.chunkeey@googlemail.com>
	<AANLkTim3YQ4vNyM_OA4qc+mjGJiwYoHrLB=x1sp+R8vP@mail.gmail.com>
	<201009221424.39949.chunkeey@googlemail.com>
	<AANLkTikbyQi7dJFrqJrVmr7kV==tZoLRPaufC6tJv743@mail.gmail.com>
	<AANLkTi=OF0=Ox7xoGpygL87eoxDyEgDiALi4R-pSNe+V@mail.gmail.com>
	<AANLkTinaaAp8XXbqEmA-BCEbSQ8oMV5M-BNSs2iKmyNk@mail.gmail.com>
Date: Wed, 22 Sep 2010 20:10:21 +0400
Message-ID: <AANLkTinn-nPed0nCvveBUtkY3AEHf_+bVvV=q1J=XzdY@mail.gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Alex Mihaylov <minimumlaw@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/22 Max Filippov <jcmvbkbc@gmail.com>:
>> This code from Sagrad:
>>
>>        SPI_IRQ(DISABLE);
>>
>> [skiped]
>
> If you look closer into the skipped part you'll see
>
>        // 13. Enable host interrupts (EHostIntEnable1 = KIrqReady |
> KIrqWrReady | KHwUpdate | KSwUpdate)
>        TempReg = (SPI_HOST_INT_READY | SPI_HOST_INT_UPDATE |
> SPI_HOST_INT_SW_UPDATE| SPI_HOST_INT_WR_READY);
>        SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, TempReg);
>
> which actually enables interrupts, exactly as SPI_IRQ(ENABLE); does.
>
>>
>>       // 14. Wait for the READY interrupt (100 ms timeout).
>>        // Loop while waiting for SPI device to respond with
>> interrupt, max timeout is WIFI_BOOT_TIMEOUT
>>        for ( i = 0 ; i < WIFI_BOOT_TIMEOUT ; i++)
>>        {
>>                TempReg = SPIDRVReadReg32(SPI_ADRS_HOST_INTERRUPTS);
>>                if( TempReg && SPI_HOST_INT_READY)
>>                {
>>                        // 15. Acknowledge the READY interrupt.
>>                        SPIDRVWriteReg32(SPI_ADRS_HOST_INT_ACK,
>> SPI_HOST_INT_READY);
>>                        // 16. Issue the SLEEP interrupt.
>>                        SPIDRVWriteReg32(SPI_ADRS_ARM_INTERRUPTS,
>> SPI_ARM_INT_SLEEP);
>>                        break;
>>                }
>>
>>                Delay(1);
>>        }
>>
>>        SPI_IRQ(ENABLE);

OK. Chip (STLC4560) have some reasons to make IRQ reqest to host
(XScale or Omap). In code:

SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, TempReg);

we set IRQ mask for chip. So, chip CAN generate IRQ request to host
(make pulse on host IRQ GPIO line). But host NOT serve this interrupt
request ( SPI_IRQ(DISABLE) ). Host wait for event by pool interrupt
reason register. In linux kernel (p54spi.c) host serve this IRQ.
SPI_IRQ(ENABLE/DISABLE) used for enable/disable host handler, but
SPIDRVWriteReg32(SPI_ADRS_HOST_INT_EN, TempReg) used for device IRQ
reason control. I think so.

And some words about license. On Sagrad web site this file described:

URL: http://sagrad.com/index.php?option=com_docman&task=doc_details&gid=26&Itemid=101
(download possible after registration on web site).
Name: Sagrad_MAC GPL Source Code + IP Stack
Description: FreeRTOS with: - WiFi SPI driver - Custom Sagrad MAC with
ability to scan and associate to an Open AP - uIP stack to provide
TCP/IP
Filename:        STM32Wifi_V.1.0.0.1.zip

FreeRTOS distributed under GPL. Sagrad say - GPL code. But, in head of
file wrote:
/*
 * IMPORTANT--READ CAREFULLY:
 *
 * Right, including without limitation, use, reproduction,
modification, and
 * creation of derivative works, pertaining to this Source Code
("Document")
 * are governed by a legal Agreement ("Agreement") between you (either
an
 * individual or a single entity) and Sagrad Inc("Sagrad")
 * and/or its licensee (both hereinafter called Licensor).
 *
 * By reproducing, modifying, creating derivative works, accepting,
 * installing, viewing, accessing, transforming or otherwise using
this
 * Document, you agree to be bound by the terms of the Agreement. If
you
 * do not agree to the terms of the Agreement, Licensor is unwilling
to
 * license rights to this Document to you.  In such event, you may not
 * use, reproduce, modify, create derivative works, install, view,
access,
 * transport, transform or circulate this Document, and you should
promptly
 * contact Licensor from which you acquired this Document for
instructions
 * on returning or destroying this Document.
 *
 *
 * CONFIDENTIAL, PROPRIETARY AND TRADE SECRET INFORMATION: This
Document
 * contains confidential, proprietary and trade secret information of
 * Intersil Americas Inc. and should be treated in a confidential
manner.
 * Furthermore, this Document is protected by national copyright laws
and
 * international treaties.
 *
 * Unauthorized use, reproduction, modification, creation of
derivative
 * works or circulation is strictly prohibited.
 *
 * Copyright (c) 2008 Sagrad Inc. All Rights Reserved.
 *
 * The intent of Sagrad is to release this source to the public under
GPL
 * upon the successful agreement with STMicro for the exclusive
 * distribution rights for the STLC4560
 */

This code cant be directly placed into kernel source (FreeRTOS is NOT
Linux). This code contents NOT a code, but initialization and working
methods.

--
Sincerelly,
Alex A. Mihaylov
AKA MinimumLaw
