Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:23140 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaAaKzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 05:55:22 -0500
Message-ID: <52EB8121.7040602@redpinesignals.com> (sfid-20140131_115525_044262_89BE1807)
Date: Fri, 31 Jan 2014 16:25:29 +0530
From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.13.1 2/9] rsi: OS dependent functions
References: <52EA759D.8050809@redpinesignals.com>	 (sfid-20140130_170007_973159_5D8E3EA6) <1391099071.4323.21.camel@jlt4.sipsolutions.net>
In-Reply-To: <1391099071.4323.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Will change to build both SDIO and USB modules
simultaneously, as suggested by Dan.

Regards, 
Jahnavi
      

> On Thu, 2014-01-30 at 21:24 +0530, Jahnavi wrote:
>
>> +rsi_common-y := rsi_core.o rsi_osd_ops.o
>> +ifeq ($(CONFIG_RSI_USB), y)
>> +	rsi_common-y += rsi_usb.o
>> +	ccflags-y =-DUSE_USB_INTF
>> +else
>> +	rsi_common-y += rsi_sdio.o
>> +	ccflags-y =-DUSE_SDIO_INTF
>> +endif
> That can't be right - in the Kconfig you declared that it's valid to
> select both SDIO and USB at the same time. You can also use the syntax
> you used below:
>
>> +obj-$(CONFIG_RSI_91x) := rsi_common.o
> for ccflags to clean this up. But you should get rid of the
> -DUSE_XYZ_INTF anyway and use CONFIG_RSI_USB in the code.
>
>> +static int rsi_proc_version_read(struct seq_file *seq, void *data)
> /proc? really? definitely staging material from here on ...
>
>> +/**
>> + * This function is used to put the current execution in a queue
>> + * and reschedules itself for execution on "timeout" or when a
>> + * wakeup is generated.
>> + *
>> + * @param  event Pointer to the event structure.
>> + * @param  timeout Timeout value in msecs.
>> + * @return status: 0 on success, -1 on failure.
>> + */
>> +int rsi_wait_event(struct rsi_event *event, unsigned int timeout)
>> +{
>> +	int status = 0;
>> +
>> +	if (!timeout)
>> +		status = wait_event_interruptible(event->event_queue,
>> +				(atomic_read(&event->event_condition) == 0));
>> +	else
>> +		status = wait_event_interruptible_timeout(event->event_queue,
>> +				(atomic_read(&event->event_condition) == 0),
>> +				timeout);
>> +	return status;
>> +}
> That's probably better inlined.
>
> Along with the rest of the event and thread functionality - doesn't
> really help readability to obscure things behind layers of "OS
> abstractions"...
>
>> +void rsi_print(int zone, unsigned char *vdata, int len)
>> +{
>> +	unsigned short ii;
>> +
>> +	if (!(zone & rsi_zone_enabled))
>> +		return;
>> +
>> +	if (!vdata)
>> +		return;
>> +
>> +	for (ii = 0; ii < len; ii++) {
>> +		if (!(ii % 16))
>> +			pr_info("\n");
>> +		pr_info("%02x ", (vdata[ii]));
>> +	}
>> +	pr_info("\n");
>> +}
> Yeah, umm, see above.
>
>> +	unsigned int bbp_lmac_clk_reg_val:16;
> 16 bit bitfields? Is there anything wrong with u16 (aka unsigned short)
> on your compiler version?
>
> johannes
>
>
>


