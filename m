Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43419 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1EBT7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 15:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <1304303082.2833.159.camel@localhost>
References: <BANLkTintnaEj0DDjwQJjc4wpuz-c_QOGyg@mail.gmail.com>
	<1304303082.2833.159.camel@localhost>
Date: Mon, 2 May 2011 20:59:04 +0100
Message-ID: <BANLkTi=FT4v=Jvv5bQpUX15R87kPudKq=Q@mail.gmail.com> (sfid-20110502_215931_396000_251405CA)
Subject: Re: Frequent spurious tx_timeouts for libertas
From: Daniel Drake <dsd@laptop.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 May 2011 03:24, Ben Hutchings <bhutchings@solarflare.com> wrote:
>> Also, while looking at this code, I spotted a bug in dev_watchdog():
>>                               /*
>>                                * old device drivers set dev->trans_start
>>                                */
>>                               trans_start = txq->trans_start ? : dev->trans_start;
>>
>> i.e. it is trying to figure out whether to read trans_start from txq
>> or dev. In both cases, trans_start is updated based on the value of
>> jiffies, which will occasionally be 0 (as it wraps around). Therefore
>> this line of code will occasionally make the wrong decision.
>
> No, I don't think so.
>
> If only dev->trans_start is being updated then the watchdog reads that.
> If both txq->trans_start and dev->trans_start are being updated then it
> doesn't matter much which the watchdog reads.
> If only txq->trans_start is being updated then dev->trans_start is
> always set to 0, so when txq->trans_start is 0 the watchdog still gets
> 0.

dev->trans_start is unconditionally initialized by dev_activate() in
sch_generic.c:

	if (need_watchdog) {
		dev->trans_start = jiffies;
		dev_watchdog_up(dev);
	}

so it is (usually) not 0.

Thanks for your input on the tx timeout issue, now that I understand
it better I think the right plan of action is to remove it from
libertas entirely, I'll CC you on the patch.

Daniel
