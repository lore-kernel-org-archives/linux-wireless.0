Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36027 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1JPCtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 22:49:35 -0400
Received: by iaek3 with SMTP id k3so4451053iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 19:49:34 -0700 (PDT)
Message-ID: <4E9A4647.60901@lwfinger.net> (sfid-20111016_044952_123803_604CFD36)
Date: Sat, 15 Oct 2011 21:49:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: v4mp <gaigo88@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9 xOn5hutA6q01r0yBeOXz0ivw@mail.gmail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T161652-440@post.gmane.org>
In-Reply-To: <loom.20111015T161652-440@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2011 09:22 AM, v4mp wrote:
>
>
> i've tried also kernel 3.1-rc9 with latest compat wireless 14-10-2011 and still
> don't work...it was recognized but no APs can be detected..the led of the alfa
> is off..seems that it is power off..
>
> i don't know about firmware, i see that there are .bin on lib/firmware/rtlwifi..
>   how can i update them?

That depends on your distro, but please look at the output of the dmesg command 
to see if there is an error loading the firmware.

You also need to install rfkill and look at the output of 'rfkill list'. If you 
have another wireless device that is being hard blocked, or if there is a soft 
block active, then rtl8192cu cannot work.

Note that the device works on my system. There should not be a problem with the 
driver on your device once we clean up these questions. Once the device gets the 
proper firmware and the RF is unblocked, the LED will light.

Larry

