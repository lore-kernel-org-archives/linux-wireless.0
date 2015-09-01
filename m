Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbbIAF0s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 01:26:48 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<55E289A3.6030001@lwfinger.net> <wrfjegik8vqy.fsf@redhat.com>
	<55E39707.60101@lwfinger.net> <wrfjy4gs5ggd.fsf@redhat.com>
	<55E476A0.4080601@lwfinger.net> <wrfjio7v3txe.fsf@redhat.com>
	<55E4EE6F.2010008@lwfinger.net> <wrfjwpwa3fkc.fsf@redhat.com>
	<55E534EA.9090605@lwfinger.net>
Date: Tue, 01 Sep 2015 01:26:46 -0400
In-Reply-To: <55E534EA.9090605@lwfinger.net> (Larry Finger's message of "Tue,
	1 Sep 2015 00:17:30 -0500")
Message-ID: <wrfjk2sa3e21.fsf@redhat.com> (sfid-20150901_072701_847188_5D71220D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 08/31/2015 11:54 PM, Jes Sorensen wrote:
>> As I mentioned in a direct email - calling writeN from slow_writeN is
>> not a solution. I found some devices fail if you try to use the fast
>> writeN routine. Maybe rtl8xxxu_raw_write32() - without the byteswap
>> would be a better approach, or simply putting the relevant code into the
>> slow_writeN function.
>>
>> I am flying back to New York tomorrow, and I'll have some time on the
>> plane, so I'll try to have a look at that.
>
> I also found that trying to write all N bytes at once failed, but
> writing 64 at a time is OK. I will add the USB calls to slow_writeN.

I see, it's possible we need to add it as a parameter to writeN or add
the size to the fops struct for the different device types. In fact the
latter might be a cleaner approach, especially if it works for 8192/8188
devices with 64 byte writes. Getting rid of slow_writeN altogether would
be nice.

Jes
