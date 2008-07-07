Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:9078 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbYGGS4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 14:56:54 -0400
Received: by yx-out-2324.google.com with SMTP id 8so487568yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 11:56:53 -0700 (PDT)
Message-ID: <cb0375e10807071156x26df8332j4b167e8cc9bb289@mail.gmail.com> (sfid-20080707_205658_933630_387D553F)
Date: Mon, 7 Jul 2008 14:56:53 -0400
From: "Andrew Lutomirski" <andy@luto.us>
To: linux-wireless@vger.kernel.org
Subject: [BUG] iwl4965: huge latency and errors when unblocking the hardware rfkill
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is wireless-testing c80200cd38c265da90f0d9d031ace84aa56b0453, pulled today.

I have a Lenovo X61s with a physical rfkill switch (the kind that
slides between blocked and unblocked).

If I turn off the hardware rfkill switch (set to block) while
associated, I lose the connection (obviously).  If I turn it back on
again (set to unblock), I get a lot of latency (my mouse stops moving
for a second or two) and I sometimes get errors in the syslog like
this:

iwl4965: Error sending REPLY_CT_KILL_CONFIG_CMD: time out after 500ms.

The card fails to associate afterwards.  If I tell network-manager to
turn off wireless, then block rfkill, then wait a few seconds, then
unblock it, then turn nm back on, everything works again.

This seems like at least two different bugs:

 - iwl4965 causes latency.  This latency issue has been reproducible
every time for me on 2.6.24-ubuntu_something, 2.5.25, wireless-compat
(recent), and current wireless-testing.
 - iwl4965 doesn't work right after hard unblocking rfkill.

I'm happy to do further troubleshooting and/or test patches.

--Andy
