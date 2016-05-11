Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37861 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbcEKTee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 15:34:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: merez@codeaurora.org
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2 7/7] wil6210: add support for device led configuration
References: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
	<1461589078-29854-8-git-send-email-qca_merez@qca.qualcomm.com>
	<87a8kh1pqw.fsf@kamboji.qca.qualcomm.com>
	<c9158ef6654aa9b201909103b1300177@codeaurora.org>
Date: Wed, 11 May 2016 22:34:28 +0300
In-Reply-To: <c9158ef6654aa9b201909103b1300177@codeaurora.org>
	(merez@codeaurora.org's message of "Sun, 01 May 2016 10:06:32 +0300")
Message-ID: <878tzge6d7.fsf@kamboji.qca.qualcomm.com> (sfid-20160511_213437_593136_88AAE1D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

merez@codeaurora.org writes:

> On 2016-04-25 21:56, Kalle Valo wrote:
>> Maya Erez <qca_merez@qca.qualcomm.com> writes:
>>
>>> Add the ability to configure the device led to be used for notifying
>>> the AP activity (60G device supports leds 0-2).
>>> The host can also configure the blinking frequency of the led in
>>> three states.
>>
>> [...]
>>
>>> +/* led_blink_time, write:
>>> + * "<blink_on_slow> <blink_off_slow> <blink_on_med> <blink_off_med>
>> <blink_on_fast> <blink_off_fast>
>>> + */
>>> +static ssize_t wil_write_led_blink_time(struct file *file,
>>> +					const char __user *buf,
>>> +					size_t len, loff_t *ppos)
>>> +{
>>> +	int rc;
>>> +	char *kbuf = kmalloc(len + 1, GFP_KERNEL);
>>> +
>>> +	if (!kbuf)
>>> +		return -ENOMEM;
>>> +
>>> +	rc = simple_write_to_buffer(kbuf, len, ppos, buf, len);
>>> +	if (rc != len) {
>>> +		kfree(kbuf);
>>> +		return rc >= 0 ? -EIO : rc;
>>> +	}
>>> +
>>> +	kbuf[len] = '\0';
>>> +	rc = sscanf(kbuf, "%d %d %d %d %d %d",
>>> +		    &led_blink_time[WIL_LED_TIME_SLOW].on_ms,
>>> +		    &led_blink_time[WIL_LED_TIME_SLOW].off_ms,
>>> +		    &led_blink_time[WIL_LED_TIME_MED].on_ms,
>>> +		    &led_blink_time[WIL_LED_TIME_MED].off_ms,
>>> +		    &led_blink_time[WIL_LED_TIME_FAST].on_ms,
>>> +		    &led_blink_time[WIL_LED_TIME_FAST].off_ms);
>>> +	kfree(kbuf);
>>> +
>>> +	if (rc < 0)
>>> +		return rc;
>>> +	if (rc < 6)
>>> +		return -EINVAL;
>>> +
>>> +	return len;
>>> +}
>>
>> Don't we already have a proper framework for leds? At least
>> include/linux/led.h and drivers/led/ makes me suspect that. I'm not
>> really fond of the idea reinventing the wheel, unless there's a really
>> good reason.
>
> The kernel led framework provides the host the ability to toggle a
> defined led, but in our case the led toggling is fully offloaded to
> the device. The host only configures the device with the led to
> activate and its parameters. I agree that reusing an existing
> framework should be enforced when possible, but as the WIL6210 host
> needs to align to the device led configuration we cannot reuse the led
> kernel framework.

Ok, thanks for checking. I'll apply the patch now.

-- 
Kalle Valo
