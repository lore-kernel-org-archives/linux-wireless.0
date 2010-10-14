Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nyc-nss1.cypresscom.net ([64.190.13.53]:53266 "EHLO
	nyc-nss1.cypresscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab0JNRQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 13:16:56 -0400
Subject: Re: Question about starting up an AP
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Joshua Smith <JoshuaESmith@charter.net>
In-Reply-To: <201010010742.07605.helmut.schaa@googlemail.com>
Date: Thu, 14 Oct 2010 13:16:55 -0400
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <ivdoorn@gmail.com>
Message-Id: <B3E6C8F9-24E4-4F12-B19C-15A474E5BCFA@charter.net>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <71135D34-18F6-4909-A8AB-E7390FA73049@charter.net> <201009301814.47318.helmut.schaa@googlemail.com> <201010010742.07605.helmut.schaa@googlemail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, I finally got a chance to run the test.  Before doing the revert, I tried just using the current drivers, but with a ridiculously large number of retries.

Lo and behold: no error.  So I think this is the reason the old drivers were working for me, not anything that happened between July and September.  When I went back to the old drivers, I had made this change, and they worked.  I figured it was because I was using the old drivers, but now I realize it is because of this change.

Also, I can see the behavior pretty clearly.  Sometimes when I start up hostapd, it starts right up, and sometimes it takes about a second, and then starts up.  So it looks like this retry number just needs to be really, really big.  (Note that with this change in the old drivers, on very rare occasions, I still see the "busy, aborting" error.  So perhaps it should be even bigger than 1000?)

Not sure how you want to proceed with this, but this is the code that makes my AP work:

 nl compat-wireless-2010-09-20/drivers/net/wireless/rt2x00/rt2800lib.c | grep -C 10 1000/

   225	int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
   226	{
   227		unsigned int i;
   228		u32 reg;
       
   229		for (i = 0; i < 1000/*REGISTER_BUSY_COUNT*/; i++) {
   230			rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
   231			if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
   232			    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
   233				return 0;
       
   234			msleep(1);
   235		}
       
   236		ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
   237		return -EACCES;


On Oct 1, 2010, at 1:42 AM, Helmut Schaa wrote:

> Hi Joshua,
> 
> Am Donnerstag 30 September 2010 schrieb Helmut Schaa:
>> Am Donnerstag 30 September 2010 schrieb Joshua Smith:
>>> I think I have a clue about the WPDMA TX/RX busy bug.  I was having trouble
>>> using the latest compat-wireless with USB dongle I have (ID AB50:2019
>>> rt73usb), so I tried rolling Helmut's "oops" fix into:
>>> 
>>> compat-wireless-2010-07-15
>>> 
>>> which I have been using successfully for the last few months.  Lo and behold,
>>> this version does *NOT* exhibit the TX/RX busy error.  So whatever is causing
>>> that problem was introduced between 7/15/2010 and 9/20/2010.
>> 
>> Thanks for the analysis Joshua! Since this is a regression I guess we
>> should try to find out quickly which commit introduced it (and fix it up
>> of course) ...
> 
> Unfortunately during that time a lot of rt2x00 patches went into
> wireless-testing. However, there's one suspicious commit that touches the
> relevant code: "rt2x00: Merge rt2800{pci/usb} radio enabling/disabling code
> to rt2800lib".
> 
> This is again a shot in the dark but worth a try. Could you please revert this
> commit [1] from the newer compat-wireless tarball and try if it fixes the "DMA
> Busy" issue?
> 
> Thanks Joshua,
> Helmut
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=b9a07ae9d9e09662013992088fd58ffbcb2f9a30

