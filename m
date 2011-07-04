Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21746 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1GDJxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 05:53:43 -0400
Date: Mon, 4 Jul 2011 15:23:42 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Forest Bond <forest@alittletooquiet.net>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless
 3.0-rc4-1
Message-ID: <20110704095341.GA1380@vmraj-lnx.users.atheros.com> (sfid-20110704_115347_609250_0AE3522E)
References: <20110701133553.GA7125@alittletooquiet.net>
 <BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com>
 <BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
 <20110701173237.GC7125@alittletooquiet.net>
 <20110704052410.GA1364@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <20110704052410.GA1364@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 04, 2011 at 10:54:11AM +0530, Rajkumar Manoharan wrote:
> On Fri, Jul 01, 2011 at 01:32:37PM -0400, Forest Bond wrote:
> > Hi shafi,
> > 
> > [Sorry for the duplicate, lost the Cc's the first time around.]
> > 
> > On Fri, Jul 01, 2011 at 07:39:40PM +0530, Mohammed Shafi wrote:
> > > On Fri, Jul 1, 2011 at 7:31 PM, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> > > > On Fri, Jul 1, 2011 at 7:05 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> > > >> Now the module loads fine and appears to load the firmware correctly, but the
> > > >> interface never comes up.  Here's what happens when I insert the device:
> > > >>
> > > >> [  206.657723] Compat-wireless backport release: compat-wireless-v3.0-rc4-1
> > > >> [  206.657732] Backport based on linux-2.6-allstable.git v3.0-rc4
> > > >> [  206.864667] Calling CRDA to update world regulatory domain
> > > >> [  207.714633] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 51288
> > > >> [  207.861037] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 credits
> > > >>
> > > >> At this point the interface is not visible in the output of ifconfig.  Something
> > > >> has gone wrong with USB, because lsusb hangs until I unplug the device, at which
> > > >> point I see the following in dmesg:
> > > >>
> > > >> [  225.464212] usb 5-7: USB disconnect, address 5
> > > >> [  225.592282] ath: Reading Magic # failed
> > > >> [  225.592310] ath: no band has been marked as supported in EEPROM
> > > >> [  225.592315] ath: Unable to initialize hardware; initialization status: -22
> > > >> [  225.592321] ath: Unable to initialize hardware; initialization status: -22
> > > >> [  225.592336] Failed to initialize the device
> > > >> [  225.592400] ath9k_htc: probe of 5-7:1.0 failed with error -22
> > > >> [  225.712249] usbcore: registered new interface driver ath9k_htc
> > > >
> > > > something wrong in reading EEPROM, please post the kernel log for
> > > > sudo modprobe ath9k_htc debug debug=0x404
> > > 
> > > please do
> > > sudo modprobe ath9k_htc debug=0xffffffff
> > > this will give lots of information
> > 
> > [   98.421395] Compat-wireless backport release: compat-wireless-v3.0-rc4-1
> > [   98.421405] Backport based on linux-2.6-allstable.git v3.0-rc4
> > [   98.638709] Calling CRDA to update world regulatory domain
> > [   99.219353] usbcore: registered new interface driver ath9k_htc
> > [  103.829197] usb 5-7: new high speed USB device using ehci_hcd and address 5
> > [  103.985215] usb 5-7: configuration #1 chosen from 1 choice
> > [  104.288053] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 51288
> > [  104.448323] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 credits
> > [  104.453395] ath: UNDEFINED -> AWAKE
> > [  104.454654] ath: serialize_regmode is 0
> > [  104.686218] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
> > [  104.686240] ath: REGISTER WRITE FAILED, multi len: 9
> > [  104.901237] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> > [  104.901259] ath: REGISTER READ FAILED: (0x9c00, -110)
> > [  104.901276] ath: Reading from EEPROM, not flash
> > [  105.911084] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> Please share your PID/VID.
>
Forest,

And also for compat-wireless-v3.0-rc4-1, FW version should be 1.3 and fw size
should be 51272. But in your case size is 51288 which is 1.2. Please upgrade fw
to 1.3 and test again.

http://wireless.kernel.org/download/htc_fw/1.3/htc_9271.fw

--
Rajkumar
