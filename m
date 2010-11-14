Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33308 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab0KNQS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 11:18:58 -0500
Received: by gxk23 with SMTP id 23so2593244gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 08:18:57 -0800 (PST)
Message-ID: <4CE00BEE.8060100@lwfinger.net>
Date: Sun, 14 Nov 2010 10:18:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: James Womack <james.c.womack@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8187se panic
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org> <4CDEDC74.3040902@lwfinger.net> <ibmosc$4au$1@dough.gmane.org> <4CDEEEE4.80801@lwfinger.net> <ibokag$481$1@dough.gmane.org>
In-Reply-To: <ibokag$481$1@dough.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/14/2010 06:22 AM, James Womack wrote:
> Okay, I've downloaded the necessary tools and extracted the kernel
> source. I have a tutorial on how to patch and build the kernel. Where
> should I apply your patches?

Change directory to the main directory of the kernel source - the one with
subdirectories like arch, block, crypto, drivers, etc. Apply patches with a
command of the form

patch -p1 --dry-run < <nameofpatch>

If that works without any error, then leave out the "--dry-run" to apply the
patch. If/when it is necessary to remove the patch, adding a "-R" option will do
that.

When you build the kernel, you should do that as a normal user, not root. If the
source files are not owned by that user, you should do a chown on that tree
before starting.

Larry
