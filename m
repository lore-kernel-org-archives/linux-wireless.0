Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:22912 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0JPB7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 21:59:41 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id o9G1xYev002191
	for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 18:59:36 -0700
Received: from iwn9 (iwn9.prod.google.com [10.241.68.73])
	by wpaz21.hot.corp.google.com with ESMTP id o9G1xWAl003156
	for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 18:59:33 -0700
Received: by iwn9 with SMTP id 9so735178iwn.38
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 18:59:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010160036.17653.rjw@sisk.pl>
References: <201010160036.17653.rjw@sisk.pl>
Date: Fri, 15 Oct 2010 18:28:42 -0700
Message-ID: <AANLkTimXXERRCYEjzQbcii6XW8wbjNfN-eWigU7Wi_Lv@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Convert to new PCI PM framework
From: Paul Stewart <pstew@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 15, 2010 at 3:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The ath9k driver uses the legacy PCI power management (suspend
> and resume) callbacks that apparently cause intermittent problems
> to happen (the adapter sometimes doesn't resume correctly on my
> Acer Ferrari One).  Make it use the new PCI PM and let the PCI core
> code handle the PCI-specific details of power transitions.
I'm curious.  What sort of behavior did you get when the device fails
to resume correctly?  Every now and then I've been getting bad
accesses to 0x7000 every now and then -- after that any reads to PCI
registers return all f's.

--
Paul
