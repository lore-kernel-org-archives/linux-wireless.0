Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364AbXITPy5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 11:54:57 -0400
Subject: Re: wext 64-bit: network manager and wpa_supplicant
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jean Tourrilhes <jt@hpl.hp.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1190292526.18521.52.camel@johannes.berg>
References: <1190292526.18521.52.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 11:50:33 -0400
Message-Id: <1190303433.2016.10.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-09-20 at 14:48 +0200, Johannes Berg wrote:
> Ahrg. So I was complaining about NM not displaying any networks when
> that umlaut-network I talked about earlier was present. But all that was
> just wrong, the real problem seems to be that NM doesn't work on 64-bit
> platforms. Is there any fix for it? It really should be going into a
> 0.6.5.1 version or something so distributions will ship it.

You mean it doesn't work correctly when handling ioctls on 64-bit
platforms?  Or is just plain broken in non-ioctl ways?

Dan

> Same seems to go for wpa_supplicant, Debian is shipping 0.6.0 which only
> triggers this in the kernel log:
> 
> [  787.877417] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58418) on socket:[14569]
> [  787.877763] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58418) on socket:[14569]
> [  787.877817] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58418) on socket:[14569]
> [  795.264145] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58458) on socket:[14569]
> [  795.264243] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58458) on socket:[14569]
> [  795.264291] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58458) on socket:[14569]
> 
> And even the wpa_supplicant git version still seems to parse everything
> itself without any 64-bit workarounds as far as I can tell. I keep
> building wpa_supplicant for 64-bit just to test... Any chance to finally
> get fixes into the stable versions distros are shipping?
> 
> Thanks,
> johannes

