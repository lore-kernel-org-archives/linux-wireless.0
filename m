Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:51421 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab2H1Mxn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 08:53:43 -0400
Message-ID: <503CBEF8.7010505@allnet.de> (sfid-20120828_145357_516405_A11CF358)
Date: Tue, 28 Aug 2012 15:52:08 +0300
From: Daniel Golle <dgolle@allnet.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"gwingerde@gmail.com" <gwingerde@gmail.com>,
	"heinold@inf.fu-berlin.de" <heinold@inf.fu-berlin.de>
Subject: Re: [PATCH v2] rt2x00: add MediaTek/RaLink Rt3352 WiSoC
References: <20120821235349.GA14648@earthship.home> <20120822105110.GC6082@redhat.com> <20120824152542.GA32145@earthship.home> <20120828124214.GA8426@redhat.com>
In-Reply-To: <20120828124214.GA8426@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On 28/08/12 15:42, Stanislaw Gruszka wrote:
> Thanks. Could you also provide information what was the source
> (registers programming) you based when writing this patch?
The vendor-driver Allnet got for that board (which is not publicly available and
we can't release its source)

>> +	if (rt2x00_rt(rt2x00dev, RT3352)) {
>> +		rt2800_bbp_write(rt2x00dev, 27, 0x0);
>> +		rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);
>> +		rt2800_bbp_write(rt2x00dev, 27, 0x20);
>> +		rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);
> 
> Writes two times to the same registers are intended?
Yes, as this is how it is done in the vendor driver, to me it looks like
register 27 acts as a switch selecting the destination for the value written to
register 62 or something like that.


Thank you!


Daniel
