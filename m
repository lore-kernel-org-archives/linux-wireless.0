Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44188 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab2CJWcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 17:32:09 -0500
Received: by dajr28 with SMTP id r28so3159100daj.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2012 14:32:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120310185649.GC1190@spacedout.fries.net>
References: <20120227031232.GA1190@spacedout.fries.net>
	<4F4B71F2.1020709@openwrt.org>
	<20120227144255.GB1190@spacedout.fries.net>
	<20120310185649.GC1190@spacedout.fries.net>
Date: Sat, 10 Mar 2012 14:32:08 -0800
Message-ID: <CAJ-Vmo=Uoi141mSnu68OxJ_FVgdSAt4ZO=GE=ODJg_XtZOns=Q@mail.gmail.com> (sfid-20120310_233213_163843_1CEE884B)
Subject: Re: ath5k phy0: gain calibration timeout
From: Adrian Chadd <adrian@freebsd.org>
To: David Fries <david@fries.net>
Cc: Felix Fietkau <nbd@openwrt.org>, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 March 2012 10:56, David Fries <david@fries.net> wrote:

>> > http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/440-ath5k_calibrate_no_queue_stop.patch;hb=HEAD
>> > http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/441-ath5k_no_agc_recalibration.patch;hb=HEAD
>
> No problems running with the above two patches after 12 days.  No
> calibration timeout messages either.  Thanks.

Sweet. I did do a bit of digging (and forgot to email the list) - yes,
those initial calibrations should only be done once, after a (full)
chip cold reset. They shouldn't be done periodically.


Adrian
