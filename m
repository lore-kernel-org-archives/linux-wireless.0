Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([66.92.66.146]:33973 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab2KBWXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2012 18:23:03 -0400
From: Tim Shepard <shep@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Daniel Drake <dsd@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH] mwifiex: add support for SDIO card reset 
In-reply-to: Your message of Thu, 01 Nov 2012 18:44:14 -0700.
             <1351820654-24433-1-git-send-email-bzhao@marvell.com>
Date: Fri, 02 Nov 2012 17:46:34 -0400
Message-Id: <E1TUP4U-0002Fm-00@www.xplot.org> (sfid-20121102_232315_915983_5103E512)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Bing,

I am trying to figure out if this patch would help in the situation I
told you about in September.

I was doing suspend/resume testing using

  rtcwake -s 6 -mmem

in a loop to test the ability of the mwifiex driver to suspend/resume.

I was seeing sporadic failures (wedgeups), and the majority of those
failures I saw printed the printouts in mwifiex_cmd_timeout_func with
cmd = 0xe5 which is CMD_802_11_HS_CFG_ENH.  When this happens, two
minutes later I get notified that the rtcwake thread is blocked, like
this:

      INFO: task rtcwake:3495 blocked for more than 120 seconds.



I believe the hang happens when mwifiex_sdio_suspend() is called in
the rtcwake thread it winds winds up blocked waiting on a wait queue
in mwifiex_enable_hs() because when the timeout happens it never gets
woken up.

Reading your patch today, I don't see how your patch will add a new
way to get that hung thread unblocked.  

(I'm also not sure doing the reset of the card will work properly while
 the system is in the middle of trying to suspend, but that's a
 different question.)

If I'm missing a clue about this, please let me know.


			-Tim Shepard
			 shep@laptop.org
