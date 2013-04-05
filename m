Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39581 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161930Ab3DEQPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 12:15:14 -0400
Message-ID: <515EF88F.1030606@openwrt.org> (sfid-20130405_181519_333203_817F1045)
Date: Fri, 05 Apr 2013 18:15:11 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Harshal Chhaya <harshal@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: AR9342: Two odd packets in every beacon interval in 5Ghz
References: <CAJ8GFOjheLNiawD7K-VnGa5ishbnr6rm0YHUvJs8XgZK1EaJtQ@mail.gmail.com>
In-Reply-To: <CAJ8GFOjheLNiawD7K-VnGa5ishbnr6rm0YHUvJs8XgZK1EaJtQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-05 5:24 PM, Harshal Chhaya wrote:
> Hello,
> 
> We have an AR9342-based AP that is sending out two odd packets each
> beacon interval. These packets are 1804 bytes in size, are transmitted
> at 6.5Mbps and have the dest MAC address the same as the source MAC
> address.
> 
> The payload of these packets is all zeros.
> 
> It does this only in 5Ghz. These packets aren't transmitted in the 2.4Ghz band.
> 
> If we set the bandwidth to 40MHz, it sends only one of these packets
> between beacons.
> 
> Are these some control or mgmt packets that are part of the protocol?
> Or is this unexpected behavior?
> 
> The AP is running the 3.3.8 kernel and a compat-wireless from Sep 2012
> (part of the openwrt image for this chip).
Maybe it's (failing) PA predistortion calibration, which needs to send
training frames to complete.
I'd suggest trying a newer compat-wireless version, this type of
calibration has been disabled there because of various issues (including
hardware damage on some chips).

- Felix

