Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36395 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752476AbcKUJeG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 04:34:06 -0500
Received: by mail-pg0-f48.google.com with SMTP id f188so128492536pgc.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 01:34:06 -0800 (PST)
Subject: Re: BCM4356 + Ubuntu 16.10
To: Familie Stepniak <stepniak@outlook.de>
References: <AM3PR06MB1043FFF175E7DB0D4DB510D9A3B20@AM3PR06MB1043.eurprd06.prod.outlook.com>
Cc: "mailto:brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ba8a4059-9eb9-de08-b492-9e60b80db0ac@broadcom.com> (sfid-20161121_103410_114297_6C5EC2EA)
Date: Mon, 21 Nov 2016 10:34:01 +0100
MIME-Version: 1.0
In-Reply-To: <AM3PR06MB1043FFF175E7DB0D4DB510D9A3B20@AM3PR06MB1043.eurprd06.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

On 20-11-2016 14:26, Familie Stepniak wrote:
> Hi,
> 
> I try run Ubuntu 16.10 on the Trekstor W2 Tablet but Wi-Fi donts work..
> that find WLAN-Network, I give to Passwort and Nothing.. the chip ist
>  BCM4356B.. please Help me to install the true Driver on the Linux-Ubuntu..

Not sure what "true Driver" means, but let me see if I can help. First
see if I understand your issue. So you were able to select to WLAN
network and got a pop-up to provide the password. After that you are not
getting a connection. Is this right?

So is this a first attempt to run Ubuntu on it or have you been able to
run older version.

Can you do the following:
- open a terminal.
- run following commands (assuming wlan0):
$ iw dev
$ iw list
$ lspci
$ sudo nmcli nm wifi off
$ sudo rfkill unblock wifi
$ sudo ifconfig wlan0 up
$ sudo iw wlan0 scan
$ dmesg
- send me output of all these commands.

Regards,
Arend
