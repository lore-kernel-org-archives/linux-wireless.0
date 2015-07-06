Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv.colino.net ([212.83.157.151]:50434 "EHLO mx.colino.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbbGFWQQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 18:16:16 -0400
Received: from net24.it (unknown [151.50.212.211])
	by mx.colino.net (Postfix) with ESMTPSA id 08E4736A431D
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2015 00:16:12 +0200 (CEST)
Date: Tue, 7 Jul 2015 00:16:11 +0200
From: Salvatore De Paolis <iwkse@claws-mail.org>
To: linux-wireless@vger.kernel.org
Subject: Re: Problem with firmware, rt2x00
Message-ID: <20150707001611.550745c4@net24.it> (sfid-20150707_001620_566445_777277B2)
In-Reply-To: <20150706203738.6fe7c3ea@net24.it>
References: <20150706203738.6fe7c3ea@net24.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 6 Jul 2015 20:37:38 +0200
Salvatore De Paolis <iwkse@claws-mail.org> wrote:

> Hi all,
> 
> after updating the kernel and udev plus other packages I am not able anymore
> to let my PCI wireless card works.
> 
> The device is listed as RT2561/RT61 (no rev. B)
> 
> After the update when issuing a "up" I get an error like: rt61pci agent
> aborted rt2561s (not found?)
> 
> I have the firmware-ralink and such file is available in /lib/firmware
> 
> Monitoring the udev event I can see the action "add" is followed by a
> "remove".
> 
> on my udev rule, 50-firmware.rules I have:
> 
> SUBSYSTEM=="firmware" , ACTION=="add", ATTR{loading}="-1"
> 
> Anyone has a clue about what could I do to fix this issue?
> 
> Best regards,
> 

Nevermind..I solved it. The upgrade messed up the udev rule and deleted the firmware.agent
binary. I followed this http://rt2x00.serialmonkey.com/phpBB-static/5/t-4594.html and everything
is fine again.

-- 
Salvatore
