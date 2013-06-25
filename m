Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab3FYOW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 10:22:56 -0400
Date: Tue, 25 Jun 2013 16:25:17 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving features for iwl4965
Message-ID: <20130625142514.GA1938@redhat.com> (sfid-20130625_162301_095909_BC979658)
References: <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
 <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com>
 <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
 <20130611161924.GB1696@redhat.com>
 <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
 <20130614131829.GA5125@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
In-Reply-To: <20130614131829.GA5125@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 14, 2013 at 03:18:29PM +0200, Stanislaw Gruszka wrote:
> > >> I also got a SYSASSERT:
> > >> (...)
> > >>
> > >> I disabled powersave (but kept running the same kernel) and none of
> > >> the errors appeared again.
> > >
> > > Yes, this seems to be iwlegacy PS issue and has to be fixed before
> > > this patch could be applied.
> > 
> > But is it a driver-only issue? I had assumed it was some sort of
> > fireware+driver issue...
> Looks like driver issue or firmware issue that can be workaround in 
> the driver.
> 
> > Will running with debug on help? Or is it easily reproducible on any
> > iwl3945 / iwl4465 ?
> > 
> > Because in my case (iwl3945) it happens after boot, no prior suspend
> > to RAM is required to trigger the issues.
> I can reproduce microcode error on iwl4965 by reloading modules. Looks
> like we put device in sleep mode and it can not be properly booted when
> driver initalize. I did not yet test patch on iwl3945. When I'll do
> this, I think I'll be able to reproduce problems you discovered. If not
> I'll ask for more debug info.

I found problem on 4965, we have to send power configuration command to
device earlier, before some other commands. Attached patch solved
microcode errors I have on 4965.

Regarding iwl3945. Display on my 3945 laptop no longer works. I took
3945 device from that laptop and installed it on two different machines.
Unfortunately on none of them device was detected by pci system :-/
I have figure out how to get working 3945 testing environment, but for
now, perhaps you could provide me some more debug information.

Pedro, please do the fallowing:

Add this line in /etc/rsyslog.conf: 
kern.*                                                  /var/log/kernel

Restart rsyslog services:
# systemctl restart rsyslog.service

Restart iwl3945 module with verbose debug enabled:
modprobe -r iwl3945
modprobe iwl3945 debug=0x47ffffff

Reproduce the problem.

Unload module:
modprobe -r iwl3945

Then provide me generated /var/log/kernel file (compressed if needed).

Thanks
Stanislaw


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwl4965-update-power-mode-early.patch"

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index d287fd2..e7821f6 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5334,6 +5334,9 @@ il4965_alive_start(struct il_priv *il)
 
 	il->active_rate = RATES_MASK;
 
+	il_power_update_mode(il, true);
+	D_INFO("Updated power mode\n");
+
 	if (il_is_associated(il)) {
 		struct il_rxon_cmd *active_rxon =
 		    (struct il_rxon_cmd *)&il->active;
@@ -5364,9 +5367,6 @@ il4965_alive_start(struct il_priv *il)
 	D_INFO("ALIVE processing complete.\n");
 	wake_up(&il->wait_command_queue);
 
-	il_power_update_mode(il, true);
-	D_INFO("Updated power mode\n");
-
 	return;
 
 restart:

--LZvS9be/3tNcYl/X--
