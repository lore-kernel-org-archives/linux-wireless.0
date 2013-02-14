Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:36201 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab3BNTyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 14:54:01 -0500
Received: by mail-bk0-f50.google.com with SMTP id jg9so1232293bkc.23
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 11:54:00 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Beat Meier <mbe_ml@swiss-wireless.com.ar>
Subject: Re: How can I find out the ssid of an inteface in AP mode?
Date: Thu, 14 Feb 2013 20:53:57 +0100
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
References: <511D3AA4.7000209@swiss-wireless.com.ar>
In-Reply-To: <511D3AA4.7000209@swiss-wireless.com.ar>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302142053.57519.chunkeey@googlemail.com> (sfid-20130214_205406_357154_F1A802A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, February 14, 2013 08:27:32 PM Beat Meier wrote:
> Hello
> 
> How can I find out the ssid of an inteface in AP mode (using hostapd)?
start up hostapd_cli 

(usually it connects to the right wlanX interface, otherwise
execute interface wlanX)

get_config

(And then look for ssid=xyz)

> I have several hostapd files and dependend on several stuff I start 
> hostap with different config files. One difference is the ssid and
> at runtime I need to know which is active  with some scripts.
>
> I have still not found how to get this information if the interface is 
> in AP mode because
>    iw dev wlan0 link
> does not work in AP mode...
> In my opinion this could be implemented in
>    iw dev wlan0 survey dump
> which also prints the frecuency IF REALY not already implemented...
> 
> No one does need this feature?
No, the kernel does not manage AP interfaces. Everything 
is done by hostapd (the userspace daemon).

Regards,
	Christian 
