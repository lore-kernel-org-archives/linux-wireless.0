Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63815 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1GFCjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 22:39:48 -0400
Date: Wed, 6 Jul 2011 08:09:44 +0530
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
Message-ID: <20110706023943.GA11178@vmraj-lnx.users.atheros.com> (sfid-20110706_043953_999153_0B60089B)
References: <BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com>
 <BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
 <20110701173237.GC7125@alittletooquiet.net>
 <20110704052410.GA1364@vmraj-lnx.users.atheros.com>
 <20110704095341.GA1380@vmraj-lnx.users.atheros.com>
 <20110705124914.GC26882@alittletooquiet.net>
 <CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
 <20110705143029.GA28091@alittletooquiet.net>
 <CAD2nsn1r7cW7KZ2W_z+SURHRpaTvuC_bd42yN9S+y9JrYMkS4w@mail.gmail.com>
 <20110705172022.GB28091@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <20110705172022.GB28091@alittletooquiet.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 05, 2011 at 01:20:22PM -0400, Forest Bond wrote:
> Hi,
> 
> On Tue, Jul 05, 2011 at 08:17:13PM +0530, Mohammed Shafi wrote:
> > On Tue, Jul 5, 2011 at 8:00 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> > > Hi,
> > >
> > > On Tue, Jul 05, 2011 at 06:59:27PM +0530, Mohammed Shafi wrote:
> > >> >> > Please share your PID/VID.
> > >> >
> > >> > 0cf3:9271
> > >> >
> > >> >> And also for compat-wireless-v3.0-rc4-1, FW version should be 1.3 and fw size
> > >> >> should be 51272. But in your case size is 51288 which is 1.2. Please upgrade fw
> > >> >> to 1.3 and test again.
> > >> >>
> > >> >> http://wireless.kernel.org/download/htc_fw/1.3/htc_9271.fw
> > >> >
> > >> > Okay.  I had tried both versions previously; neither seems to work any better
> > >> > than the other.  Here is dmesg using firmware version 1.3:
> > >> >
> > >> > [  102.984766] Compat-wireless backport release: compat-wireless-v3.0-rc4-1
> > >> > [  102.984775] Backport based on linux-2.6-allstable.git v3.0-rc4
> > >> > [  103.213468] Calling CRDA to update world regulatory domain
> > >> > [  103.798281] usbcore: registered new interface driver ath9k_htc
> > >> > [  108.482070] usb 5-7: new high speed USB device using ehci_hcd and address 5
> > >> > [  108.643105] usb 5-7: configuration #1 chosen from 1 choice
> > >> > [  108.996663] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
> > >> > [  109.135499] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 credits
> > >> > [  109.140526] ath: UNDEFINED -> AWAKE
> > >> > [  109.141769] ath: serialize_regmode is 0
> > >> > [  109.383151] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
> > >> > [  109.383168] ath: REGISTER WRITE FAILED, multi len: 9
> > >> > [  109.609805] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> > >> > [  109.609822] ath: REGISTER READ FAILED: (0x9c00, -110)
> > >> > [  109.609835] ath: Reading from EEPROM, not flash
> > >> > [  109.824058] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
> > >> > [  109.824079] ath: Multiple REGISTER READ FAILED (count: 8)
> > >> > [  110.042132] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
Forest,

To avoid multi reg writes please apply the following change 

diff --git a/drivers/net/wireless/ath/ath9k/wmi.h
b/drivers/net/wireless/ath/ath9k/wmi.h
index fde6da6..0878add 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -124,7 +124,7 @@ enum wmi_event_id {
        WMI_TXSTATUS_EVENTID,
	 };
	  
	  -#define MAX_CMD_NUMBER 62
	  +#define MAX_CMD_NUMBER 1
	   
	    struct register_write {
	            __be32 reg;
--
Rajkumar
		   

