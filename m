Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39026 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbYJQMGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 08:06:19 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kqo5u-0005Xt-QN
	for linux-wireless@vger.kernel.org; Fri, 17 Oct 2008 12:06:14 +0000
Received: from artipc9.vub.ac.be ([134.184.26.59])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 12:06:14 +0000
Received: from fhimpe by artipc9.vub.ac.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 12:06:14 +0000
To: linux-wireless@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: iwlagn: associating with AP causes kernel hiccup
Date: Fri, 17 Oct 2008 12:06:08 +0000 (UTC)
Message-ID: <gd9v3f$3ft$1@ger.gmane.org> (sfid-20081017_140623_309802_E3A72D17)
References: <gd5gs4$abi$1@ger.gmane.org> <1224104363.19219.30.camel@rc-desk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 15 Oct 2008 13:59:23 -0700, reinette chatre wrote:

> On Wed, 2008-10-15 at 19:38 +0000, Frederik Himpe wrote:
>> When I associate with an AP, Linux 2.6.27 seems to "hang" for a few
>> seconds. During that time, all sound stops playing and keyboard and
>> mouse input is impossible. In the log I see this:
>> 
>> wlan0: authenticate with AP 00:15:f2:0a:ab:43 wlan0: authenticate with
>> AP 00:15:f2:0a:ab:43 wlan0: authenticate with AP 00:15:f2:0a:ab:43
>> wlan0: authenticated
>> wlan0: associate with AP 00:15:f2:0a:ab:43 wlan0: RX AssocResp from
>> 00:15:f2:0a:ab:43 (capab=0x431 status=0 aid=2) wlan0: associated
>> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready iwlagn 0000:0c:00.0:
>> PCI INT A disabled iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level,
>> low) -> IRQ 17 iwlagn 0000:0c:00.0: restoring config space at offset
>> 0x1 (was 0x100102, writing 0x100106)
> 
> Are you running wpa_supplicant and/or network manager?

I'm using Mandriva 2009.0 x86_64 with wpa_supplicant and Mandriva's 
wireless network configuration tool (drakroam).

> Can you try testing without them?

Actually I just found out that running
# ifconfig wlan0 down
is enough to trigger the sound and mouse hanging for a few seconds.

This is what appears in the kernel logs when running that command:

Oct 17 14:04:51 defected kernel: iwlagn 0000:0c:00.0: PCI INT A disabled
Oct 17 14:04:52 defected kernel: iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 
(level, low) -> IRQ 17
Oct 17 14:04:52 defected kernel: iwlagn 0000:0c:00.0: restoring config 
space at offset 0x1 (was 0x100102, writing 0x100106)
Oct 17 14:04:52 defected kernel: Registered led device: iwl-phy0:radio
Oct 17 14:04:52 defected kernel: Registered led device: iwl-phy0:assoc
Oct 17 14:04:52 defected kernel: Registered led device: iwl-phy0:RX
Oct 17 14:04:52 defected kernel: Registered led device: iwl-phy0:TX
Oct 17 14:04:52 defected kernel: ADDRCONF(NETDEV_UP): wlan0: link is not 
ready

-- 
Frederik Himpe


