Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:64102 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760261Ab3DCMbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:31:20 -0400
Received: by mail-bk0-f49.google.com with SMTP id w12so799408bku.36
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2013 05:31:19 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Status of the RTL8712 staging driver
Date: Wed, 3 Apr 2013 14:31:14 +0200
Cc: Juan Carlos Garza Fernandez <juancarlosgarza@gmail.com>,
	linux-wireless@vger.kernel.org, Joshua.Roys@gtri.gatech.edu
References: <CAMEN=G4gwKC5oTbJyDfU4QcnO+EAff+nGsj+++AH0ip4eVV3MA@mail.gmail.com> <201304021941.37133.chunkeey@googlemail.com> <515B475D.2090709@lwfinger.net>
In-Reply-To: <515B475D.2090709@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201304031431.15081.chunkeey@googlemail.com> (sfid-20130403_143125_257003_8CCD1FF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, April 02, 2013 11:02:21 PM Larry Finger wrote:
> On 04/02/2013 12:41 PM, Christian Lamparter wrote:
> > On Tuesday, April 02, 2013 02:51:19 PM Juan Carlos Garza Fernandez wrote:
> >> Now I have another question regarding the 8712 driver which has been
> >> in staging forever.
> >>
> >> In your opinion, are there any chances that it will be improved to
> >> reach the mainline level?
> 
> Yes, r8712u has been in staging for a long time; however, it is not a matter of 
> improving it. For a new wireless driver to be included in the main wireless 
> directories, it must use mac80211. Making the change from the current softmac in 
> r8712u to a mac80211-based driver is essentially a complete rewrite., 
Oh, Joshua Roys had already investigated a mac80211 driver and abandoned
it since it is not possible:

"... Some differences from rtl8192se were eliminated, although all PHY/BB/RF
reg commands are still commented out.  *When any of those regs were accessed 
directly, the device would die*. When accessed through the IOCMD regs, the
firmware on the device would seem to disable automatic control of some 
important functions causing a large drop in receive sensitivity and general
performance." <http://marc.info/?l=linux-wireless&m=133644367402433>

The driver can't initialize the PHY and while the firmware has a command
to set the phy to a specified channel, you can't define the channel mode:
whenever it is supposed to be legacy, HT20, HT40+ or HT40-...

That's the reason why the new r92su now interfaces with cfg80211 instead
of mac80211. The *su firmware really forces you to use the "high-level"
commands it has for scan, connect, disconnect and join_ibss. 
(Furthermore, the scan/connect/... cmds also do the whole MLME work: probe,
(de-)auth, (dis-/re-)assoc and action for BA...  Unfortunately, mac80211
wants to do this a as well, so a mac80211 driver for rtl8192su would have
to discard all the mgmt frames from mac80211?!)   

> As r8712u functions quite well in station mode, I have not felt inclined to 
> rework it for AP mode, particularly when a user can obtain a functioning
> router/AP for about > $30. I feel that my time is better spent converting
> the drivers for Realtek devices that are not currently in the kernel. That
> list includes the rtl8723ae driver in 3.8, the rtl8188ee driver that will
> be in 3.10, and 3 other drivers that I currently have on my todo list.
Very true! (Is the RTL8812AU (Realtek's 11ac chip) also on the list?)

Regards,
	Christian
