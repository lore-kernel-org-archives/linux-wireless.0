Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61801 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab2ILBIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 21:08:46 -0400
Received: by weyx8 with SMTP id x8so661153wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 18:08:45 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Richard Farina <sidhayn@gmail.com>
Subject: Re: [PATCH] carl9170: fix spurious transmissions in sniffer mode
Date: Wed, 12 Sep 2012 03:08:29 +0200
Cc: linux-wireless@vger.kernel.org, scchen@qca.qualcomm.com,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	marco@tampabay.rr.com, janusz.dziedzic@gmail.com
References: <201209112318.35334.chunkeey@googlemail.com> <201209120126.31312.chunkeey@googlemail.com> <504FCD39.80705@gmail.com>
In-Reply-To: <504FCD39.80705@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201209120308.30985.chunkeey@googlemail.com> (sfid-20120912_030850_436781_ECB82C46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 September 2012 01:46:01 Richard Farina wrote:
> On 09/11/2012 07:26 PM, Christian Lamparter wrote:
> > On Wednesday 12 September 2012 00:03:40 Richard Farina wrote:
> >> On 09/11/2012 05:18 PM, Christian Lamparter wrote:
> >>> Several people have complained about an unusual
> >>> and undocumented feature of the AR9170 hardware:
> >>>
> >>> In siffer mode, the hardware generates spurious
> >>> ACK frames for every received frame... even
> >>> broadcasts.
> >>>
> >>> The reason for this malfunction is unknown:
> >>> <http://marc.info/?l=linux-wireless&m=134517238506033>
> >>> But there's a workaround: Instead of the special
> >>> sniffer mode, the hardware will be put into
> >>> station mode and all rx filters are disabled.
> >> I am by no means an expert here but wouldn't it be better to disable
> >> ACK? Or is this not really an option?
> > Oh AFAIK there's some nifty software which emulates
> > some sort of accesspoint by (ab-)using monitor mode
> > and injection. And in this case having a device which
> > ACKs any frame destined for the semi-fake ap might be
> > a "good thing".
>
> Are you referencing airbase-ng here? Airbase-ng assumes
> the hardware does not ack in monitor mode and therefore
> does it itself.  Mind you, I'm not saying it wouldn't be
> nice to have the hardware ack (VASTLY improved response
> time for one) but a monitor mode vif is assumed to not
> transmit anything at all, unless we specifically inject
> it.
> 
> An ack on/off (default off) would be awesome, but baring
> that the only sane choice is off.
I'm no expert either, but isn't airbase-ng more of a client
attack tool suite than a useful softAP? No, it must have
been a different software then.

Anyway, now the hardware will only react to frames that
are "directed" (DA matches either the main, or one of
the 8 vif mac addresses) to it (is this now sane or
not?). So, the hardware ack ability is not going to just
disappear, if someone is already depending on it.

(BTW: wasn't there once some sort of a "tx ack" control
interface in mac80211 debugfs path? Does anybody know
what happend to it?)

Regards,
	Chr
