Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43380 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbeDEMmH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 08:42:07 -0400
Message-ID: <1522932124.7140.14.camel@sipsolutions.net> (sfid-20180405_144211_001000_CBFE5CAC)
Subject: Re: Wi-Fi Disconnection on Suspend for no wowlan triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Steve deRosier <derosier@gmail.com>,
        Sunil Dutt Undekari <usdutt@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Amarnath Hullur Subramanyam <amarnath@qti.qualcomm.com>,
        Rajesh Chauhan <rajeshc@qti.qualcomm.com>
Date: Thu, 05 Apr 2018 14:42:04 +0200
In-Reply-To: <20180405112423.GA9248@jouni.qca.qualcomm.com>
References: <0663e93cc5ca45e6b7191760414b1189@aphydexm01f.ap.qualcomm.com>
         <CALLGbRJgAtOdZ1puzfgpWxc_ZrDVmWXtmFrBu=-gA0C++WrLoA@mail.gmail.com>
         <5AC5D33F.4090100@broadcom.com> <1522915172.7140.1.camel@sipsolutions.net>
         <5AC5D928.6020505@broadcom.com>
         <20180405112423.GA9248@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-04-05 at 11:24 +0000, Jouni Malinen wrote:
> 
> The "any" trigger sounds like a reasonable thing to use, 

It really depends what you're after. The "any" trigger means you want to
wake up on all kinds of things, basically everything that would normally
give you an interrupt in regular operation.

> so the question
> really is on what the default behavior should be if the driver has
> capability of doing this and there is no explicit configuration in user
> space. Currently, the default behavior seems to be to force
> disconnection. Would it make sense to allow drivers to indicate that
> they rather use "any" trigger by default? Or make that the default
> behavior is the driver supports "any"?

I don't think that makes sense, TBH. Imagine how dire that situation
would be if you were to have that on your laptop, e.g. with iwlwifi
which in certain configurations can support "any" - you'd basically
never be able to suspend your system properly unless you disconnected
from wifi first!

> For example, wpa_supplicant does not currently set any trigger
> configuration unless explicitly asked to do so. 

Which, again, I think is best really.

> This in combination with
> the kernel default (disconnect) does not seem to result in desired
> behavior in number of Android cases.

So yeah, I guess I could see how on *Android* in particular you'd want a
different configuration - but there are enough ways to configure that on
Android systems in particular, whether by changing the wpa_supplicant
configuration (if it can do this) or by using libwifihal or similar
mechanisms.

Basically, I don't think changing it would make sense for a general
purpose default configuration - it's always a special case that you do
want to wake up on all kinds of wifi things happening.

johannes
