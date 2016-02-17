Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35910 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424168AbcBQQDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 11:03:50 -0500
Received: by mail-ob0-f177.google.com with SMTP id gc3so20356822obb.3
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2016 08:03:50 -0800 (PST)
Subject: Re: Wrong wireless nick card name loaded on reboot
To: German <gentgerman@gmail.com>, linux-wireless@vger.kernel.org
References: <20160217060909.694a9aff@libertarian.asterius.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56C499E0.3070909@lwfinger.net> (sfid-20160217_170354_855344_57F0905A)
Date: Wed, 17 Feb 2016 10:03:44 -0600
MIME-Version: 1.0
In-Reply-To: <20160217060909.694a9aff@libertarian.asterius.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2016 05:09 AM, German wrote:
> Hi list,
>
> A couple of days ago I asked why my pc changes the wireless card name.
> It switches between AR9285 ( right) and AR5008 ( wrong). Someone
> suggested  that this is because another kernel module is loaded by
> mistake. Well, it is not the case. When system identified with AR9285,
> it loads ath9k and I can connect to the router. When system identifies
> my card as AR5008, no kernel module is present at all ( lspci -k). The
> wrong card name occurs only when system rebooted. If I gracefully shut
> down the system, it always comes up with a right name for the card
> ( AR9285). So, how to force the system identify my card right no matter
> if I reboot or shut down? Thank you.

I would like to help you, but I do not remember your earlier message. Why did 
you not reply to the earlier one so that everything would be in the same thread? 
That would have made searching the archives easier. As a result, I may be 
duplicating some previous information.

The selection of a driver for a given device comes from the PCI ID. If your 
system is showing the wrong device, then you may have hardware problems such 
that the PCI ID is reported incorrectly. To test this, please provide the output 
of the command

lspci -nn | grep Network

for the "good" and "bad" case.

Larry


