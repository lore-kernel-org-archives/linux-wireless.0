Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52089 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab0KVWDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 17:03:30 -0500
Date: Mon, 22 Nov 2010 23:03:22 +0100
From: Johan Hedberg <johan.hedberg@gmail.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2010-11-22
Message-ID: <20101122220322.GA15543@jh-x301>
References: <20101122181411.GD23109@vigoh>
 <20101122193029.GE2117@tuxdriver.com>
 <20101122201330.GE23109@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101122201330.GE23109@vigoh>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Nov 22, 2010, Gustavo F. Padovan wrote:
> > The other fixes are larger than I would like to see.  What is the
> > effect of the bug?  Does the Bluetooth controller stop completely?
> > Does it cause a crash?
> > 
> > Is this a newly-introduced bug?  Or one that has been around for
> > a while?
> 
> No, it is not serious like that. By not having this patch we won't have
> the remote name request command during connection setup, The remote name
> request was done by bluetoothd, but we already removed it from
> userspace. It is not a really big problem once we also cache the remote
> devices names in bluetoothd.
> So I'm seeing no way to convince you tou pull this patch (actually I'm
> now also covinced to queue this to bluetooth-next).  I'll sent a new
> pull request soon, after wait some time for new patches.

IIRC the symptom that prompted the initial investigation was the failure
to properly connect to one specific Bluetooth headset. After discussions
with Marcel the conculsion was to move more control of these commands to
the kernel side. OTOH, this is certainly not the first time a BT
controller chokes up when receiving too many commands at the same time
(I've seen this several times during the last 8 years or so that I've
been involved with Bluetooth). Anyway, I agree that this might be better
suited for bluetooth-next.

Johan
