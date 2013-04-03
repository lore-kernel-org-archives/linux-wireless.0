Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1522 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763254Ab3DCJ11 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 05:27:27 -0400
Message-ID: <515BF5ED.1090100@broadcom.com> (sfid-20130403_112741_043020_44633AD9)
Date: Wed, 3 Apr 2013 11:27:09 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH for-3.9] brcmsmac: request firmware in .start()
 callback
References: <1364978488-5295-1-git-send-email-arend@broadcom.com> (
 sfid-20130403_104155_072423_E8AF0F80)
 <1364979327.8351.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364979327.8351.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2013 10:55 AM, Johannes Berg wrote:
> On Wed, 2013-04-03 at 10:41 +0200, Arend van Spriel wrote:
>> The firmware is requested from user-space. To assure the request
>> can be handled it is recommended to do the request upon IFF_UP.
>> For a mac80211 driver the .start() callback can be considered
>> the equivalent.
> 
> FWIW, many drivers now don't do it on IFF_UP/start any more but do
> request_firmware_nowait() in probe and only finish probing and
> registering with mac80211 when they have the firmware file. This is
> necessary if you have any device/driver capabilities that depend on the
> firmware that need to be known before registering with mac80211.

Thanks, Johannes

I do recall looking into async firmware request API a while ago. Right
now we do not need it for brcmsmac, but we may need to move to that when
support for more devices comes in.

Gr. AvS


