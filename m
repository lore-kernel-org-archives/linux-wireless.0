Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402Ab0FEA7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 20:59:25 -0400
Subject: RE: Power save mode in 2.6.32-22
From: Dan Williams <dcbw@redhat.com>
To: "Gordon, Charles" <Charles.Gordon@digi.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <8DCC153EAFE67A4B990A840E829F704B017C658C6A29@mtk-sms-exch01.digi.com>
References: <8DCC153EAFE67A4B990A840E829F704B017C658D620C@mtk-sms-exch01.digi.com>
	 ,<201006040255.46964.chunkeey@googlemail.com>
	 <8DCC153EAFE67A4B990A840E829F704B017C658C6A29@mtk-sms-exch01.digi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 17:58:36 -0700
Message-ID: <1275699516.2290.8.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-04 at 04:42 -0500, Gordon, Charles wrote:
> Hi Christian,
> 
> Thanks for the information.  
> 
> What I have observed is that the wireless stack will continuously send null-data frames, toggling the power-mgmt bit, and use the config call back routine to turn power save on and off.  Can I assume from this that in 2.6.32 the stack will take care of sending all the null-data frames and just tell the driver when to power up or power down the hardware?  When did this change in the implementation of power save occur?  In previous versions of the wireless stack the driver received one config call to turn power save on or off and then it was up to the driver to manage it, including sending null-data frames and duty cycling.
> 
> How can I disable power save mode for performance testing?  It seems to come on automatically and the "iwconfig wlan0 power off" command says that function is not supported.  Is there a way to control what percentage of the time the H/W will be powered up?
> 
> I will check to see if the wireless stack is doing periodic scans.  I think I did see some probe frames.  Is there a way to turn this feature off for performance testing?

The periodic scans are usually triggered from userspace, like from
wpa_supplicant when it tries to find an AP to associate with.

But if you are getting the power save on/off callback, that doesn't
sound like periodic scanning.  Telling the *AP* that you're going into
powersave (so it buffers your traffic for a second or two) so that the
scan won't interrupt data, actually power saving the card are two
different things.  Scanning *should* tell the AP that you're going in
and out of power save, but it shouldn't actually powersave the card
since that would negate the purpose of the scan.

If you can debug a bit more and find out whether the power save frames
are triggered by a scan, or whether the stack actually wants the card to
power save (albeit incorrectly) that would be useful.

Dan

> Thanks for any help.
> 
> ________________________________________
> From: Christian Lamparter [chunkeey@googlemail.com]
> Sent: Thursday, June 03, 2010 8:55 PM
> To: Gordon, Charles
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: Power save mode in 2.6.32-22
> 
> On Friday 04 June 2010 01:27:38 Gordon, Charles wrote:
> > Hi,
> >
> > I'm trying to get power save mode to work in a wireless driver on Linux
> > 2.6.32.  What I'm seeing is that the wireless stack is sending null-data
> > frames with the power management bit on or off from time to time.  It does
> > this regardless of whether flags IEEE80211_HW_SUPPORTS_PS and
> > IEEE80211_HW_SUPPORTS_DYNAMIC_PS are set.  This is not how I would expect
> > it to work.  If IEEE80211_HW_SUPPORTS_PS is set, I would expect it to let
> > the driver handle the sending of these frames.  If IEEE80211_HW_SUPPORTS_PS
> > is not set, then this would indicate that the driver cannot power down, in
> > which case I still would not expect the stack to be sending these frames.
> > The documentation for power save is very thin and it seems the
> > implementation has changed recently.
> >
> > Why is the stack sending these frames when the driver says the H/W does not
> > support powering down?
> 
> well, could this be a periodic scan / site survey? (perhaps
> NM/wicd/wpa_supplicant is running in the background?).
> 
> The device signalize the AP that it goes "off-channel" to scan on other
> frequencies. Therefore the AP should be prepared to buffer any traffic,
> until the STA resumes normal operation.
> 
> This can be easily tested with the help of a sniffer,
> because you should then get probe requests from the interface.
> 
> > Why is the stack sending these frames when it would seem that the driver
> > could better handle them?
> >
> > The reason why I think the driver can better handle them is that if the
> > stack sends a frame with the power-mgmt bit set, and then tells the driver
> > to power down, there will be a race condition where the interface could
> > receive a frame before the hardware is powered down.  The AP may send such
> > a frame after it receives the null-data frame because some could be in a
> > H/W queue.  I have seen this happen.  In this case, the interface H/W on
> > the station will send an ACK and since the H/W does not know that it is
> > about to be powered down, that ACK will be sent with the power-mgmt bit
> > clear, which may confuse the access point.
> 
> > In short, sending these frames
> > is something the driver should do since it will know that it should adjust
> > the H/W so that any ACKs or other control frames will be sent with the
> > power mgmt bit correctly set until such time as the H/W is actually powered
> > down.
> 
> quote from: 802.11-2007 "11.2.1 Power management in an infrastructure network"
> 
> "A STA shall remain in its current Power Management mode until it informs the AP of
>  a Power Management mode change via a frame exchange that includes an acknowledgment
>  from the AP. Power Management mode shall not change during any single frame exchange
>  sequence as described in 9.12"
> 
> The way I read it, it means two things:
> 
> Firstly, the STA has to initiate a "frame exchange" in order to
> notify the AP about its new power state. (And importantly, that
> frame exchange has to succeed, before the STA can actually
> go off-channel/sleep! - This is important, because not all
> drivers/HW do support an accurate *frame success* report.)
> 
> Secondly: The AP should only consider the PSM bit setting,
> if the "exchange" was actually initiated by the STA and not
> by the AP. (Furthermore, for most control frames timing is
> critical. Therefore they have to be implemented in the
> hardware/firmware and this makes it nearly impossible to
> do what you are describing in your last _quoted_ sentence)
> 
> BTW: have you tried to reproduce your "timing" problem with
> a recent compat-wireless?
> 
> Regards,
>         Chr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


