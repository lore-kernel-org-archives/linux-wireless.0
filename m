Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62324 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab2AEQL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 11:11:26 -0500
Message-ID: <4F05CBA9.1070602@lwfinger.net> (sfid-20120105_171135_984257_51A16734)
Date: Thu, 05 Jan 2012 10:11:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	gwingerde@gmail.com, linville@tuxdriver.com, davem@davemloft.net,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2] drivers: net: Fix dependency for EEPROM_93CX6
References: <1325770673-17309-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1325770673-17309-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2012 07:37 AM, Fabio Estevam wrote:
> Fix the following build warning:
>
> warning: (KS8851&&  AX88796_93CX6&&  RTL8180&&  RTL8187&&  ADM8211&&  RT2400PCI&&  RT2500PCI&&  RT61PCI&&  RT2800PCI&&  R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES)
>
> Signed-off-by: Fabio Estevam<fabio.estevam@freescale.com>
> ---
> Changes since v1:
> - Place MISC_DEVICES dependency into the 'depends on' line

Is this the right way to fix this? Whenever I get this kind of build warning, I 
usually attribute it to a problem with my local configuration and fix my copy of 
.config, not modify the build system. With this change, it seems to me that a 
lot of devices will suddenly disappear from the build with little explanation. I 
don't feel confident enough to NACK the patch, but I would like an expert to 
comment.

I have noticed that the defconfigs for various architectures are split between 
turning MISC_DEVICES on or off.

Larry
