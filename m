Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:56186 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab3J0Qca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 12:32:30 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.80.1 #4)
	id 1VaTGO-0000be-E7
	for linux-wireless@vger.kernel.org; Sun, 27 Oct 2013 17:32:28 +0100
Received: from localhost ([::1]:33733 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.80.1 #4)
	id 1VaTGO-0006E6-9q
	for linux-wireless@vger.kernel.org; Sun, 27 Oct 2013 17:32:28 +0100
Received: from mx9.freenet.de ([195.4.92.19]:44088)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.80.1 #4)
	id 1VaTDQ-0004Lw-Ju
	for linux-wireless@vger.kernel.org; Sun, 27 Oct 2013 17:29:24 +0100
Received: from p4fde051c.dip0.t-ipconnect.de ([79.222.5.28]:39596 helo=mail.maya.org)
	by mx9.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256) (port 25) (Exim 4.80.1 #4)
	id 1VaTDQ-0005gJ-B6
	for linux-wireless@vger.kernel.org; Sun, 27 Oct 2013 17:29:24 +0100
Message-ID: <526D3F54.5020808@01019freenet.de> (sfid-20131027_173233_887899_FF411C1E)
Date: Sun, 27 Oct 2013 17:29:08 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Kevin Lo <kevlo@kevlo.org>, John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: update RF registers
 for RT5390
References: <20131024052408.GA7828@ns.kevlo.org>	<52694D8B.1030308@01019freenet.de> <5269D154.5000606@kevlo.org>
In-Reply-To: <5269D154.5000606@kevlo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kevin!

Kevin Lo wrote:
> Andreas Hartmann wrote:
[...]
>> In a nutshell: Use a few, but big USB packets instead of a lot of small
>> ones, which needs a lot of interrupts / s and therefore needs a lot of
>> CPU resources - which aren't available on the PI at all.
> 
> I have a lot of embedded devices (Freescale imx5/imx6, Marvell armanda xp
> ... etc) here and I've also noticed usb performance issues.
> 
> Firstly, I want to sync register settings, which is obtained from the
> vendor driver.  When it's done, I will take a look at how usb is handled by
> the vendor driver and fix performance issues.  Since I don't have
> datasheets,
> I'm not sure updating register values won't help much...

The problem is: as long as the USB interface "filters" as bottleneck
each small change, it's hard to tell if the change was successful or not.
But I'm happy to hear that you see the same problems and I would be
happy if you could fix them. I can test the fixes you hopefully provide
with big (SMP hardware) and small (ARM) hardware and with rt3572 and rt3573.


Thanks,
kind regards,
Andreas
