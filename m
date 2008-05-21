Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.187]:16183 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYEUTGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 15:06:14 -0400
Received: by gv-out-0910.google.com with SMTP id e6so879421gvc.37
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 12:06:08 -0700 (PDT)
Message-ID: <445f43ac0805211159u317bf720vd88d29a504445ba6@mail.gmail.com> (sfid-20080521_210619_004993_6A6CAA13)
Date: Wed, 21 May 2008 11:59:48 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile configuration.
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	carrano@laptop.org, dilinger@queued.net
In-Reply-To: <1211292718.21380.238.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
	 <1211292718.21380.238.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David,

On Tue, May 20, 2008 at 7:11 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sat, 2008-05-17 at 21:01 -0700, Javier Cardona wrote:
>> +     /* A too small boot time will result in the device booting into
>> +      * standalone (no-host) mode before the host can take control of it,
>> +      * so the change will be hard to revert.  This may be a desired
>> +      * feature (e.g to configure a very fast boot time for devices that
>> +      * will not be attached to a host), but dangerous.  So I'm enforcing a
>> +      * lower limit of 20 seconds:  remove and recompile the driver if this
>> +      * does not work for you.
>> +      */
>> +     datum = (datum < 20) ? 20 : datum;
>
> Hm. The driver should be able to cope with a device which is already
> booted -- it sends it a reset command and then initialises it. I don't
> think we have to be so paranoid, do we? If there's a lower limit on the
> boottime, it would be the time it takes for an already-active driver to
> react when the device resets. Which is much less than 20 seconds.

If the boottime is set smaller than the host boot time, the device
will transition into standalone mode before it is detected by the
host.  The only recovery when that happens is to either reset the
device via an external reset line or to re-insert it.  That lower
boundary was just intended to avoid support issues of users seeing
their devices disappear after a reboot.

Javier


-- 
Javier Cardona
cozybit Inc.
