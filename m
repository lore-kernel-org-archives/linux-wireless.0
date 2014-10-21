Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53141 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696AbaJUIHT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 04:07:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by gateway2.nyi.internal (Postfix) with ESMTP id 004F520A5D
	for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 04:07:18 -0400 (EDT)
Message-Id: <1413878838.3495500.181423789.432422F8@webmail.messagingengine.com> (sfid-20141021_100731_151904_B3AE312F)
From: =?UTF-8?Q?Lauren=C8=9Biu=20Nicola?= <lnicola@dend.ro>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
In-Reply-To: <CABPxzY+twpNpERES75MjVjaqGo5WKd2Rze4NH_hwCQGuqsUPxg@mail.gmail.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
 <1413510814.22769.6.camel@dcbw.local>
 <1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
 <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
 <1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
 <CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
 <CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
 <1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>
 <CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>
 <1413833365.2949853.181221645.22D54845@webmail.messagingengine.com>
 <CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
 <CANUX_P06VvZ0uugayOvhZK0iM-NetftN5rZA27TtkYku66cGXA@mail.gmail.com>
 <CABPxzYJmhE8wodzoVDbx=inrAusP1NLCjcj0+R7MUmQhUFcyUA@mail.gmail.com>
 <CABPxzYJkh7fV6kXhYZvbH7PBHJNBsz0DwshpZFmcDPifwXe6fQ@mail.gmail.com>
 <CANUX_P1eb-C9yK-JGHgp_dc6uJzkDA=GYzKf+CFF50cqv0pVMQ@mail.gmail.com>
 <CABPxzY+twpNpERES75MjVjaqGo5WKd2Rze4NH_hwCQGuqsUPxg@mail.gmail.com>
Subject: Re: iwlwifi: Reason 7 periodic disconnect
Date: Tue, 21 Oct 2014 11:07:18 +0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could this still happen if power saving is disabled?

Laurentiu

On Tue, Oct 21, 2014, at 10:22, Krishna Chaitanya wrote:
> On Tue, Oct 21, 2014 at 12:34 PM, Emmanuel Grumbach <egrumbach@gmail.com>
> wrote:
> > On Tue, Oct 21, 2014 at 9:37 AM, Krishna Chaitanya
> > <chaitanya.mgit@gmail.com> wrote:
> >> On Tue, Oct 21, 2014 at 12:06 PM, Krishna Chaitanya
> >> <chaitanya.mgit@gmail.com> wrote:
> >>> On Tue, Oct 21, 2014 at 11:01 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> >>>> On Tue, Oct 21, 2014 at 8:02 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> >>>>> On Mon, Oct 20, 2014 at 10:29 PM, Laurențiu Nicola <lnicola@dend.ro> wrote:
> >>>>>> No, nothing in the DD-WRT syslog. The IP seems to be the one cached by
> >>>>>> my DHCP client. I also tried various suggestions found on the internet,
> >>>>>> but nothing helped.
> >>>>>>
> >>>>>
> >>>>> Can you please try to have another device in monitor mode to sniff the
> >>>>> traffic going on?
> >>>>> Felix, can you please tell me when DD-WRT can send a deauth with reason code 7?
> >>>>>
> >>>>> thanks.
> >>>>
> >>>> Can you please disable power save?
> >>>> For this, please make sure you have
> >>>> https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=f8dfc607b2b460e8e8adfdfb3c5f5bba3a4ad01b
> >>>> or at least have the module parameter.
> >>>> I am wondering if the firmware is not sending frames because of power
> >>>> save toggling.
> >>>>
> >>>> I you could get more extensive logs from the AP it'd be great.
> >>>> Running tracing on the AP would let us know why it thinks we are not associated.
> >>>>
> >>> I have faced the same issue before it happens when DUT is in powersave
> >>> and for some reason AP authenticates (in this case probably due to
> >> *typo: deuauthenticates.
> >>
> >>> inactivity) but as DUT is in power save we don't Rx the deauth (some
> >>> AP's don't wait
> >>> for STA to wakeup and retrieve the deauth frame).
> >>>
> >>> So after that if DUT tries to sent any data frame, as it still thinks
> >>> that it is connected
> >>> (network lost also will not trigger because it still Rx beacon) and in
> >>> that case AP deauthenticates
> >>> us by Reason:7.
> >>>
> >>> May be if we enable tx status report ACK we can pass the inactivity
> >>> check as some AP's
> >>> wont reset inactivity timer for probe's.
> >
> > That seems unlikely - we are kicked out after 1 minute?
> > Let's check, Laurentiu - can you please ping in the background and see
> > what happens?
> 
> Yeah, but some Ap's do that :-)
> Quote from Laurentiu:
> 
> "What I found out in the meanwhile, however, is that active traffic will
> prevent the issue from occurring. This happened with the Fedora Live CD,
> but pinging the AP is also sufficient. I noticed iwconfig reports that
> the power saving mode is off."
> 
> So when traffic is there the issue doesn't happen, so it points to
> inactivity.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
