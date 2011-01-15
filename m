Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34251 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1AOBlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 20:41:19 -0500
Received: by iyj18 with SMTP id 18so3031389iyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 17:41:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D309086.7070703@openwrt.org>
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
	<4D309086.7070703@openwrt.org>
Date: Sat, 15 Jan 2011 02:41:17 +0100
Message-ID: <AANLkTimAxXKiM_wBToLXfBxfwF1xbi+KZVHTQE-6fc0i@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC 1/2] ath9k: Fix up hardware mode and beacons
 with multiple vifs.
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 14, 2011 at 7:05 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Do we really need all those counters? Wouldn't it be better to iterate over
> active interfaces instead?

I think iterating over active interfaces is better, especially if we
set up more fine-graned ah-> variables that make sense in themselves
for stuff like power save and tsf sync. But that's just my two cents.

As an example of something that may be more or less impossible to do
without iteration consider multiple vifs with different beacon
intervals. This could be handled by computing a greatest common
devisor of all beacon intervals and using this for SWBA.

/Björn
