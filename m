Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63774 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2C1M7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 08:59:07 -0400
Received: by eaaq12 with SMTP id q12so254878eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Mar 2012 05:59:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120328145359.4bd5d098@north>
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
 <1332859867-27921-3-git-send-email-kubakici@wp.pl> <4F7202BB.4000904@gmail.com>
 <20120328121428.GA3333@redhat.com> <20120328145359.4bd5d098@north>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 28 Mar 2012 23:58:45 +1100
Message-ID: <CAGRGNgWCDo7GpSOC5H-HE_uiF05wGh7FSQw5HL68XB9f8Xg5nA@mail.gmail.com> (sfid-20120328_145911_312361_60097A45)
Subject: Re: [rt2x00-users] [PATCH 2/4] rt2x00: move disabling of DMA before
 loading firmware
To: Jakub Kicinski <kubakici@wp.pl>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On Wed, Mar 28, 2012 at 23:53, Jakub Kicinski <kubakici@wp.pl> wrote:
> On Wed, 28 Mar 2012 14:14:29 +0200
> Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
>> Hello,
>>
>> On Tue, Mar 27, 2012 at 08:11:07PM +0200, Gertjan van Wingerde wrote:
>> > >   /*
>> > > -  * Disable DMA, will be reenabled later when enabling
>> > > -  * the radio.
>> > > -  */
>> > > - rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
>> > > - rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
>> > > - rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
>> > > - rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
>> > > -
>> > > - /*
>> > >    * Initialize firmware.
>> > >    */
>> > >   rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
>> >
>> > This basically seems to be a revert of commit
>> > 4ed1dd2a7ec880b301beb61cbc1e08811ec340e4 in the wireless-testing tree.
>> > That commit was submitted by Stanislaw, which basically does the reverse
>> > of what you are doing here.
>> >
>> > I leave it up to you and Stanislaw to decide on what the state is that
>> > we need to be in.
>>
>> When DMA was disabled before FW load, I observed frame receives before
>> ->enable_radio, so looks like WPDMA_GLO_CFG register is overwritten by
>> F/W load. Although received frames did not make any damage, I prefer
>> not to allow hw to send data to driver, before driver will be really
>> ready to receive them.
>
> Hm. I obviously did check whether FW load does overwrite WPDMA_GLO_CFG
> and it didn't. Maybe it's device dependent? What bothers me is that now
> we have a (very) short window between FW load and disabling DMA.

Stupid question: why not disable DMA before the FW load, then disable
it afterwards just to make sure the hardware's in a known state after
the FW load? - this will catch any errant firmwares out there and
(mostly) eliminate the window between FW load and DMA disabling.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
