Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:64360 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbYEUTSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 15:18:46 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1742436ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 12:18:34 -0700 (PDT)
Message-ID: <445f43ac0805211218v58d33458v41d0d11f98ed4f14@mail.gmail.com> (sfid-20080521_211851_323345_0620DF68)
Date: Wed, 21 May 2008 12:18:34 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile configuration.
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	carrano@laptop.org, dilinger@queued.net
In-Reply-To: <1211396780.21380.368.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
	 <1211292718.21380.238.camel@pmac.infradead.org>
	 <445f43ac0805211159u317bf720vd88d29a504445ba6@mail.gmail.com>
	 <1211396780.21380.368.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David,

On Wed, May 21, 2008 at 12:06 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2008-05-21 at 11:59 -0700, Javier Cardona wrote:
>>
>> If the boottime is set smaller than the host boot time, the device
>> will transition into standalone mode before it is detected by the
>> host.  The only recovery when that happens is to either reset the
>> device via an external reset line or to re-insert it.
>
> Nah, the driver will send it a CMD_802_11_RESET when it finds it not
> responding properly to bootcmds, and it should be fine.

You need a live endpoint to send a CMD_802_11_RESET, which you won't
have if the device did not respond to USB enumeration because it was
in standalone mode.

Javier

-- 
Javier Cardona
cozybit Inc.
