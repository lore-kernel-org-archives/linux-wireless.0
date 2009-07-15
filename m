Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:35774 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZGOVvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 17:51:33 -0400
Received: by gxk9 with SMTP id 9so2735591gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 14:51:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A5E377E.6090705@redfish-solutions.com>
References: <4A5E377E.6090705@redfish-solutions.com>
Date: Wed, 15 Jul 2009 17:51:31 -0400
Message-ID: <b6c5339f0907151451r2ae9e3bcvcafd921b300fb040@mail.gmail.com>
Subject: Re: Build instructions for cross-compilation environment
From: Bob Copeland <me@bobcopeland.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@winlab.rutgers.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 4:09 PM, Philip A.
Prindeville<philipp_subx@redfish-solutions.com> wrote:
> Also, a list of what CONFIG_xxx symbols I need to turn off to ensure
> that there is no "residue" left over from the kernel build to interfere
> with the compat-wireless build would be helpful (or alternatively,
> what's the bare essential list of CONFIG_xxx symbols that need to be
> enabled to "hook" compat-wireless into an existing kernel).

At least CONFIG_{CFG80211,MAC80211}=m but you'll likely need to experiment.

> Looking at the Makefiles, it doesn't seem that cross-compilation is
> ready out-of-the-box:

Perhaps it isn't for the installation stuff, but I've had no problems
building the modules with a cross compiler.  And you said you wanted to
customize installation anyway (just copy the built modules under 'kernel'
if that's what you want.  It doesn't matter where they live as long as
depmod finds them;'updates' is nice for rollback, however.)

Here's my dumb cross compilation script, make-arm.sh:

#!/bin/bash

DIR=/home/bob/ext/linux-2.6
XGCC=/home/bob/projects/xgcc
export PATH="$XGCC/arm-2008q3/bin/:$PATH"
make ARCH=arm CROSS_COMPILE=arm-none-eabi- KLIB=$DIR KLIB_BUILD=$DIR "$@"

> Please reply to me directly (or even on Cc).  I tried to join the list a
> couple of weeks ago, but my request hasn't yet been processed.

Perhaps try again?  majordomo can be slow but two weeks slow sounds
off...

-- 
Bob Copeland %% www.bobcopeland.com
