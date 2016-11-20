Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34960 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753014AbcKTCvO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Nov 2016 21:51:14 -0500
Received: by mail-pg0-f66.google.com with SMTP id p66so24716483pga.2
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2016 18:51:14 -0800 (PST)
Date: Sun, 20 Nov 2016 12:42:59 +1000
From: Barry Day <briselec@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 0/7] rtl8xxxu: Pending patches
Message-ID: <20161120024257.GA13169@testbox> (sfid-20161120_035117_585188_3F291784)
References: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
 <20161119014648.GA7140@testbox>
 <wrfjbmxcb55h.fsf@redhat.com>
 <20161119023830.GA7324@testbox>
 <wrfj37inauwp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfj37inauwp.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 19, 2016 at 06:53:42PM -0500, Jes Sorensen wrote:
> Barry Day <briselec@gmail.com> writes:
> > On Fri, Nov 18, 2016 at 09:00:10PM -0500, Jes Sorensen wrote:
> >> Barry Day <briselec@gmail.com> writes:
> >> > On Fri, Nov 18, 2016 at 04:44:21PM -0500, Jes.Sorensen@redhat.com wrote:
> >> >> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >> >> 
> >> >> Kalle,
> >> >> 
> >> >> Please find attached a number of patches for the rtl8xxxu
> >> >> driver.
> >> >> 
> >> >> The issues reported with wpa_supplicant on 8723bu still needs further
> >> >> investigation.
> >> >> 
> >> >
> >> > The patch I posted that you want tested more will also fix the
> >> > wpa_supplicant issue.  Currently I'm looking at why the tx rate is not
> >> > what it should be. I feel fixing that first will be beneficial for
> >> > fixing any other issues.
> >> 
> >> Interesting, I was thinking that might be the case. I do want to dig
> >> into this further to understand it better. If we use your solution I
> >> will want to make sure we cover both gen1 and gen2 parts.
> >> 
> >> > The recent merge has made my local branch of rtl8xxxu-devel 14
> >> > commits ahead.
> >> > Do I need to do a reset and submit a new patch for the DWA-131 dongle?
> >> 
> >> In general you need to use 'git pull --rebase' on my tree. I rebase it
> >> to stay in sync with Kalle's tree.
> >> 
> >> The DWA-131 is the 8192eu? Sorry a bit behind and my mind is losing
> >> bits. If it's the patch you posted earlier I can dig it out and play
> >> with it - I am still catching up though, so please be patient.
> >
> > yes it's an 8192eu.
> 
> Gotcha - how do you do your testing to reproduce the problem btw? Most
> of my testing is using the 8723au as a primary device and the next
> device as a follow-on, so I may not see as long a run with the device
> active as you see.
> 

Testing is simple. Connect to an AP in the usual manner..disconnect..reconnect.
The 8192eu will fail to reconnect and John Heenan reported the 8723bu also
fails to reconnect. Even though he was directly stopping and restarting
wpa_supplicant, it's the same thing to the driver -
connect..disconnect..reconnect.


> > Would you accept a patch that adds a struct device pointer to rtl8xxxu_priv
> > and used as the device pointer in the logging functions? Then all the messages
> > will start with the driver name making them easier to find.
> 
> How do you mean? Right now I have a struct usb_device pointer and
> dereference that for ->dev to use with dev_info() messages etc. Do you
> want to see more than that?
> 
> Cheers,
> Jes


With using a usb_device pointer, each message starts with the usb bus address.
Plug it into a different port and that address could change. By using a pointer
to the device associated with the wiphy each message will begin with the driver
name. Just makes it easier for the average user to report what's in the log
because he can just grep for "rtl8xxxu".

Barry
