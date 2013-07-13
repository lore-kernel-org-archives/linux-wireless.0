Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alpha.kreiz-it.fr ([178.32.219.166]:30358 "EHLO
	alpha.kreiz-it.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3GMKM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jul 2013 06:12:26 -0400
Received: from DirTech (lnr56-1-82-246-51-185.fbx.proxad.net [82.246.51.185])
	by alpha.kreiz-it.fr (Postfix) with ESMTPSA id 9BE73B30
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jul 2013 12:12:23 +0200 (CEST)
From: "Cedric GROSS" <cg@cgross.info>
To: <linux-wireless@vger.kernel.org>
Subject: Firmware error for Centrino N 2230
Date: Sat, 13 Jul 2013 12:12:17 +0200
Message-ID: <001a01ce7fb1$75bfdc10$613f9430$@info> (sfid-20130713_121243_717191_47D161E2)
MIME-Version: 1.0
Content-Type: text/plain;
	boundary="----=_NextPart_000_000A_01CE7FBC.95D29C30";
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I’m trying to adapt current freebsd driver for supporting my 2230 NIC.

I try to follow ucode command order defined in kernel 3.2 but I reach some
difficulties because firmware raise error.

Runtime uCode is alive. So far I sent calib result (cmd xB0), configured
advanced BT coexistence (cmd x9B,xCC and xCD) running runtime calib (cmd
x65) but the command configuring valid chain (cmd x65) failed as the result
below : 
CSR values: (2nd byte of IWN_INT_COALESCING is IWN_INT_PERIODIC)
  IWN_HW_IF_CONFIG: 0x00800302   IWN_INT_COALESCING: 0x0000ff40     
IWN_INT: 0x04000000
  IWN_INT_MASK: 0x00000000   IWN_FH_INT: 0x00000000   IWN_GPIO_IN:
0x00000000
   IWN_RESET: 0x00000000   IWN_GP_CNTRL: 0x080403c5   IWN_HW_REV: 0x000000c8
  IWN_EEPROM: 0x08450ffd   IWN_EEPROM_GP: 0x90000801   IWN_OTP_GP:
0x00030001
     IWN_GIO: 0x00080044   INW_GP_UCODE: 0x00000004   IWN_GP_DRIVER:
0x00000080
  IWN_GP1_DRIVER: 0x00000000   IWN_UCODE_DRV_GP2: 0x00000000      IWN_LED:
0x00000018
  IWN_DRAM_INT_TBL: 0x880b76e5   IWN_GIO_CHICKEN: 0x29800200   IWN_ANA_PLL:
0x00000000
  IWN_HW_REV_WA: 0x0001001a   IWN_DBG_HPET_MEM: 0xffff0000
firmware error log:
  error type      = "UNKNOWN" (0x00001987)
  program counter = 0x000179B4
  source line     = 0x00000167
  error data      = 0x0000000000000000
  branch link     = 0x0001798200017982
  interrupt link  = 0x0000EC7A00000000
  time            = 46566

What I’m missing ?
What is meaning of firmware error ?

Many thanks for your help.

Best regards 
Cedric

