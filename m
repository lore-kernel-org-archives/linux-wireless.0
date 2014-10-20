Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41781 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbaJTFaY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 01:30:24 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by gateway2.nyi.internal (Postfix) with ESMTP id 8247C20782
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 01:30:23 -0400 (EDT)
Message-Id: <1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com> (sfid-20141020_073031_601019_8615089F)
From: =?UTF-8?Q?Lauren=C8=9Biu=20Nicola?= <lnicola@dend.ro>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: Re: iwlwifi: Reason 7 periodic disconnect
Date: Mon, 20 Oct 2014 08:30:23 +0300
In-Reply-To: <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
 <1413510814.22769.6.camel@dcbw.local>
 <1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
 <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here: https://bpaste.net/show/bf6dc1847ce3


Laurentiu
On Mon, Oct 20, 2014, at 07:52, Emmanuel Grumbach wrote:
> On Sun, Oct 19, 2014 at 11:48 PM, Laurențiu Nicola <lnicola@dend.ro>
> wrote:
> > Hello,
> >
> > Sorry for the late reply. I was using just wpa_supplicant. I also tried
> > wicd, but it seems to hang when connecting to a network, but my
> > understanding is that it's just a wpa_supplicant manager. I got this
> > while installing Gentoo, but I also reproduced it on the Fedora 20 Live
> > CD. See https://bpaste.net/show/7d5ad99260a7 for logs, but it doesn't
> > seem to say much more than my original extract.
> >
> > What I found out in the meanwhile, however, is that active traffic will
> > prevent the issue from occurring. This happened with the Fedora Live CD,
> > but pinging the AP is also sufficient. I noticed iwconfig reports that
> > the power saving mode is off.
> >
> > For what it's worth, I compiled my kernel and iwlwifi module with
> > tracing on, so tell me if I should try that.
> 
> Please recompile with MAC80211_MLME_DEBUG, MAC80211_STA_DEBUG and
> reproduce - thanks.
> 
> >
> > Laurentiu
> >
> >
> > On Fri, Oct 17, 2014, at 04:53, Dan Williams wrote:
> >> On Thu, 2014-10-16 at 15:48 +0300, Laurențiu Nicola wrote:
> >> > Hello,
> >> >
> >> > I'm using iwlwifi for a Centrino Ultimate-N 6300 on 3.14.4 and 3.17.1.
> >> > Connect to my wireless network works, but I get disconnected every 60
> >> > seconds or so. The dmesg output looks like
> >> > https://bpaste.net/show/1623a8ae5dc6 .
> >> >
> >> > I had the same issue on the three latest firmware versions:
> >> > iwlwifi-6000-ucode-9.176.4.1
> >> > iwlwifi-6000-ucode-9.193.4.1
> >> > iwlwifi-6000-ucode-9.221.4.1
> >> >
> >> > The dmesg log actually shows the driver loading the different versions
> >> > above.
> >> >
> >> > It's the first time I try to use wireless on Linux, so I might have made
> >> > a dumb mistake.
> >>
> >> Can you try to get debug output from wpa_supplicant, which is the
> >> process that controls WiFi on Linux?  What distro and version do you
> >> use, and do you know what WiFi management service is being used?
> >> (NetworkManager, conman, plain wpa_supplicant, wicd, something else?)
> >>
> >> Dan
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
