Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41961 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab1JSMIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 08:08:44 -0400
Received: by gyb13 with SMTP id 13so1568213gyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 05:08:43 -0700 (PDT)
Message-ID: <4E9EBDD3.6060907@lwfinger.net> (sfid-20111019_140847_523164_FB27EA99)
Date: Wed, 19 Oct 2011 07:08:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: v4mp <gaigo88@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gm ail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T1  61652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net> <loom.20111017T115802-634@post.gmane.org > <4E9C42CF.5010702@lwfinger.net> <loom.20111017T190430-717@post.gmane.org> <4E9CF13A.7060102@lwf inger.net> <loom.20111018T143746-420@post.gmane.org> <loom.20111018T150303-359@post.gmane.org> <4E9D9953.3020601@lwfinger.net> <loom.20111018T233233-298@post.gmane.org> <4E9E052F.8090705@lwfinger.net> <loom.20111019T101621-921@post.gmane.org>
In-Reply-To: <loom.20111019T101621-921@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/19/2011 03:17 AM, v4mp wrote:
>
> i don't know why you are saying this, i was just kidding....
> you take me too seriously...
> i think i'm doing a favour to you too debugging this..
>
> however with the rtl8192cu the hardware doesn't work with
> the ep error related to xhci_hcd..
> it is the point that we are now
>
> there is something more can i do now?
>   i don't have any other usb port that works with other controller like ehci..

You can set up usbmon and dump the starting USB traffic for rtl8192cu and for 
the Alfa driver, but please do not let it run for a long time. Those dumps get 
very long. Load the driver you want with the device unplugged, then plug in the 
device, and dump the buffer 3-4 seconds later. The instructions for using usbmon 
are at http://www.mjmwired.net/kernel/Documentation/usb/usbmon.txt or in 
Documentation/usb/usbmon.txt in the source tree.

The other thing you could do is to plug in the device with rtl8192cu as the 
driver and after 1 second dump the dmesg log with 'dmesg > dmesg.out'. In your 
previous attempt, you let the buffer wrap around and important info was lost. 
These logs should be posted at Pastebin.

I sent a request for info regarding this to the Chinese group that wrote the 
driver, but I have not heard back.

Larry
