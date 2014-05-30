Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50383 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbaE3JbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 05:31:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1WqJ9V-0000KQ-9t
	for linux-wireless@vger.kernel.org; Fri, 30 May 2014 11:31:05 +0200
Received: from 89-68-80-14.dynamic.chello.pl ([89.68.80.14])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 11:31:05 +0200
Received: from pitkotko by 89-68-80-14.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 11:31:05 +0200
To: linux-wireless@vger.kernel.org
From: piotr <pitkotko@gmail.com>
Subject: Re: [Ilw] Wireless Centrino 2230-N issues
Date: Fri, 30 May 2014 09:30:51 +0000 (UTC)
Message-ID: <loom.20140530T111920-677@post.gmane.org> (sfid-20140530_113112_167050_F89D4534)
References: <536F6620.9030001@gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303DF0FF6@HASMSX103.ger.corp.intel.com> <loom.20140530T020912-598@post.gmane.org> <53882EAD.4010609@gmail.com> <53882EF4.4070105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@...> writes:

> 
> >>
> >> I have similar problem. My system is Ubuntu 14.04 with kernel 3.13.0-24
> >> installed on a new Toshiba laptop with N2230 wifi card. 
> >> dmesg:
> >> [  614.007461] iwlwifi 0000:01:00.0: Could not complete ALIVE
transition: -5
> >> [  614.007748] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
> >> [  614.007790] iwlwifi 0000:01:00.0: Unable to initialize device.
> >> [  614.008318] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> >> [  614.015390] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
> >> [  614.059495] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD
failed:
> >> FW Error
> >>
> >> Is the card broken?
> >>
> >> Best,
> >> Piotr
> >>
> >>
> > 
> > Can you try to add bt_coex_active=0 as debug parameter?
> > 
> 
> Sorry, I meant *module* parameter. The mode is iwlwifi

Thanks for quick reply.

I've tried your suggestion on the fly: 

modprobe -rv iwlwifi
modprobe iwlwifi bt_coex_active=0

After this, I get "N" from "more
/sys/module/iwlwifi/parameters/bt_coex_active", but it seems not to take any
effect on device functioning nor on the kernel messages. 
Is this what you meant? BTW, the bluetooth seems to work.

Best,
Piotr

