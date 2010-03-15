Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:50034 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab0COLjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 07:39:21 -0400
Received: by ewy8 with SMTP id 8so1033882ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 04:39:19 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jan Martinek <honza@dp.fce.vutbr.cz>
Subject: Re: ISL3890, master mode, prism54 -> p54pci regression
Date: Mon, 15 Mar 2010 12:39:11 +0100
Cc: linux-wireless@vger.kernel.org
References: <4B9B43B0.1030801@dp.fce.vutbr.cz> <201003131126.57729.chunkeey@googlemail.com> <4B9DEAF9.4020002@dp.fce.vutbr.cz>
In-Reply-To: <4B9DEAF9.4020002@dp.fce.vutbr.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Message-Id: <201003151239.11473.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 March 2010 09:08:25 Jan Martinek wrote:
> Hello,

Hi,

> thank you very much to both of you for your answer. The reference to 
> hostapd really helped me and now everything works fine. I set WPA2 with 
> CCMP.
> 
> Well, there is one surprise. My computer, which serves as an Access 
> Point used to be very stable. But since yesterday evening, when I got 
> hostapd working the uptime is only several minutes, then it freezes.
> 
> It strongly depends on client's activity. Heavy internet traffic through 
> WiFi makes my computer freeze. For example, if client (windows machine) 
> connects to my WiFi network and watches some online video, it is a sure 
> way to freeze the Access Point in several seconds.
> 
> I did not find anything suspicious in dmesg nor /var/log/messages.
> 
> This is my card:
> 
> 03:06.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism 
> Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
> 
> It is Z-Com XG-901 (Full-MAC, I think).

_9_01. Interesting

> Does anyone else encountered freezing problems under heavy internet load?
Probably related to: http://bugzilla.kernel.org/show_bug.cgi?id=11386

You can either patch the kernel yourself, Or switch to compat-wireless
(which does also include fixes for mac80211-stack.) 

Regards,
	Chr
