Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53435 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaFGSQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 14:16:12 -0400
Received: by mail-ob0-f181.google.com with SMTP id wm4so4213332obc.40
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2014 11:16:11 -0700 (PDT)
Message-ID: <539356EA.1070004@lwfinger.net> (sfid-20140607_201616_573975_A980FFEB)
Date: Sat, 07 Jun 2014 13:16:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Powerful Notageek <powerfulnotageek@yahoo.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: MT7630e availability in kernel by default
References: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com> <53935133.5020303@lwfinger.net> <1402163980.67578.YahooMailNeo@web193003.mail.sg3.yahoo.com>
In-Reply-To: <1402163980.67578.YahooMailNeo@web193003.mail.sg3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2014 12:59 PM, Powerful Notageek wrote:
> Here's lspci -nn
>
> 03:00.0 Network controller [0280]: MEDIATEK Corp. MT7630e 802.11bgn Wireless Network Adapter [14c3:7630]
>
> I have tried using the drivers available on RALink/Mediatek on a pretty recent kernel of Fedora20, didn't seem to work.
>
> Thanks

That PCI ID is not in the latest Ralink driver, which is essentially what will 
be in kernel 3.16.

Please try the following:

su -
modprobe -v rt2800pci
echo "14c3 7630" > /sys/bus/pci/drivers/rt2800pci/new_id

Does that yield a wireless lan device?

Larry


