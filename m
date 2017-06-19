Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [91.227.64.183] ([91.227.64.183]:60008 "EHLO rere.qmqm.pl"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbdFSQk0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 12:40:26 -0400
Date: Mon, 19 Jun 2017 18:40:20 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: brcmfmac: initialize oob irq data before
 request_irq()
Message-ID: <20170619164020.wgfzt6vvg3fmnkf6@qmqm.qmqm.pl> (sfid-20170619_184031_065822_9D6FC413)
References: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl>
 <87poe74138.fsf@kamboji.qca.qualcomm.com>
 <20170614112925.d3j3l5bam5gwhj7h@qmqm.qmqm.pl>
 <87vanxe2m6.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <87vanxe2m6.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[resending reply to linux-wireless]

On Thu, Jun 15, 2017 at 05:40:01PM +0300, Kalle Valo wrote:
> Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> writes:
> 
> > On Wed, Jun 14, 2017 at 07:58:35AM +0300, Kalle Valo wrote:
> >> Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> writes:
> >> > This fixes spin-forever in irq handler when IRQ is already asserted
> >> > at request_irq() time.
> >> >
> >> > Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
> >> 
> >> Your name in patchwork is broken:
> >> 
> >> https://patchwork.kernel.org/patch/9784251/
> >> 
> >> You could try to fix it by registering as then you have (onetime) option
> >> to provide your full name.
> >
> > Doesn't like UTF-8?
> 
> patchwork.kernel.org was updated something like a year ago to get proper
> UTF-8 support and I have been succesfully applied patches from Rafal who
> also uses UTF-8 with his name:
> 
> git log --author rafal@milecki.pl drivers/net/wireless/
> 
> You could always compare his posts with yours and see what you do
> differently. Here's one example:
> 
> https://patchwork.kernel.org/patch/9640743/
> 
> > Registration didn't help though.
> 
> Darn. This time I can manually apply the patch but for the future we
> should try to solve this.

Looks like my name, as known by Patchwork, got doubly UTF-8-encoded:

# this is how it is in From header in Patchwork:
$ echo TWljaGHDheKAmiBNaXJvc8OF4oCaYXc=|base64 -d|hexdump -C
00000000  4d 69 63 68 61 c3 85 e2  80 9a 20 4d 69 72 6f 73  |Micha.....
Miros|
00000010  c3 85 e2 80 9a 61 77                              |.....aw|
00000017

# this is how it should look like:
$ echo -n 'Micha³ Miros³aw'|hexdump -C
00000000  4d 69 63 68 61 c5 82 20  4d 69 72 6f 73 c5 82 61  |Micha..
Miros..a|
00000010  77                                                |w|

Best Regards,
Micha³ Miros³aw
