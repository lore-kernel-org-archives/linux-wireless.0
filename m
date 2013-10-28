Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab3J1TCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 15:02:03 -0400
Message-ID: <1382986906.7298.10.camel@dcbw.foobar.com> (sfid-20131028_200208_109636_94B83452)
Subject: Re: [PATCH] cfg80211/nl80211: Add support to report unsafe
 frequency ranges(s)
From: Dan Williams <dcbw@redhat.com>
To: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>
Cc: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>
Date: Mon, 28 Oct 2013 14:01:46 -0500
In-Reply-To: <D19FD2B13A40CD4B8DA64DB9B8F112E9218E461D@nasanexd01a.na.qualcomm.com>
References: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com>
	 <1382020835.14410.16.camel@jlt4.sipsolutions.net>
	 <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAD14@nasanexd01a.na.qualcomm.com>
	 <1382035171.22901.13.camel@dcbw.foobar.com>
	 <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAF6F@nasanexd01a.na.qualcomm.com>
	 <CAB=NE6UkKuSzH4x2SjkE0pRTVCVa3k7g=_ZeU_JE+t2OovRoEg@mail.gmail.com>
	 <D19FD2B13A40CD4B8DA64DB9B8F112E9218E461D@nasanexd01a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-28 at 18:08 +0000, Chauhan, Rajesh wrote:
> Hi Luis,
> 
> For "enough information for proper usage" - how about if I add an attribute for the source of interference (say, for example, "cellular") for each of those frequency range?

When you say "cellular" here, do mean a WWAN card in the same machine,
sharing the antenna (or using a very very nearby antenna) with the WiFi
card?  Or do you mean a close-by phone, or a tower itself?  How is this
different from BT coexistence or WiMAX coexistence?

Dan

> Regards,
> Rajesh Chauhan
> 
> -----Original Message-----
> From: mcgrof@gmail.com [mailto:mcgrof@gmail.com] On Behalf Of Luis R. Rodriguez
> Sent: Sunday, October 20, 2013 3:39 AM
> To: Chauhan, Rajesh
> Cc: Dan Williams; Johannes Berg; linux-wireless@vger.kernel.org; Malinen, Jouni; Bahini, Henri; Chang, Leo; Luo, Xun
> Subject: Re: [PATCH] cfg80211/nl80211: Add support to report unsafe frequency ranges(s)
> 
> On Thu, Oct 17, 2013 at 9:51 PM, Chauhan, Rajesh <rajeshc@qca.qualcomm.com> wrote:
> > Hi Dan,
> >
> > Thanks for your comments.
> >
> > Current patch is to report event asynchronously and that would be needed even if we have your suggested interface of client collecting that information upfront, which seems like you also kind of agree, because RF environment may change later and generating an event at that time with frequency details would help. So your suggested approach of "mechanism for the client to get this information" in itself seems like a candidate for a separate patch.
> 
> The infrastructure for this sort of thing that me, Inaky and Marcel had proposed in 2007 is the Frequency Broker:
> 
> http://wireless.kernel.org/en/developers/FrequencyBroker
> 
> > On the race condition which you described - thanks!, but it is something which implementation of driver would need to take care. Similarly, user space can have implementation to cache information on receipt of the event to use it later.
> 
> This patch is vague. Once we set something as API we have to live with it, I am not comfortable with this patch having enough information for proper usage by different drivers for the same purpose or intent. The only real positive argument that could be used here is where something like Android might have already embraced some similar API but are we going to always just enable API on Linux just because Android did it without thinking about proper long term architecture? I don't think so.
> 
>  Luis


