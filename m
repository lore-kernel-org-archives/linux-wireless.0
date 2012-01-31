Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36036 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2AaRAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 12:00:10 -0500
Received: by wics10 with SMTP id s10so148027wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 09:00:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120131081422.GB2438@redhat.com>
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
	<1327936679-12576-2-git-send-email-sgruszka@redhat.com>
	<4F271479.4090303@gmail.com>
	<20120131081422.GB2438@redhat.com>
Date: Tue, 31 Jan 2012 18:00:09 +0100
Message-ID: <CAL1gcdOC8ygHfvqoQewShuXJm25pOaL7CWkoX3wcSZcyJkwaUw@mail.gmail.com> (sfid-20120131_180016_555282_DB95190D)
Subject: Re: [rt2x00-users] [PATCH 2/4] rt2800: radio 3xxx: program RF_R1
 during channel switch
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 9:14 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jan 30, 2012 at 11:06:49PM +0100, Gertjan van Wingerde wrote:
>> On 01/30/12 16:17, Stanislaw Gruszka wrote:
>> > +   rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
>> > +   rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
>> > +   rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
>> > +   if (rt2x00_rt(rt2x00dev, RT3390)) {
>> > +           rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD,
>> > +                             rt2x00dev->default_ant.rx_chain_num == 1);
>> > +           rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD,
>> > +                             rt2x00dev->default_ant.tx_chain_num == 1);
>> > +   } else {
>> > +           rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
>> > +           rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
>> > +           rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
>> > +           rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
>> > +
>> > +           switch (rt2x00dev->default_ant.tx_chain_num) {
>> > +           case 1:
>> > +                   rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
>> > +                   /* fall through */
>> > +           case 2:
>> > +                   rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
>> > +                   break;
>> > +           }
>> > +
>> > +           switch (rt2x00dev->default_ant.rx_chain_num) {
>> > +           case 1:
>> > +                   rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
>> > +                   /* fall through */
>> > +           case 2:
>> > +                   rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
>> > +                   break;
>> > +           }
>> > +   }
>> > +   rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
>> > +
>> >     rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
>> >     rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
>> >     rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
>>
>> To be honest, I think that this can be simplied to a single case for
>> both RT30xx and RT33xx. Just take the RT30xx branch of the added
>> if-statement and it should just work fine on both chipset families.
>>
>> Yes, I am aware the Ralink driver has slightly different code here, but
>> that just seems to be because they work with knowledge of the
>> limitations of RT33xx, which ensures that tx_chain_num and rx_chain_num
>> can never be 2 on that chipset, but still handling it doesn't harm. It
>> would merely result in better readable code.
>
> Not only the code is different, but RF_R1 register value we program
> is different for 30xx and 33xx when chain_num == 1 (changed by
> RFCSR1_{RX2,TX2)_PD bit).
>
> I'm not against merging these two cases and program different values
> into register than Ralink driver do, but maybe in the next linux
> release (counting from release of that change), so any breakage
> eventually caused by that merge could be easily detected.

OK. Indeed let's do this in a different commit, at least. I don't know
if it has to be a
different kernel release, as long as we are able to bisect it.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

for this patch as well.

---
Gertjan
