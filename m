Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53830 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2ITMPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 08:15:23 -0400
Received: by bkuw11 with SMTP id w11so171886bku.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 05:15:21 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sabrina Schulte <sabrina.schulte@rwth-aachen.de>
Subject: Re: decision for an access point
Date: Thu, 20 Sep 2012 14:15:16 +0200
Cc: linux-wireless@vger.kernel.org
References: <505B03D7.2050300@rwth-aachen.de>
In-Reply-To: <505B03D7.2050300@rwth-aachen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201209201415.17078.chunkeey@googlemail.com> (sfid-20120920_141531_526653_09DE92F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 September 2012 13:53:59 Sabrina Schulte wrote:
> I do not know if this is the right mailing list to ask. I am tying to 
> modify the association process in a carl9170 driver. I am looking for 
> the place, where the decision for a certain access point is done. Does 
> anyone know, where this decision or the sorting of a list of access 
> points is done?
The decision is made by userspace (the driver is not involved).
In almost all cases this will be done by some sort of 
"wpa_supplicant" (either directly, or through networkmanager, wicd, ...).

In wpa_supplicant itself, the network is usually picked from a 
priority list (see function "wpa_supplicant_pick_network" in
wpa_supplicant/events.c)

Regards,
	Chr
