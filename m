Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46234 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbZEZR06 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 13:26:58 -0400
Subject: Re: iwl3945 losing association after resume from suspend
From: Dan Williams <dcbw@redhat.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200905262051.42896.arvidjaar@mail.ru>
References: <200905262051.42896.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Tue, 26 May 2009 13:26:27 -0400
Message-Id: <1243358787.8063.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 20:51 +0400, Andrey Borzenkov wrote:
> I am running 2.6.29.3. After resume from STR (assuming that long enough 
> time has passed) connectivity is lost. There is no messages in log. Just 
> running "wpa_cli reassociate" "fixes" it.
> 
> Is there any way driver can declare existing connection as "stale" and 
> tell wpa_supplicant to reassociate?

Send a disassociate event on resume if a few seconds have passed.  But
in reality, this is usually done in userspace via pm-utils
suspend/resume scripts or some other mechanism based on the kernel's
uevents.  It's not something that kernel drivers report back to
userspace, because that suspend/resume event is handled by the kernel in
a non-driver-specific fashion.  You could use pm-utils scripts to
trigger the reassociation if you like, which is where most of the
userspace suspend/resume handling stuff lives these days.

Dan


