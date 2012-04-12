Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54900 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab2DLGP1 (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Thu, 12 Apr 2012 02:15:27 -0400
Received: by bkcik5 with SMTP id ik5so1226116bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 23:15:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 Apr 2012 14:15:04 +0800
Message-ID: <CALx5=V_5XzAqddWRGzS4d-9MoHLV=abN2DOA-X7EtQ+78DBdzg@mail.gmail.com> (sfid-20120412_081533_107871_65FBA849)
Subject: About rfkill racing issue.
From: Matt Chen <machen@suse.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: users@rt2x00.serialmonkey.com, ath9k-devel@lists.ath9k.org,
	Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,
It is found by notebook that rfkill doesn't work very right. I don't
know where to post this discussion, so I choose here to start the
talk.
Basically we found the input handler in net/rfkill/input.c , because
the nature of stateless key events, it can only toggle the saved
state.  This screws up when started as blocked at
boot, as already suspected.
Now we thought Synchronizing to the
hard block state looks as if working, but it's also dangerous because
the operation is racy. The hard block check on ath9k driver is done
in a poll basis, for example. Thus, the polling might happen just
before the key event is handled, and it might happen after the key
event.
Another option would be to get synchronize the soft block state at the
driver initialization time.  But, this doesn't work always because we
never know whether ther rfkill key event is generated.  The rfkill key
event depends on BIOS. Thus, if we set the soft block as same as the
hard block at the init time (and set as blocked), the soft block will
be never unblocked if some BIOS version doesn't emit a key event.

So we would like to discuss with the all experts here for this issue.
Do you have a good idea to fix the rfkill for the issue ?

Thanks for all your advice. :)

-- 
Thank you.
