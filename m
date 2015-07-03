Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out21.sjc.mx.trendmicro.com ([216.99.131.78]:53453 "EHLO
	out21.sjc.mx.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677AbbGCKRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 06:17:07 -0400
Received: from out02.sjc.mx.trendmicro.com (unknown [216.99.131.6])
	by out21.sjc.mx.trendmicro.com (Postfix) with ESMTP id 415EEAFFAFB
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2015 09:59:27 +0000 (UTC)
Received: from relay07.sjc.mx.trendmicro.com (unknown [10.30.239.78])
	by out02.sjc.mx.trendmicro.com (Postfix) with ESMTP id 72731980420
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2015 09:59:26 +0000 (UTC)
Received: from thinktube.com (unknown [111.68.225.247])
	by relay07.sjc.mx.trendmicro.com (Postfix) with ESMTP id D8FB498044C
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2015 09:59:25 +0000 (UTC)
Received: from unknown (HELO [192.168.5.9]) (br1@[188.85.29.34])
          (envelope-sender <br1@thinktube.com>)
          by 111.68.225.247 (qmail-ldap-1.03) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 3 Jul 2015 09:59:25 -0000
Message-ID: <55965CF8.20208@thinktube.com> (sfid-20150703_121712_533848_B713FE4D)
Date: Fri, 03 Jul 2015 10:59:20 +0100
From: Bruno Randolf <br1@thinktube.com>
MIME-Version: 1.0
To: Richard Palethorpe <richard@lm-technologies.com>,
	ap420073@gmail.com
CC: linux-wireless@vger.kernel.org
Subject: Re: mesh support on rtl8192cu
References: <CAFSTUk6UasnV4P3B1TR7kSx1ToQTC+PC2hU6PynDBWJ3ALJzyg@mail.gmail.com>
In-Reply-To: <CAFSTUk6UasnV4P3B1TR7kSx1ToQTC+PC2hU6PynDBWJ3ALJzyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2015 10:34 AM, Richard Palethorpe wrote:
> Hello Taehee,
> 
> I have been experimenting with MESH mode on kernel 4.0.7. It is
> sending beacons out, but is unable to establish a connection.
> 
> I have two rtl8192cu based dongles connected to identical VMs and am
> using the following commands to set up the mesh:
> 
> iw dev wls160u2 set type mesh
> ip addr add 192.168.2.1/24 broadcast 192.168.2.255 dev wls160u2
> ip link set wls160u2 up
> iw dev wls160u2 mesh join lmmesh
> 
> Running 'iw dev wls160u2 mpath dump' produces no results and there is
> nothing regarding mesh in dmesg. I can't find any other information on
> mesh with rtl8192cu other than the patch which you submitted.
> 
> I am wondering if it does work, but there is a step I am missing or if
> something is wrong with the code?

I don't know about this 'mesh' mode, but I have noted problems in ad-hoc
mode with this chipset and driver. The problem seems to be that ARP
replies are not sent on the air... Not sure what the reason is or if
it's possible to fix it in the driver, but my conclusion for now is that
this device is unusable for ad-hoc mode. Similar problems may exist for
mesh?

bruno

