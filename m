Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:49888 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbCSNYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 09:24:05 -0400
Message-ID: <550ACDF2.30507@linutronix.de> (sfid-20150319_142416_210500_CD836B80)
Date: Thu, 19 Mar 2015 14:24:02 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [1/3] rt2x00usb: initialize the read value in case of failure
References: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de> <20150316160652.789B313FBE6@smtp.codeaurora.org> <20150316164100.GA6208@linutronix.de> <20150317083414.GA1276@linutronix.de> <20150318131124.GA11724@redhat.com>
In-Reply-To: <20150318131124.GA11724@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2015 02:11 PM, Stanislaw Gruszka wrote:
> On Tue, Mar 17, 2015 at 09:34:14AM +0100, Sebastian Andrzej Siewior wrote:
>> I have no idea what AutoRun mode is (it seems that the stick already
>> has a firmware and is happy with it) and I have no clue why the firmware
>> decides to lie about it. I looked at the vendor driver I found at github
>> (which seems to be from 2012-10-22, DPO_RT5572_LinuxSTA_2.6.1.3) and
>> well, I look again if someone says it is worth looking… They seem to do
>> some kind "firmware is comming" magic which might be already done in the
>> current driver at a different spot but I think the main question is why
>> request is answered wrong. I *think* the vendor driver sends the
>> USB_MODE_AUTORUN request only once but it is hard to tell…
> 
> Does the below patch solve the issue ?

So you kill the please-load-the-firware bit and avoid further questions
regarding its state. Yes, it helps as in my test-case is now running
for ~15h. I see the "NIC in AutoRun mode" just once. Thanks.

I am still curious why it answers wrong but lets hope the first answer
is correct :)

> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 9a2f44a..3a6cae8 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -293,6 +293,7 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
>  	if (retval) {
>  		rt2x00_info(rt2x00dev,
>  			    "Firmware loading not required - NIC in AutoRun mode\n");
> +		__clear_bit(REQUIRE_FIRMWARE, &rt2x00dev->cap_flags);
>  	} else {
>  		rt2x00usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
>  					      data + offset, length);
> 
Sebastian
