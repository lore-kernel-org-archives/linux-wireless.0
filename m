Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:48427 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbZH0CC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 22:02:58 -0400
Received: by pxi4 with SMTP id 4so713297pxi.21
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 19:03:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A95C128.5000405@gmail.com>
References: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net>
	 <4A94B01E.9040309@gmail.com> <4A94C3E9.6070409@lwfinger.net>
	 <4A95AA64.20502@gmail.com>
	 <3ace41890908261538s6818b56ax56cca5af18398dbc@mail.gmail.com>
	 <4A95C128.5000405@gmail.com>
Date: Wed, 26 Aug 2009 19:03:00 -0700
Message-ID: <45e8e6c40908261903r1e495ee6tb69277d99aa83e2b@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
	enabled
From: Andrey Yurovsky <andrey@cozybit.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Richard,

On Wed, Aug 26, 2009 at 4:11 PM, Richard Farina<sidhayn@gmail.com> wrote:
> Again, I'm not trying to point my finger blaming someone, I'm trying to help
> fix a problem.  I am traveling for the next few days, when I get home to my
> camera I hope you are all calm enough to help me troubleshoot this bug so we
> can find a solution instead of accusing each other of accusing each other.

you may want to try kexec in place of having to take photos of the
kernel panic output.  This will enable you to load a crash-recovery
kernel, which will be booted automatically once you've successfully
reproduced the problem.  From there you can use gdb together with
/proc/vmcore and your kernel image to reconstruct what you'd see in
dmesg and paste the entire oops.  Please see
Documentation/kdump/kdump.txt for more details and use
Documentation/kdump/gdbmacros.txt to give gdb a "dmesg" macro.

  -Andrey
